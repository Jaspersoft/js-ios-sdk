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
#import "JSRestKitManagerFactory.h"
#import "RKMIMETypeSerialization.h"
#import "JSSerializationDescriptorHolder.h"
#import "JSErrorDescriptor.h"

#import "AFHTTPClient.h"
#import "weakself.h"

// Access key and value for content-type / charset
NSString * const kJSRequestCharset = @"Charset";
NSString * const kJSRequestContentType = @"Content-Type";
NSString * const kJSRequestResponceType = @"Accept";


// Default value for timeout interval
static NSTimeInterval const _defaultTimeoutInterval = 120;

// Helper template message indicates that request was finished successfully
static NSString * const _requestFinishedTemplateMessage = @"Request finished: %@";

// Inner JSCallback class contains JSRequest and RKRequest instances. 
// JSRequest instance contains delegate object and finished block so actually this 
// instance is bridge between RestKit's delegate and library delegate (or finished block)
// Also JSRequest class uses for setting additional parameters to JSOperationResult
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

// Hidden implementation of RKObjectLoaderDelegate protocol and private properties
@interface JSRESTBase()

// RestKit's RKObjectManager instance for mapping response (in JSON, XML and other
// formats) directly to object
@property (nonatomic, strong) RKObjectManager *restKitObjectManager;

// List of JSCallBack instances
@property (nonatomic, strong) NSMutableArray *requestCallBacks;

// List of classes For Mappings
@property (nonatomic, strong) NSArray *classesForMappings;

@end

@implementation JSRESTBase
@synthesize restKitObjectManager = _restKitObjectManager;
@synthesize serverProfile = _serverProfile;
@synthesize requestCallBacks = _requestCallBacks;
@synthesize timeoutInterval = _timeoutInterval;

#pragma mark -
#pragma mark Initialization

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        NSError *error = nil;
        NSRegularExpression *mimeType = [NSRegularExpression regularExpressionWithPattern:@"application/(.+\\+)?json" options:NSRegularExpressionCaseInsensitive error:&error];
        if (!error) {
            [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:mimeType];
        } else {
            NSString *messageString = [NSString stringWithFormat:@"Unsupported mime type \"%@\"",mimeType.pattern];
            @throw [NSException exceptionWithName:@"Unsupported mime type" reason:messageString userInfo:nil];
        }
    });
}

- (id)initWithClassesForMappings:(NSArray *)classes {
    if (self = [super init]) {
        
        self.classesForMappings = classes;
        self.timeoutInterval = _defaultTimeoutInterval;
    }
    
    return self;
}

- (id)init {
    return [self initWithClassesForMappings:nil];
}

- (void)setServerProfile:(JSProfile *)serverProfile {
    _serverProfile = serverProfile;
    
    // Delete cookies for current server profile. If don't do this old credentials will be used
    // instead new one
    [self deleteCookies];
    
    [self configureRestKitObjectManager];
}

#pragma mark -
#pragma mark Public methods

- (void)sendRequest:(JSRequest *)request {
    [self sendRequest:request additionalHTTPHeaderFields:nil];
}

- (void)sendRequest:(JSRequest *)request additionalHTTPHeaderFields:(NSDictionary *)headerFields{
    // Full uri path with query params
    NSString *fullUri = [self fullUri:request.uri restVersion:request.restVersion];
    

    for (RKRequestDescriptor *descriptor in self.restKitObjectManager.requestDescriptors) {
        [self.restKitObjectManager removeRequestDescriptor:descriptor];
    }
    
    id <JSSerializationDescriptorHolder> descriptiorHolder = request.body;
    if (descriptiorHolder && [[descriptiorHolder class] respondsToSelector:@selector(rkRequestDescriptorsForServerProfile:)]) {
        [self.restKitObjectManager addRequestDescriptorsFromArray:[[descriptiorHolder class] rkRequestDescriptorsForServerProfile:self.serverProfile]];
    }
    
    NSOperation *requestOperation = nil;
    NSMutableURLRequest *urlRequest = [self.restKitObjectManager requestWithObject:request.body method:request.method path:fullUri parameters:request.params];
    if (request.responseAsObjects) {
        RKHTTPRequestOperation *HTTPRequestOperation = [[RKHTTPRequestOperation alloc] initWithRequest:urlRequest];
        [self.restKitObjectManager performSelector:@selector(copyStateFromHTTPClientToHTTPRequestOperation:) withObject:HTTPRequestOperation];
        NSMutableArray *responseDescriptors = [NSMutableArray arrayWithArray:[request.expectedModelClass rkResponseDescriptorsForServerProfile:self.serverProfile]];
        [responseDescriptors addObjectsFromArray:[JSErrorDescriptor rkResponseDescriptorsForServerProfile:self.serverProfile]];
        RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithHTTPRequestOperation:HTTPRequestOperation responseDescriptors:responseDescriptors];
        requestOperation = objectRequestOperation;
    } else {
        requestOperation = [[RKHTTPRequestOperation alloc] initWithRequest:urlRequest];
    }

    if ([urlRequest isKindOfClass:[NSMutableURLRequest class]]) {
        urlRequest.timeoutInterval = self.timeoutInterval;
        if (headerFields && [headerFields count]) {
            NSMutableDictionary *headerFieldsDictionary = [NSMutableDictionary dictionaryWithDictionary:urlRequest.allHTTPHeaderFields];
            [headerFieldsDictionary addEntriesFromDictionary:headerFields];
            [urlRequest setAllHTTPHeaderFields:headerFieldsDictionary];
        }
    }
    
    // Creates bridge between RestKit's delegate and SDK delegate
    [self.requestCallBacks addObject:[[JSCallBack alloc] initWithRestKitOperation:requestOperation request:request]];
    
    [requestOperation start];
    
    if (request.asynchronous) {
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
        JSRequest *request = [self serverInfoRequest:NO];
        request.finishedBlock = ^(JSOperationResult *result) {
            [self setServerInfo:result];
        };
        [self sendRequest:request];
    }

    return self.serverProfile.serverInfo;
}

