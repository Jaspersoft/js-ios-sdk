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
#import "EKMappingProtocol.h"
#import "JSErrorDescriptor.h"
#import "JSRESTBase+JSRESTSession.h"
#import "ServerReachability.h"
#import "JSErrorBuilder.h"
#import "AFNetworkActivityIndicatorManager.h"

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


// Inner JSCallback class contains JSRequest and NSURLSessionTask instances.
// JSRequest class uses for setting additional parameters to JSOperationResult
// instance (i.e. downloadDestinationPath for files) which we want to associate
// with returned response (but it cannot be done in any other way).
@interface JSCallBack : NSObject

@property (nonatomic, retain) JSRequest *request;
@property (nonatomic, retain) NSURLSessionTask *dataTask;

- (id)initWithDataTask:(NSURLSessionTask *)restKitOpdataTaskeration request:(JSRequest *)request;

@end

@implementation JSCallBack
- (id)initWithDataTask:(NSURLSessionTask *)dataTask request:(JSRequest *)request {
    if (self = [super init]) {
        self.request = request;
        self.dataTask = dataTask;
    }
    return self;
}

@end


@interface JSRESTBase()

@property (nonatomic, strong, readwrite, nonnull) JSProfile *serverProfile;

// List of JSCallBack instances
@property (nonatomic, strong) NSMutableArray <JSCallBack *> *requestCallBacks;

@property (nonatomic, assign, readwrite) BOOL keepSession;

@property (nonatomic, strong) ServerReachability *serverReachability;

@end

@implementation JSRESTBase
@synthesize serverProfile = _serverProfile;
@synthesize requestCallBacks = _requestCallBacks;
@synthesize timeoutInterval = _timeoutInterval;

#pragma mark -
#pragma mark Initialization

+ (void)initialize {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

- (nonnull instancetype) initWithServerProfile:(nonnull JSProfile *)serverProfile keepLogged:(BOOL)keepLogged{
    return [self initWithServerProfile:serverProfile keepLogged:keepLogged deleteCookies:YES];
}

- (nonnull instancetype) initWithServerProfile:(nonnull JSProfile *)serverProfile keepLogged:(BOOL)keepLogged deleteCookies:(BOOL)deleteCookies{
    self = [super initWithBaseURL:[NSURL URLWithString:serverProfile.serverUrl]];
    if (self) {
        if (deleteCookies) {
            // Delete cookies for current server profile. If don't do this old credentials will be used
            // instead new one
            [self deleteCookies];
        }
        self.keepSession = keepLogged;
        self.timeoutInterval = _defaultTimeoutInterval;
        self.serverProfile = serverProfile;

        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.requestCallBacks = [NSMutableArray new];
        self.serverReachability = [ServerReachability reachabilityWithServer:serverProfile.serverUrl timeout:[JSUtils checkServerConnectionTimeout]];

        __weak typeof(self) weakSelf = self;
        [self setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
            if (response) {
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    JSRequest *jsRequest = [strongSelf callBackForDataTask:task].request;
                    if (jsRequest.redirectAllowed) {
                        // we don't use the new request built for us, except for the URL
                        NSURL *newURL = [request URL];
                        // We rely on that here!
                        NSMutableURLRequest *newRequest = [request mutableCopy];
                        [newRequest setURL: newURL];
                        return newRequest;
                    }
                }
                return nil;
            } else {
                return request;
            }
        }];

    }
    return self;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    self.requestSerializer.timeoutInterval = timeoutInterval;
    self.session.configuration.timeoutIntervalForRequest = timeoutInterval;
}


#pragma mark -
#pragma mark Public methods

