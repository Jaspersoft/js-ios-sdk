/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2014 Jaspersoft Corporation. All rights reserved.
 * http://community.jaspersoft.com/project/mobile-sdk-ios
 * 
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 * 
 * This program is part of Jaspersoft Mobile SDK for iOS.
 * 
 * Jaspersoft Mobile SDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Jaspersoft Mobile SDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with Jaspersoft Mobile SDK for iOS. If not, see 
 * <http://www.gnu.org/licenses/lgpl>.
 */

//
//  JSRESTBase.m
//  Jaspersoft Corporation
//

#import "JSRESTBase.h"
#import "JSConstants.h"
#import "RKMIMETypeSerialization.h"
#import "JSSerializationDescriptorHolder.h"
#import "JSErrorDescriptor.h"

#import "JSRESTBase+JSRESTSession.h"

#import "AFHTTPClient.h"
#import "weakself.h"

#import "ServerReachability.h"


// Access key and value for content-type / charset
NSString * const kJSRequestContentType = @"Content-Type";
NSString * const kJSRequestResponceType = @"Accept";

NSString * const kJSSavedSessionServerProfileKey    = @"JSSavedSessionServerProfileKey";
NSString * const kJSSavedSessionTimeoutKey          = @"JSSavedSessionTimeoutKey";
NSString * const kJSSavedSessionKeepSessionKey      = @"JSSavedSessionKeepSessionKey";

// Default value for timeout interval
static NSTimeInterval const _defaultTimeoutInterval = 120;

// Helper template message indicates that request was finished successfully
NSString * const _requestFinishedTemplateMessage = @"Request finished: %@\nResponse: %@";


// Inner JSCallback class contains JSRequest and RKRequest instances.
// JSRequest class uses for setting additional parameters to JSOperationResult
// instance (i.e. downloadDestinationPath for files) which we want to associate
// with returned response (but it cannot be done in any other way).
@interface JSCallBack : NSObject

@property (nonatomic, retain) JSRequest *request;
@property (nonatomic, retain) id restKitOperation;

- (id)initWithRestKitOperation:(id)restKitOperation
                       request:(JSRequest *)request;

@end

@implementation JSCallBack
- (id)initWithRestKitOperation:(id)restKitOperation request:(JSRequest *)request {
    if (self = [super init]) {
        self.request = request;
        self.restKitOperation = restKitOperation;
    }
    return self;
}

@end


@interface RKObjectManager (CopyCredentials)

- (void)copyStateFromHTTPClientToHTTPRequestOperation:(AFHTTPRequestOperation *)operation;

@end

@interface JSRESTBase()

// RestKit's RKObjectManager instance for mapping response (in JSON, XML and other
// formats) directly to object
@property (nonatomic, strong) RKObjectManager *restKitObjectManager;

// List of JSCallBack instances
@property (nonatomic, strong) NSMutableArray *requestCallBacks;

@property (nonatomic, assign, readwrite) BOOL keepSession;

@property (nonatomic, strong) ServerReachability *serverReachability;

@end

@implementation JSRESTBase
@synthesize restKitObjectManager = _restKitObjectManager;
@synthesize serverProfile = _serverProfile;
@synthesize requestCallBacks = _requestCallBacks;
@synthesize timeoutInterval = _timeoutInterval;

#pragma mark -
#pragma mark Initialization

+ (void)initialize {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    NSError *error = nil;
    NSRegularExpression *mimeType = [NSRegularExpression regularExpressionWithPattern:@"application/(.+\\+)?json" options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:mimeType];
        [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
    } else {
        NSString *messageString = [NSString stringWithFormat:@"Unsupported mime type \"%@\"",mimeType.pattern];
        @throw [NSException exceptionWithName:@"Unsupported mime type" reason:messageString userInfo:nil];
    }
}

- (instancetype)initWithServerProfile:(JSProfile *)serverProfile keepLogged:(BOOL)keepLogged{
    self = [super init];
    if (self) {
        self.keepSession = keepLogged;
        self.timeoutInterval = _defaultTimeoutInterval;
        self.serverProfile = serverProfile;
    }
    return self;
}