- (void)serverInfo:(id<JSRequestDelegate>)delegate {
    JSRequest *request = [self serverInfoRequest:YES];
    request.finishedBlock = ^(JSOperationResult *result) {
        result = [self setServerInfo:result];
        [delegate requestFinished:result];
    };
    [self sendRequest:request];
}

- (void)cancelRequestsWithDelegate:(id<JSRequestDelegate>)delegate {
    NSMutableIndexSet *indexesOfRemovingCallBacks = [[NSMutableIndexSet alloc] init];
    JSCallBack *callBack = nil;
    
    for (int i = 0; i < self.requestCallBacks.count; i++) {
        callBack = [self.requestCallBacks objectAtIndex:i];
        if (callBack.request.delegate == delegate) {
            [callBack.restKitOperation cancel];
            [indexesOfRemovingCallBacks addIndex:i];
        }
    }
    
    [self.requestCallBacks removeObjectsAtIndexes:indexesOfRemovingCallBacks];
}

- (void)cancelAllRequests {
    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
    [self.requestCallBacks removeAllObjects];
}

- (BOOL)isNetworkReachable {
    return (self.restKitObjectManager.HTTPClient.networkReachabilityStatus > 0);
}


- (NSArray *)cookies {
    if (!self.serverProfile.serverUrl) return nil;

    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSString *host = [[NSURL URLWithString:self.serverProfile.serverUrl] host];

    NSMutableArray *cookies = [NSMutableArray array];
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        if ([cookie.domain isEqualToString:host]) {
            [cookies addObject:cookie];
        }
    }

    return cookies;
}

#pragma mark -
#pragma mark Private methods

- (void)configureRestKitObjectManager {
    self.restKitObjectManager = [JSRestKitManagerFactory createRestKitObjectManagerForClasses:self.classesForMappings andServerProfile:self.serverProfile];
    self.requestCallBacks = [[NSMutableArray alloc] init];
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
        default:
            restServiceUri = constants.REST_SERVICES_URI;
            break;
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
    NSError *operationError = [restKitOperation error];
    
    // If we have an error but response was success (server returned body)
    // error with server message will be created
    if (operationError && [restKitOperation isKindOfClass:[RKObjectRequestOperation class]]) {
        RKObjectRequestOperation *objectOperation = (RKObjectRequestOperation *)restKitOperation;
        if (!objectOperation.mappingResult && objectOperation.error){
            NSArray *objectMapperErrorObjects = [objectOperation.error.userInfo objectForKey:RKObjectMapperErrorObjectsKey];
            NSMutableString *codeString = [NSMutableString string];
            NSMutableString *messageString = [NSMutableString string];
            for (id object in objectMapperErrorObjects) {
                if ([object isKindOfClass:[JSErrorDescriptor class]]) {
                    [codeString appendFormat: [codeString length] ? @", %@" : @"%@", [object errorCode]];
                    [messageString appendFormat: [messageString length] ? @", %@" : @"%@", [object message]];
                }
            }
            if ([codeString length] || [messageString length]) {
                operationError = [NSError errorWithDomain:codeString code:httpOperation.response.statusCode userInfo:@{NSLocalizedDescriptionKey : messageString}];
            }
        }
    }

    JSOperationResult *result = [[JSOperationResult alloc] initWithStatusCode:httpOperation.response.statusCode
                                         allHeaderFields:httpOperation.response.allHeaderFields
                                                MIMEType:httpOperation.response.MIMEType
                                                   error:httpOperation.error];
    result.body = httpOperation.responseData;
    result.bodyAsString = httpOperation.responseString;
    if ([restKitOperation isKindOfClass:[RKObjectRequestOperation class]]) {
        RKObjectRequestOperation *objectOperation = (RKObjectRequestOperation *)restKitOperation;
        if (objectOperation.mappingResult) {
            result.objects = [objectOperation.mappingResult array];
        } else if (objectOperation.error){
            result.objects = [objectOperation.error.userInfo objectForKey:RKObjectMapperErrorObjectsKey];
        }
    }
    return result;
}

