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
#import "JSXMLSerializer.h"
#import "JSRequestBuilder.h"
#import "JSRestKitManagerFactory.h"
#import "JRSwizzle.h"
#import "RKURL+RKAdditions.h"
#import "RKRequest+RKAdditions.h"

// Access key and value for content-type / charset
static NSString * const _charsetUTF8 = @"UTF-8";
static NSString * const _keyCharset = @"Charset";
static NSString * const _keyContentType = @"Content-Type";
static NSString * const _keyResponceType = @"Accept";

// Default value for timeout interval
static NSTimeInterval const _defaultTimeoutInterval = 120;

// Helper template message indicates that request was finished successfully
static NSString * const _requestFinishedTemplateMessage = @"Request finished: %@";

// RestKit's reachability observer for checking internet connection
static RKReachabilityObserver *_networkReachabilityObserver;

// Key element for RestKit's mapping path. Can be found inside error.userInfo dictionary
static NSString *_keyRKObjectMapperKeyPath = @"RKObjectMapperKeyPath";

// Inner JSCallback class contains JSRequest and RKRequest instances. 
// JSRequest instance contains delegate object and finished block so actually this 
// instance is bridge between RestKit's delegate and library delegate (or finished block)
// Also JSRequest class uses for setting additional parameters to JSOperationResult
// instance (i.e. downloadDestinationPath for files) which we want to associate
// with returned response (but it cannot be done in any other way).
@interface JSCallBack : NSObject

@property (nonatomic, retain) JSRequest *request;
@property (nonatomic, retain) id restKitRequest;

- (id)initWithRestKitRequest:(id)restKitRequest 
                     request:(JSRequest *)request;

@end

@implementation JSCallBack

@synthesize request = _request;
@synthesize restKitRequest = _restKitRequest;

- (id)initWithRestKitRequest:(id)restKitRequest 
                     request:(JSRequest *)request {
    if (self = [super init]) {
        self.request = request;
        self.restKitRequest = restKitRequest;
    }
    
    return self;
}

@end

// Hidden implementation of RKObjectLoaderDelegate protocol and private properties
@interface JSRESTBase() <RKObjectLoaderDelegate>

// RestKit's RKClient instance for simple GET/POST/PUT/DELETE requests.
// Also this class uses for base HTTP authentication
@property (nonatomic, retain) RKClient *restKitClient;

// RestKit's RKObjectManager instance for mapping response (in JSON, XML and other
// formats) directly to object
@property (nonatomic, retain) RKObjectManager *restKitObjectManager;

// List of JSCallBack instances
@property (nonatomic, retain) NSMutableArray *requestCallBacks;

@end

@implementation JSRESTBase

@synthesize restKitClient = _restKitClient;
@synthesize restKitObjectManager = _restKitObjectManager;
@synthesize serverProfile = _serverProfile;
@synthesize serializer = _serializer;
@synthesize requestCallBacks = _requestCallBacks;
@synthesize timeoutInterval = _timeoutInterval;

#if TARGET_OS_IPHONE
@synthesize requestBackgroundPolicy = _requestBackgroundPolicy;
#endif

+ (void)initialize {
    _networkReachabilityObserver = [RKReachabilityObserver reachabilityObserverForInternet];    
    [RKURL jr_swizzleMethod:@selector(initWithBaseURL:resourcePath:queryParameters:)
                 withMethod:@selector(initWithBaseURLFixed:resourcePath:queryParameters:) error:nil];
    [RKRequest jr_swizzleMethod:@selector(prepareURLRequest)
                 withMethod:@selector(prepareURLRequestWithTimeoutInterval) error:nil];
}

+ (BOOL)isNetworkReachable {
    return _networkReachabilityObserver.isReachabilityDetermined && _networkReachabilityObserver.isNetworkReachable;
}

#pragma mark -
#pragma mark Initialization

- (id)initWithProfile:(JSProfile *)profile classesForMappings:(NSArray *)classes {
    if (self = [super init]) {
        self.restKitClient = [[RKClient alloc] init];
        self.restKitClient.authenticationType = RKRequestAuthenticationTypeHTTPBasic;
        self.restKitClient.cachePolicy = RKRequestCachePolicyNone;
        self.restKitClient.requestCache.storagePolicy = RKRequestCacheStoragePolicyDisabled;
        self.restKitClient.disableCertificateValidation = YES;
        
        // Add locale to request
        [self.restKitClient setValue:[NSString stringWithFormat:@"%@", [[NSLocale preferredLanguages] componentsJoinedByString:@", "]] forHTTPHeaderField:@"Accept-Language"];
        [self.restKitClient setValue:[NSString stringWithFormat:@"%@", [[NSTimeZone systemTimeZone] abbreviation]] forHTTPHeaderField:@"Accept-Timezone"];
        
        // Sets default content-type and charset for RKClient. This is required step or
        // there will be an parsing error
        [self.restKitClient setValue:RKMIMETypeXML forHTTPHeaderField:_keyContentType];
        [self.restKitClient setValue:[JSConstants sharedInstance].REST_SDK_MIMETYPE_USED forHTTPHeaderField:_keyResponceType];

        [self.restKitClient setValue:_charsetUTF8 forHTTPHeaderField:_keyCharset];
        
        // Passed classes including JSServerInfo class
        NSMutableArray *classesForMappings = [[NSMutableArray alloc] initWithObjects:[JSServerInfo class], nil];
        [classesForMappings addObjectsFromArray:classes];
        
        self.restKitObjectManager = [JSRestKitManagerFactory createRestKitObjectManagerForClasses:classesForMappings];
        self.restKitObjectManager.client = self.restKitClient;
        self.serverProfile = [profile copy];
        self.requestCallBacks = [[NSMutableArray alloc] init];
        self.timeoutInterval = _defaultTimeoutInterval;
        
#if TARGET_OS_IPHONE
        self.requestBackgroundPolicy = JSRequestBackgroundPolicyCancel;
#endif
    }
    
    return self;
}