- (void)setServerProfile:(JSProfile *)serverProfile {
    _serverProfile = serverProfile;
    
    if (serverProfile) {
        // Delete cookies for current server profile. If don't do this old credentials will be used
        // instead new one
        [self deleteCookies];
        
        [self configureRestKitObjectManager];
        
        self.serverReachability = [ServerReachability reachabilityWithServer:serverProfile.serverUrl timeout:[JSConstants sharedInstance].REST_JRS_CONNECTION_TIMEOUT];
    }
}

#pragma mark -
#pragma mark Public methods

- (void)sendRequest:(JSRequest *)request {
    [self sendRequest:request additionalHTTPHeaderFields:nil];
}

- (void)sendRequest:(JSRequest *)jsRequest additionalHTTPHeaderFields:(NSDictionary *)headerFields{
    if (!self.serverReachability.isReachable) {
        [self.serverReachability resetReachabilityStatus];
        [self sendCallBackForRequest:jsRequest withOperationResult:[self requestOperationForFailedConnection]];
        return;
    }
    // Full uri path with query params
    NSString *fullUri = [self fullUri:jsRequest.uri restVersion:jsRequest.restVersion];
    
    
    for (RKRequestDescriptor *descriptor in self.restKitObjectManager.requestDescriptors) {
        [self.restKitObjectManager removeRequestDescriptor:descriptor];
    }
    
    id <JSSerializationDescriptorHolder> descriptiorHolder = jsRequest.body;
    if (descriptiorHolder && [[descriptiorHolder class] respondsToSelector:@selector(rkRequestDescriptorsForServerProfile:)]) {
        [self.restKitObjectManager addRequestDescriptorsFromArray:[[descriptiorHolder class] rkRequestDescriptorsForServerProfile:self.serverProfile]];
    }

    NSMutableURLRequest *urlRequest;
    if (jsRequest.multipartFormConstructingBodyBlock) {
        urlRequest = [self.restKitObjectManager multipartFormRequestWithObject:self
                                                                        method:jsRequest.method
                                                                          path:fullUri
                                                                    parameters:nil
                                                     constructingBodyWithBlock:jsRequest.multipartFormConstructingBodyBlock];
    } else {
        urlRequest = [self.restKitObjectManager requestWithObject:jsRequest.body
                                                                                method:jsRequest.method
                                                                                  path:fullUri
                                                                            parameters:jsRequest.params];
    }

    RKHTTPRequestOperation *httpOperation = [[RKHTTPRequestOperation alloc] initWithRequest:urlRequest];
    NSOperation *requestOperation = httpOperation;
    
    if (jsRequest.responseAsObjects) {
        [self.restKitObjectManager performSelector:@selector(copyStateFromHTTPClientToHTTPRequestOperation:) withObject:httpOperation];
        
        NSArray *responseDescriptors = [jsRequest.expectedModelClass rkResponseDescriptorsForServerProfile:self.serverProfile];
        
        NSMutableArray *fullresponseDescriptors = [NSMutableArray arrayWithArray:responseDescriptors];
        [fullresponseDescriptors addObjectsFromArray:[JSErrorDescriptor rkResponseDescriptorsForServerProfile:self.serverProfile]];
        RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithHTTPRequestOperation:httpOperation responseDescriptors:fullresponseDescriptors];
        
        if (responseDescriptors.count == 0) {
            NSMutableIndexSet *acceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndexSet:httpOperation.acceptableStatusCodes];
            [acceptableStatusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
            httpOperation.acceptableStatusCodes = acceptableStatusCodes;
        }
        
        requestOperation = objectRequestOperation;
    }
    
    if ([urlRequest isKindOfClass:[NSMutableURLRequest class]]) {
        urlRequest.timeoutInterval = self.timeoutInterval;
        if (headerFields && [headerFields count]) {
            NSMutableDictionary *headerFieldsDictionary = [NSMutableDictionary dictionaryWithDictionary:urlRequest.allHTTPHeaderFields];
            [headerFieldsDictionary addEntriesFromDictionary:headerFields];
            [urlRequest setAllHTTPHeaderFields:headerFieldsDictionary];
        }
    }
    
    [httpOperation setRedirectResponseBlock:^NSURLRequest *(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse) {
        if (redirectResponse) {
            if (jsRequest.redirectAllowed) {
                // we don't use the new request built for us, except for the URL
                NSURL *newURL = [request URL];
                // Previously, store the original request in _originalRequest.
                // We rely on that here!
                NSMutableURLRequest *newRequest = [urlRequest mutableCopy];
                [newRequest setURL: newURL];
                return newRequest;
            } else {
                return nil;
            }
        } else {
            return request;
        }
    }];
    
    // Creates bridge between RestKit's delegate and SDK delegate
    [self.requestCallBacks addObject:[[JSCallBack alloc] initWithRestKitOperation:requestOperation request:jsRequest]];
    
    [requestOperation start];
    
    if (jsRequest.asynchronous) {
        [((RKHTTPRequestOperation *)requestOperation) setCompletionBlockWithSuccess:
         @weakself(^(NSOperation *operation, RKMappingResult *mappingResult)) {
             [self sendCallbackAboutOperation:operation];
         } @weakselfend failure:
         @weakself(^(NSOperation *operation, NSError *error)) {
             [self sendCallbackAboutOperation:operation];
         }@weakselfend];
    } else {
        NSInteger maxConcurrentOperationCount = self.restKitObjectManager.HTTPClient.operationQueue.maxConcurrentOperationCount;
        self.restKitObjectManager.HTTPClient.operationQueue.maxConcurrentOperationCount = 1;
        [requestOperation waitUntilFinished];
        self.restKitObjectManager.HTTPClient.operationQueue.maxConcurrentOperationCount = maxConcurrentOperationCount;
        [self sendCallbackAboutOperation:requestOperation];
    }
}