- (void)sendRequest:(nonnull JSRequest *)jsRequest {
    if (!self.serverReachability.isReachable) {
        [self.serverReachability resetReachabilityStatus];
        [self sendCallBackForRequest:jsRequest withOperationResult:[self requestOperationForFailedConnection]];
        return;
    }
    
    id parameters = jsRequest.body ? : jsRequest.params;
    
    // Apply additional HTTP headers
    if (jsRequest.additionalHeaders.count) {
        NSMutableArray *alreadyInstalledHeaders = [[[self.requestSerializer HTTPRequestHeaders] allKeys] mutableCopy];
        [alreadyInstalledHeaders addObjectsFromArray:[jsRequest.additionalHeaders allKeys]];
        for (NSString *headerKey in alreadyInstalledHeaders) {
            [self.requestSerializer setValue:jsRequest.additionalHeaders[headerKey] forHTTPHeaderField:headerKey];
        }
    }
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:jsRequest.httpMethod
                                                                   URLString:[[NSURL URLWithString:jsRequest.fullURI relativeToURL:self.baseURL] absoluteString]
                                                                  parameters:parameters error:&serializationError];
    if (serializationError) {
#warning HERE NEED HANDLE ERROR!!!
        //        if (failure) {
        //#pragma clang diagnostic push
        //#pragma clang diagnostic ignored "-Wgnu"
        //            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
        //                failure(nil, serializationError);
        //            });
        //#pragma clang diagnostic pop
        //        }
        //
        return;
    }
    
    dispatch_semaphore_t semaphore = nil;
    if (!jsRequest.asynchronous) {
        semaphore = dispatch_semaphore_create(0);
    }
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request
                                                uploadProgress:nil
                                              downloadProgress:nil
                                             completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                                 if (jsRequest.completionBlock) {
                                                     NSMutableArray *array = [@[response] mutableCopy];
                                                     if (responseObject) {
                                                         [array addObject:responseObject];
                                                     }
                                                     if (error) {
                                                         [array addObject:error];
                                                     }
                                                     
                                                     jsRequest.completionBlock(array);
                                                 }
                                                 if (error) {
                                                 } else {
                                                 }
                                                 if (semaphore) {
                                                     dispatch_semaphore_signal(semaphore);
                                                 }
                                             }];
    // Creates bridge between RestKit's delegate and SDK delegate
    [self.requestCallBacks addObject:[[JSCallBack alloc] initWithDataTask:dataTask
                                                                  request:jsRequest]];
    [dataTask resume];
    
    if(semaphore) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
    
    //    if (jsRequest.responseAsObjects) {
//        [self.restKitObjectManager performSelector:@selector(copyStateFromHTTPClientToHTTPRequestOperation:) withObject:httpOperation];
//        
//        NSArray *responseDescriptors = [jsRequest.expectedModelClass rkResponseDescriptorsForServerProfile:self.serverProfile];
//        
//        NSMutableArray *fullresponseDescriptors = [NSMutableArray arrayWithArray:responseDescriptors];
//        [fullresponseDescriptors addObjectsFromArray:[JSErrorDescriptor rkResponseDescriptorsForServerProfile:self.serverProfile]];
//        RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithHTTPRequestOperation:httpOperation responseDescriptors:fullresponseDescriptors];
//        
//        if (responseDescriptors.count == 0) {
//            NSMutableIndexSet *acceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndexSet:httpOperation.acceptableStatusCodes];
//            [acceptableStatusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//            httpOperation.acceptableStatusCodes = acceptableStatusCodes;
//        }
//        
//        requestOperation = objectRequestOperation;
//    }

    
}

- (nullable JSServerInfo *)serverInfo {
    if (!self.serverProfile.serverInfo) {
        JSRequest *request = [[JSRequest alloc] initWithUri:kJS_REST_SERVER_INFO_URI];
        request.expectedModelClass = [JSServerInfo class];
        request.restVersion = JSRESTVersion_2;
        request.asynchronous = NO;
        request.completionBlock = ^(JSOperationResult *result) {
            if (!result.error && result.objects.count) {
                self.serverProfile.serverInfo = [result.objects firstObject];
            }
        };
        [self sendRequest:request];
    }

    return self.serverProfile.serverInfo;
}

- (void)cancelAllRequests {
    [self.session invalidateAndCancel];
    
    [self.requestCallBacks removeAllObjects];
}