- (void)sendCallbackAboutOperation:(id)restKitOperation{
    JSOperationResult *result = [self operationResultWithOperation:restKitOperation];
    
    for (JSCallBack *callBack in self.requestCallBacks) {
        if (callBack.restKitOperation == restKitOperation) {
            RKHTTPRequestOperation *httpOperation = [restKitOperation isKindOfClass:[RKObjectRequestOperation class]] ? [restKitOperation HTTPRequestOperation] : restKitOperation;
            NSLog(_requestFinishedTemplateMessage, [httpOperation.request.URL absoluteString]);
            result.request = callBack.request;
            
            [callBack.request.delegate requestFinished:result];
            if (callBack.request.finishedBlock) {
                callBack.request.finishedBlock(result);
            }

            if (remove) {
                [self.requestCallBacks removeObject: callBack];
            }
            break;
        }
    }
}

// Deletes all cookies for specified server
- (void)deleteCookies {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in self.cookies) {
        [cookieStorage deleteCookie:cookie];
    }
}

- (JSRequest *)serverInfoRequest:(BOOL)isAsynchronous {
    JSRequest *request = [[JSRequest alloc] initWithUri:[JSConstants sharedInstance].REST_SERVER_INFO_URI];
    request.expectedModelClass = [JSServerInfo class];
    request.restVersion = JSRESTVersion_2;
    request.asynchronous = isAsynchronous;
    return request;
}

- (JSOperationResult *)setServerInfo:(JSOperationResult *)result {
    if (result.error || (result.isError && result.statusCode != 404)) return result;

    if (result.objects.count) {
        self.serverProfile.serverInfo = [result.objects objectAtIndex:0];
    } else {
        self.serverProfile.serverInfo = [[JSServerInfo alloc] init];

        JSRequest *request = result.request;
        result = [[JSOperationResult alloc] initWithStatusCode:203
                                               allHeaderFields:result.allHeaderFields
                                                      MIMEType:result.MIMEType
                                                         error:nil];
        result.request = request;
    }

    return result;
}

- (NSArray *)classesForMappings {
    NSMutableArray *classesArray = [NSMutableArray arrayWithArray:_classesForMappings];
    [classesArray addObject:[JSServerInfo class]];
    return classesArray;
}

//#pragma mark -
//#pragma mark RKObjectLoaderDelegate protocol callbacks
//
//- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
//    JSOperationResult *result = [self operationResultWithResponse:objectLoader.response error:nil];
//    result.objects = objects;
//    [self callRequestFinishedCallBackForRestKitRequest:objectLoader result:result];
//}
//
//- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
//    JSOperationResult *result = nil;
//    NSString *mapperKeyPath = nil;
//    NSArray *RKObjectMapperErrorObjects = [error.userInfo objectForKey:RKObjectMapperErrorObjectsKey];
//    
//    
//    // Get mapper key path from error.userInfo dictionary
//    for (NSString *key in error.userInfo.allKeys) {
//        id value = [error.userInfo objectForKey:key];
//        if ([value respondsToSelector:@selector(isEqualToString:)] && 
//            [value isEqualToString:_keyRKObjectMapperKeyPath]) {
//            mapperKeyPath = key;
//            break;
//        }
//    }
//    
//    // If we have an error (most of all mapping) but response was success (server returned body)
//    // error with server message will be created
//    if (objectLoader.response.isClientError && 
//        objectLoader.response.bodyAsString.length) {
//        NSMutableDictionary *errorDetail = [[NSMutableDictionary alloc] init];
//        [errorDetail setObject:objectLoader.response.bodyAsString forKey:NSLocalizedDescriptionKey];
//        error = [NSError errorWithDomain:error.domain code:error.code userInfo:errorDetail];
//    }
//    
//    // Check if response is not an empty XML list (i.e. <resourceDescriptors></resourceDescriptors>).
//    // RestKit interpret this as mapping error
//    if ([mapperKeyPath isEqualToString:@""]) {
//        result = [self operationResultWithResponse:objectLoader.response error:nil];
//        result.objects = [NSArray array];
//    } else {
//        result = [self operationResultWithResponse:objectLoader.response error:error];
//    }
//    
//    result.objects = RKObjectMapperErrorObjects;
//    
//    [self callRequestFinishedCallBackForRestKitRequest:objectLoader result:result];
//}


@end