- (JSServerInfo *)serverInfo {
    if (!self.serverProfile.serverInfo) {
        JSRequest *request = [[JSRequest alloc] initWithUri:[JSConstants sharedInstance].REST_SERVER_INFO_URI];
        request.expectedModelClass = [JSServerInfo class];
        request.restVersion = JSRESTVersion_2;
        request.asynchronous = NO;
        request.completionBlock = ^(JSOperationResult *result) {
            if (!result.error && result.objects.count) {
                self.serverProfile.serverInfo = [result.objects firstObject];
                [[RKValueTransformer defaultValueTransformer] addValueTransformer:self.serverInfo.serverDateFormatFormatter];
            }
        };
        [self sendRequest:request];
    }

    return self.serverProfile.serverInfo;
}

- (void)cancelAllRequests {
    [self.requestCallBacks removeAllObjects];
    [self.restKitObjectManager.HTTPClient.operationQueue cancelAllOperations];
    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
}

- (BOOL)isNetworkReachable {
    return (self.restKitObjectManager.HTTPClient.networkReachabilityStatus > 0);
}

- (BOOL)isRequestPoolEmpty
{
    return self.requestCallBacks.count == 0;
}

- (NSArray *)cookies {
    if (self.serverProfile.serverUrl) {
        NSString *host = [[NSURL URLWithString:self.serverProfile.serverUrl] host];
        
        NSMutableArray *cookies = [NSMutableArray array];
        for (NSHTTPCookie *cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
            if ([cookie.domain isEqualToString:host]) {
                [cookies addObject:cookie];
            }
        }
        return [cookies sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 expiresDate] compare:[obj2 expiresDate]];
        }];
    }
    return nil;
}

- (void)deleteCookies {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in self.cookies) {
        [cookieStorage deleteCookie:cookie];
    }
}

- (void)resetReachabilityStatus {
    [self.serverReachability resetReachabilityStatus];
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.serverProfile forKey:kJSSavedSessionServerProfileKey];
    [aCoder encodeBool:self.keepSession forKey:kJSSavedSessionKeepSessionKey];
    [aCoder encodeFloat:self.timeoutInterval forKey:kJSSavedSessionTimeoutKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    JSProfile *serverProfile = [aDecoder decodeObjectForKey:kJSSavedSessionServerProfileKey];
    if (serverProfile) {
        self = [super init];
        if (self) {
            self.serverProfile = serverProfile;
            self.keepSession = [aDecoder decodeBoolForKey:kJSSavedSessionKeepSessionKey];
            self.timeoutInterval = [aDecoder decodeFloatForKey:kJSSavedSessionTimeoutKey];
        }
        return self;
    }
    return nil;
}

#pragma mark -
#pragma mark Private methods