- (BOOL)isNetworkReachable {
    return (self.reachabilityManager.networkReachabilityStatus > 0);
}

- (BOOL)isRequestPoolEmpty
{
    return self.requestCallBacks.count == 0;
}

- (NSArray *)cookies {
    if (self.serverProfile.serverUrl) {
        NSString *host = [[NSURL URLWithString:self.serverProfile.serverUrl] host];
        
        NSMutableArray *cookies = [NSMutableArray array];
        for (NSHTTPCookie *cookie in self.session.configuration.HTTPCookieStorage.cookies) {
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
#warning NEED CHECK CONFIGURATION COOKIE STORAGE INITIALISATION
    NSHTTPCookieStorage *cookieStorage = self.session.configuration.HTTPCookieStorage;
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

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSRESTBase *newRestClient = [[JSRESTBase allocWithZone:zone] initWithServerProfile:self.serverProfile keepLogged:self.keepSession deleteCookies:NO];
    newRestClient.timeoutInterval = self.timeoutInterval;
    return newRestClient;
}

#pragma mark -
#pragma mark Private methods

// Initializes result with helping properties: http status code,
// returned header fields and MIMEType
- (JSOperationResult *)operationResultForRequest:(JSRequest *)request withResponce:(NSHTTPURLResponse *)response responseObject:(id)responseObject error:(NSError *)error{
    JSOperationResult *result = [[JSOperationResult alloc] initWithStatusCode:response.statusCode
                                                              allHeaderFields:response.allHeaderFields
                                                                     MIMEType:response.MIMEType];
 
#warning NEED CHECK BODY TYPE!!!
    result.body = responseObject;

    // Error handling
    result.request = request;
    if ([result.request.uri isEqualToString:kJS_REST_AUTHENTICATION_URI]) {
        NSString *redirectURL = [response.allHeaderFields objectForKey:@"Location"];
        
        NSString *redirectUrlRegex = [NSString stringWithFormat:@"%@/login.html;((jsessionid=.+)?)\\?error=1", self.serverProfile.serverUrl];
        
        NSPredicate *redirectUrlValidator = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", redirectUrlRegex];
        if ([redirectUrlValidator evaluateWithObject:redirectURL]) {
            result.error = [JSErrorBuilder errorWithCode:JSInvalidCredentialsErrorCode];
        } else if(error) {
            result.error = error;
        } else {
            result.error = nil;
        }
    } else {
        NSError *operationError = error;
        if (![result isSuccessful] || operationError) {
            
            NSError *error;
            if (response.statusCode == 401) {
                error = [JSErrorBuilder httpErrorWithCode:JSSessionExpiredErrorCode
                                                 HTTPCode:response.statusCode];
                
            } else if (response.statusCode && !operationError) {
                error = [JSErrorBuilder httpErrorWithCode:JSHTTPErrorCode
                                                 HTTPCode:response.statusCode];
                
            } else if ([operationError.domain isEqualToString:NSURLErrorDomain]) {
                switch (operationError.code) {
                    case NSURLErrorUserCancelledAuthentication:
                    case NSURLErrorUserAuthenticationRequired: {
                        error = [JSErrorBuilder errorWithCode:JSSessionExpiredErrorCode];
                        break;
                    }
                    case NSURLErrorTimedOut: {
                        // TODO: Create Error message
                        error = [JSErrorBuilder errorWithCode:JSRequestTimeOutErrorCode];
                        break;
                    }
                    default: {
                        error = [JSErrorBuilder httpErrorWithCode:JSHTTPErrorCode
                                                         HTTPCode:response.statusCode];
                    }
                }
                
                //            } else {
                //
                //                JSErrorCode code = JSOtherErrorCode;
                //                if (operationError.userInfo[RKObjectMapperErrorObjectsKey]) {
                //                    result.objects = operationError.userInfo[RKObjectMapperErrorObjectsKey];
                //                    code = JSClientErrorCode;
                //                } else if (operationError.userInfo[RKDetailedErrorsKey]) {
                //                    result.objects = operationError.userInfo[RKDetailedErrorsKey];
                //                    code = JSDataMappingErrorCode;
                //                }
                //
                //                NSString *message;
                //                if (result.objects && [result.objects count]) {
                //                    message = @"";
                //                    for (JSErrorDescriptor *errDescriptor in result.objects) {
                //                        if ([errDescriptor isKindOfClass:[errDescriptor class]]) {
                //                            NSString *formatString = message.length ? @",\n%@" : @"%@";
                //                            message = [message stringByAppendingFormat:formatString, errDescriptor.message];
                //                        }
                //                    }
                //                }
                //
                //                error = [JSErrorBuilder errorWithCode:code message:message];
                //            }
                //
                //            result.error = error;
                //        } else {
                //            if ([restKitOperation isKindOfClass:[RKObjectRequestOperation class]]) {
                //                RKObjectRequestOperation *objectOperation = (RKObjectRequestOperation *)restKitOperation;
                //                if (objectOperation.mappingResult) {
                //                    result.objects = [objectOperation.mappingResult array];
                //                }
                //            }
            }
        }
        if (result.error.code == JSSessionExpiredErrorCode) {
            [self deleteCookies];
        }
        return result;
    }
}
    
- (void)sendCallbackAboutOperation:(id)restKitOperation{
//    JSOperationResult *result = [self operationResultWithOperation:restKitOperation];
//    
//    JSCallBack *callBack = [self callBackForOperation:restKitOperation];
//    if (callBack) {
//        [self.requestCallBacks removeObject:callBack];
//        
//#ifndef __RELEASE__
//        RKHTTPRequestOperation *httpOperation = [restKitOperation isKindOfClass:[RKObjectRequestOperation class]] ? [restKitOperation HTTPRequestOperation] : restKitOperation;
//        NSLog(_requestFinishedTemplateMessage, [httpOperation.request.URL absoluteString], [result bodyAsString]);
//#endif
//        if (callBack.request.shouldResendRequestAfterSessionExpiration && result.error && result.error.code == JSSessionExpiredErrorCode && self.keepSession) {
//            __weak typeof(self)weakSelf = self;
//            [self verifyIsSessionAuthorizedWithCompletion:^(BOOL isSessionAuthorized) {
//                __strong typeof(self)strongSelf = weakSelf;
//                if (isSessionAuthorized) {
//                    [strongSelf sendRequest:callBack.request];
//                } else {
//                    [strongSelf sendCallBackForRequest:callBack.request withOperationResult:result];
//                }
//            }];
//        } else {
//            [self sendCallBackForRequest:callBack.request withOperationResult:result];
//        }
//    }
}

- (void) sendCallBackForRequest:(JSRequest *)request withOperationResult:(JSOperationResult *)result {
    result.request = request;
    
    if (!result.error && !result.request.responseAsObjects && [result.request.downloadDestinationPath length]) {
        NSError *fileSavingError = nil;
        [result.body writeToFile:result.request.downloadDestinationPath
                         options:NSDataWritingAtomic
                           error:&fileSavingError];

        if (fileSavingError) {
            result.error = [JSErrorBuilder errorWithCode:JSFileSavingErrorCode
                                                                 message:fileSavingError.userInfo[NSLocalizedDescriptionKey]];
        }
    }
    
    if (request.completionBlock) {
        request.completionBlock(result);
    }
}

- (JSCallBack *)callBackForDataTask:(NSURLSessionTask *)dataTask {
    for (JSCallBack *callBack in self.requestCallBacks) {
        if (callBack.dataTask == dataTask) {
            return callBack;
        }
    }
    return nil;
}

- (JSOperationResult *) requestOperationForFailedConnection {
    JSOperationResult *result = [JSOperationResult new];
    result.error = [JSErrorBuilder errorWithCode:JSServerNotReachableErrorCode];
    return result;
}

@end