- (id)init {
    return [self initWithProfile:nil classesForMappings:nil];
}

- (void)setServerProfile:(JSProfile *)serverProfile {
    _serverProfile = serverProfile;
    
    // Delete cookies for current server profile. If don't do this old credentials will be used
    // instead new one
    [self deleteCookies];
    
    // Sets authentication. This will also change authentication for 
    // RKObjectManager instance
    self.restKitClient.baseURL = [RKURL URLWithString:serverProfile.serverUrl];
    self.restKitClient.username = [serverProfile getUsernameWithOrganization];
    self.restKitClient.password = serverProfile.password;
}

// Initializes default serializer if no other was provided
- (id<JSSerializer>)serializer {
    if (!_serializer) {
        _serializer = [[JSXMLSerializer alloc] init];
    }
    
    return _serializer;
}

#pragma mark -
#pragma mark Public methods

- (void)sendRequest:(JSRequest *)request {
    // Full uri path with query params
    NSString *fullUri = nil;
    if (request.params.count) {
        fullUri = [self fullUri:[request.uri stringByAppendingQueryParameters:request.params]
                    restVersion:request.restVersion];
    } else {
        fullUri = [self fullUri:request.uri restVersion:request.restVersion];
    }
    
    // Request can be RKRequest or RKObjectLoader depends on request method (GET or POST/PUT)
    RKRequest *restKitRequest = nil;

    // Checks what type or RestKit's request to create: RKObjectLoader or RKRequest
    if (request.responseAsObjects) {
        restKitRequest = [self.restKitObjectManager loaderWithResourcePath:fullUri];
    } else {
        restKitRequest = [self.restKitClient requestWithResourcePath:fullUri];
    }
    
    NSData *body = nil;
    if (request.body && (request.method == JSRequestMethodPOST || request.method == JSRequestMethodPUT)) {
        body = [[self.serializer stringFromObject:request.body] dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    [restKitRequest setHTTPBody:body];
    [restKitRequest setTimeoutInterval:(request.timeoutInterval ?: self.timeoutInterval)];
    [restKitRequest setDelegate:self];
    
    switch (request.method) {
        case JSRequestMethodPOST:
            [restKitRequest setMethod:RKRequestMethodPOST];
            break;
            
        case JSRequestMethodPUT:
            [restKitRequest setMethod:RKRequestMethodPUT];
            break;
            
        case JSRequestMethodDELETE:
            [restKitRequest setMethod:RKRequestMethodDELETE];
            break;
            
        case JSRequestMethodGET:
        default:
            [restKitRequest setMethod:RKRequestMethodGET];
    }
    
#if TARGET_OS_IPHONE
    JSRequestBackgroundPolicy requestBackgroundPolicy = request.requestBackgroundPolicy ?: self.requestBackgroundPolicy;
    switch (requestBackgroundPolicy) {
        case JSRequestBackgroundPolicyNone:
            [restKitRequest setBackgroundPolicy:RKRequestBackgroundPolicyNone];
            break;
            
        case JSRequestBackgroundPolicyContinue:
            [restKitRequest setBackgroundPolicy:RKRequestBackgroundPolicyContinue];
            break;
            
        case JSRequestBackgroundPolicyRequeue:
            [restKitRequest setBackgroundPolicy:RKRequestBackgroundPolicyRequeue];
            break;
            
        case JSRequestBackgroundPolicyCancel:
        default:
            [restKitRequest setBackgroundPolicy:RKRequestBackgroundPolicyCancel];
            break;
    }
#endif
    
    // Creates bridge between RestKit's delegate and SDK delegate
    [self.requestCallBacks addObject:[[JSCallBack alloc] initWithRestKitRequest:restKitRequest request:request]];
    
    
    if (request.asynchronous) {
        [restKitRequest send];
    } else {
        [restKitRequest sendSynchronously];
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
            [self.restKitClient.requestQueue cancelRequest:callBack.restKitRequest];
            [indexesOfRemovingCallBacks addIndex:i];
        }
    }
    
    [self.requestCallBacks removeObjectsAtIndexes:indexesOfRemovingCallBacks];
}

- (void)cancelAllRequests {
    [self.restKitClient.requestQueue cancelAllRequests];
    [self.requestCallBacks removeAllObjects];
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

// Gets callBack by request (RKRequest or RKObjectLoader) and deletes it from 
// requestCallBacks list
- (JSCallBack *)callBackByRestKitRequest:(id)restKitRequest removeFromCallBacks:(BOOL)remove {
    JSCallBack *callBack = nil;
    
    for (int i = 0; i < self.requestCallBacks.count; i++) {
        if ([[self.requestCallBacks objectAtIndex:i] restKitRequest] == restKitRequest) {
            callBack = [self.requestCallBacks objectAtIndex:i];
            if (remove) {
                [self.requestCallBacks removeObjectAtIndex:i];
            }
            break;
        }
    }
    
    return callBack;
}

// Initializes result with helping properties: http status code, 
// returned header fields and MIMEType
- (JSOperationResult *)operationResultWithResponse:(RKResponse *)response error:(NSError *)error {
    JSOperationResult *result = [[JSOperationResult alloc] initWithStatusCode:response.statusCode
                                         allHeaderFields:response.allHeaderFields
                                                MIMEType:response.MIMEType
                                                   error:error];
    result.body = response.body;
    result.bodyAsString = response.bodyAsString;
    return result;
}

- (void)callRequestFinishedCallBackForRestKitRequest:(id)restKitRequest result:(JSOperationResult *)result {
    JSCallBack *callBack = [self callBackByRestKitRequest:restKitRequest removeFromCallBacks:true];
    NSLog(_requestFinishedTemplateMessage, [[restKitRequest URL] absoluteString]);
    result.request = callBack.request;
        
    [callBack.request.delegate requestFinished:result];
    if (callBack.request.finishedBlock) {
        callBack.request.finishedBlock(result);
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
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[JSConstants sharedInstance].REST_SERVER_INFO_URI
                                                           method:JSRequestMethodGET] restVersion:JSRESTVersion_2];
    [builder asynchronous:isAsynchronous];

    return builder.request;
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

#pragma mark -
#pragma mark RKObjectLoaderDelegate protocol callbacks

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    JSOperationResult *result = [self operationResultWithResponse:objectLoader.response error:nil];
    result.objects = objects;
    [self callRequestFinishedCallBackForRestKitRequest:objectLoader result:result];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    JSOperationResult *result = nil;
    NSString *mapperKeyPath = nil;
    
    // Get mapper key path from error.userInfo dictionary
    for (NSString *key in error.userInfo.allKeys) {
        id value = [error.userInfo objectForKey:key];
        if ([value respondsToSelector:@selector(isEqualToString:)] && 
            [value isEqualToString:_keyRKObjectMapperKeyPath]) {
            mapperKeyPath = key;
            break;
        }
    }
    
    // If we have an error (most of all mapping) but response was success (server returned body)
    // error with server message will be created
    if (objectLoader.response.isClientError && 
        objectLoader.response.bodyAsString.length) {
        NSMutableDictionary *errorDetail = [[NSMutableDictionary alloc] init];
        [errorDetail setObject:objectLoader.response.bodyAsString forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:error.domain code:error.code userInfo:errorDetail];
    }
    
    // Check if response is not an empty XML list (i.e. <resourceDescriptors></resourceDescriptors>).
    // RestKit interpret this as mapping error
    if ([mapperKeyPath isEqualToString:@""]) {
        result = [self operationResultWithResponse:objectLoader.response error:nil];
        result.objects = [NSArray array];
    } else {
        result = [self operationResultWithResponse:objectLoader.response error:error];
    }

    [self callRequestFinishedCallBackForRestKitRequest:objectLoader result:result];
}

#pragma mark -
#pragma mark RKRequestDelegate protocol callbacks

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {    
    // This method also calls for RKObjectLoader so here we need to check if 
    // object is not loader. Not very good approach to use isKindOfClass. 
    // Temp solution
    if (![request isKindOfClass:[RKObjectLoader class]]) {
        JSOperationResult *result = [self operationResultWithResponse:response error:nil];
        // Used for downloading files
        result.body = response.body;
        result.bodyAsString = response.bodyAsString;
        [self callRequestFinishedCallBackForRestKitRequest:request result:result];
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    // This method also calls for RKObjectLoader so here we need to check if object
    // is not loader or response was timed out (error.code should be equals 5 in this case)
    if (![request isKindOfClass:[RKObjectLoader class]] || error.code == RKRequestConnectionTimeoutError) {
        JSOperationResult *result = [self operationResultWithResponse:request.response error:error];
        [self callRequestFinishedCallBackForRestKitRequest:request result:result];
    }
}

@end