- (void)configureRestKitObjectManager {
    // Creates RKObjectManager for loading and mapping encoded response (i.e XML, JSON etc.)
    // directly to objects
    self.restKitObjectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:self.serverProfile.serverUrl]];
    self.restKitObjectManager.HTTPClient.allowsInvalidSSLCertificate = YES;
    [self.restKitObjectManager.HTTPClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Sets default content-type to object manager
    self.restKitObjectManager.requestSerializationMIMEType = [JSConstants sharedInstance].REST_SDK_MIMETYPE_USED;
    [self.restKitObjectManager setAcceptHeaderWithMIMEType:[JSConstants sharedInstance].REST_SDK_MIMETYPE_USED];

    self.requestCallBacks = [NSMutableArray new];
    [RKValueTransformer setDefaultValueTransformer:nil];
}

// Gets full uri (including rest prefix)
- (NSString *)fullUri:(NSString *)uri restVersion:(JSRESTVersion)restVersion {
    JSConstants *constants = [JSConstants sharedInstance];
    NSString *restServiceUri = nil;
    
    switch (restVersion) {
        case JSRESTVersion_2:
            restServiceUri = constants.REST_SERVICES_V2_URI;
            break;
            
        case JSRESTVersion_1:
            restServiceUri = constants.REST_SERVICES_URI;
            break;
        default:
            restServiceUri = @"";
    }
    
    // Remove all [] for query params (i.e. query &PL_Country_multi_select[]=Mexico&PL_Country_multi_select[]=USA will
    // be changed to &PL_Country_multi_select=Mexico&PL_Country_multi_select=USA without any [])
    NSString *brackets = @"[]";
    if ([uri rangeOfString:brackets].location != NSNotFound) {
        uri = [uri stringByReplacingOccurrencesOfString:brackets withString:@""];
    }
    
    return [NSString stringWithFormat:@"%@%@", restServiceUri, (uri ?: @"")];
}

// Initializes result with helping properties: http status code,
// returned header fields and MIMEType
- (JSOperationResult *)operationResultWithOperation:(id)restKitOperation{
    RKHTTPRequestOperation *httpOperation = [restKitOperation isKindOfClass:[RKObjectRequestOperation class]] ? [restKitOperation HTTPRequestOperation] : restKitOperation;
    
    JSOperationResult *result = [[JSOperationResult alloc] initWithStatusCode:httpOperation.response.statusCode
                                                              allHeaderFields:httpOperation.response.allHeaderFields
                                                                     MIMEType:httpOperation.response.MIMEType];
 
    result.body = httpOperation.responseData;

    // Error handling
    result.request = [self callBackForOperation:restKitOperation].request;
    if ([result.request.uri isEqualToString:[JSConstants sharedInstance].REST_AUTHENTICATION_URI]) {
        NSString *redirectURL = [httpOperation.response.allHeaderFields objectForKey:@"Location"];
        
        NSString *redirectUrlRegex = [NSString stringWithFormat:@"%@/login.html;((jsessionid=.+)?)\\?error=1", self.serverProfile.serverUrl];
        
        NSPredicate *redirectUrlValidator = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", redirectUrlRegex];
        if ([redirectUrlValidator evaluateWithObject:redirectURL]) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey :[NSHTTPURLResponse localizedStringForStatusCode:401]};
            result.error = [NSError errorWithDomain:NSURLErrorDomain code:JSInvalidCredentialsErrorCode userInfo:userInfo];
        } else if([restKitOperation error]) {
            result.error = [restKitOperation error];
        } else {
            result.error = nil;
        }
    } else {
        NSError *operationError = ([restKitOperation error]) ? [restKitOperation error] : [httpOperation error];
        if (![result isSuccessful] || operationError) {
            NSString *errorDomain = operationError.domain;
            NSString *errorDescription;
            NSInteger errorCode;
            
            if (httpOperation.response.statusCode == 401) {
                errorCode = JSSessionExpiredErrorCode;
                errorDomain = NSURLErrorDomain;
                errorDescription = [NSHTTPURLResponse localizedStringForStatusCode:httpOperation.response.statusCode];
            } else if (httpOperation.response.statusCode && !operationError) {
                errorCode = JSNetworkErrorCode;
                errorDomain = NSURLErrorDomain;
                errorDescription = [NSHTTPURLResponse localizedStringForStatusCode:httpOperation.response.statusCode];
            } else if ([operationError.domain isEqualToString:NSURLErrorDomain] || [operationError.domain isEqualToString:AFNetworkingErrorDomain]) {
                switch (operationError.code) {
                    case NSURLErrorUserCancelledAuthentication:
                    case NSURLErrorUserAuthenticationRequired:
                        errorCode = JSSessionExpiredErrorCode;
                        errorDescription = [NSHTTPURLResponse localizedStringForStatusCode:401];
                        break;
                    case NSURLErrorTimedOut:
                        errorCode = JSRequestTimeOutErrorCode;
                        break;
                    default:
                        errorCode = JSNetworkErrorCode;
                }
            } else {
                if ([operationError.userInfo objectForKey:RKObjectMapperErrorObjectsKey]) {
                    result.objects = [operationError.userInfo objectForKey:RKObjectMapperErrorObjectsKey];
                    errorCode = JSClientErrorCode;
                } else if ([operationError.userInfo objectForKey:RKDetailedErrorsKey]) {
                    result.objects = [operationError.userInfo objectForKey:RKDetailedErrorsKey];
                    errorCode = JSDataMappingErrorCode;
                } else {
                    errorCode = JSOtherErrorCode;
                }
                if (result.objects && [result.objects count]) {
                    errorDescription = @"";
                    for (JSErrorDescriptor *errDescriptor in result.objects) {
                        if ([errDescriptor isKindOfClass:[errDescriptor class]]) {
                            NSString *formatString = errorDescription.length ? @",\n%@" : @"%@";
                            errorDescription = [errorDescription stringByAppendingFormat:formatString, errDescriptor.message];
                        }
                    }
                }
            }
            NSDictionary *userInfo = errorDescription ? @{NSLocalizedDescriptionKey : errorDescription} : operationError.userInfo;
            result.error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:userInfo];
        } else {
            if ([restKitOperation isKindOfClass:[RKObjectRequestOperation class]]) {
                RKObjectRequestOperation *objectOperation = (RKObjectRequestOperation *)restKitOperation;
                if (objectOperation.mappingResult) {
                    result.objects = [objectOperation.mappingResult array];
                }
            }
        }
    }
    if (result.error.code == JSSessionExpiredErrorCode) {
        [self deleteCookies];
    }
    return result;
}

- (void)sendCallbackAboutOperation:(id)restKitOperation{
    JSOperationResult *result = [self operationResultWithOperation:restKitOperation];
    
    JSCallBack *callBack = [self callBackForOperation:restKitOperation];
    if (callBack) {
        [self.requestCallBacks removeObject:callBack];
        
#ifndef __RELEASE__
        RKHTTPRequestOperation *httpOperation = [restKitOperation isKindOfClass:[RKObjectRequestOperation class]] ? [restKitOperation HTTPRequestOperation] : restKitOperation;
        NSLog(_requestFinishedTemplateMessage, [httpOperation.request.URL absoluteString], [result bodyAsString]);
#endif
        [self sendCallBackForRequest:callBack.request withOperationResult:result];
    }
}

- (void) sendCallBackForRequest:(JSRequest *)request withOperationResult:(JSOperationResult *)result {
    result.request = request;
    
    if (!result.error && !result.request.responseAsObjects && [result.request.downloadDestinationPath length]) {
        NSError *fileSavingError = nil;
        [result.body writeToFile:result.request.downloadDestinationPath options:NSDataWritingAtomic error:&fileSavingError];
        if (fileSavingError) {
            result.error = [NSError errorWithDomain:NSCocoaErrorDomain code:JSFileSavingErrorCode userInfo:fileSavingError.userInfo];
        }
    }
    
    if (request.completionBlock) {
        request.completionBlock(result);
    }
}

- (JSCallBack *)callBackForOperation:(id)restKitOperation {
    for (JSCallBack *callBack in self.requestCallBacks) {
        if (callBack.restKitOperation == restKitOperation) {
            return callBack;
        }
    }
    return nil;
}

- (JSOperationResult *) requestOperationForFailedConnection {
    JSOperationResult *result = [JSOperationResult new];
    
    result.error = [NSError errorWithDomain:NSURLErrorDomain code:JSServerNotReachableErrorCode userInfo:@{NSLocalizedDescriptionKey : [NSHTTPURLResponse localizedStringForStatusCode:502]}];
    return result;
}

@end
