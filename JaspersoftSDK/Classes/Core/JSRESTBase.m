//
//  JSBase.m
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 03.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSRESTBase.h"
#import "JSXMLSerializer.h"
#import "JSRestKitManagerFactory.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKURL.h>

// JS REST main prefix for service uri
static NSString * const _restServiceUri = @"/rest";

// Key and default value for content-type
static NSString * const _contentType = @"application/octet-stream; charset=UTF-8";
static NSString * const _keyContentType = @"Content-Type";

// Default value for timeout interval
static NSTimeInterval const defaultTimeoutInterval = 120;

// Helper template message for indicating that request was finished successfully
static NSString * const _requestFinishedTemplateMessage = @"Request finished: %@";

// RestKit's reachability observer for checking internet connection in general
static RKReachabilityObserver *networkReachabilityObserver;

// Inner JSCallback class contains delegates, finished and failed blocks for specified request
@interface JSCallBack : NSObject

// JSRequest  object uses for setting additional parameters to JSOperationResult object
// from it (i.e. downloadDestinationPath for files from request to result). 
// This approach uses if we wan't to associate some additional parameters (which response does not return) 
// with response (via setting them to out result)
@property (nonatomic, retain) JSRequest *request;

@property (nonatomic, retain) id restKitRequest;
@property (nonatomic, retain) id<JSRequestDelegate> delegate;
@property (nonatomic, copy) JSRequestFinishedBlock finishedBlock;

- (id)initWithRestKitRequest:(id)restKitRequest request:(JSRequest *)request delegate:(id<JSRequestDelegate>)delegate finishedBlock:(JSRequestFinishedBlock)finishedBlock;

@end

@implementation JSCallBack

@synthesize request = _request;
@synthesize restKitRequest = _restKitRequest;
@synthesize delegate = _delegate;
@synthesize finishedBlock = _finishedBlock;

- (id)initWithRestKitRequest:(id)restKitRequest request:(JSRequest *)request delegate:(id<JSRequestDelegate>)delegate finishedBlock:(JSRequestFinishedBlock)finishedBlock {
    if (self = [super init]) {
        self.request = request;
        self.restKitRequest = restKitRequest;
        self.delegate = delegate;
        self.finishedBlock = finishedBlock;
    }
    
    return self;
}

@end

// Hidden implementation of RKObjectLoaderDelegate protocol and private properties
@interface JSRESTBase() <RKObjectLoaderDelegate>

// RestKit's RKClient instance for simple GET/POST/PUT/DELETE requests. Also this class uses for autnetication
@property (nonatomic, retain) RKClient *restKitClient;

// RestKit's RKObjectManager instance for mapping response (XML/JSON) directly to object (wrapper) 
@property (nonatomic, retain) RKObjectManager *restKitObjectManager;

// Dictionary which contains RestKit's requests and passed delegates
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
    networkReachabilityObserver = [RKReachabilityObserver reachabilityObserverForInternet];
}

+ (BOOL)isNetworkReachable {
    // Check if reachability was determined
    if (!networkReachabilityObserver.isReachabilityDetermined) {
        // Wait 0.1 second for reachability response
        // Strange solution I know but delegate is not an option too
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    return networkReachabilityObserver.isReachabilityDetermined && networkReachabilityObserver.isNetworkReachable;
}

#pragma mark -
#pragma mark Initialization

- (id)initWithProfile:(JSProfile *)profile classesForMappings:(NSArray *)classes {
    if (self = [super init]) {
        self.restKitClient = [[RKClient alloc] init];
        // Set default content-type for RKClient
        [self.restKitClient setValue:_contentType forHTTPHeaderField:_keyContentType];
        self.restKitObjectManager = [JSRestKitManagerFactory createRestKitObjectManagerForClasses:classes];
        self.restKitObjectManager.client = self.restKitClient;
        self.serverProfile = [profile copy];
        self.requestCallBacks = [[NSMutableArray alloc] init];
        self.timeoutInterval = defaultTimeoutInterval;
        
#if TARGET_OS_IPHONE
        self.requestBackgroundPolicy = JSRequestBackgroundPolicyCancel;
#endif
    }
    
    return self;
}

- (id)initWithProfile:(JSProfile *)profile {
    return [self initWithProfile:profile classesForMappings:nil];
}

- (id)init {
    return [self initWithProfile:nil];
}

- (void)setServerProfile:(JSProfile *)serverProfile {    
    _serverProfile = serverProfile;
    
    // Set authentication. This will also change authentication for restKitObjectManager instance
    self.restKitClient.baseURL = [RKURL URLWithString:serverProfile.serverUrl];
    self.restKitClient.username = [serverProfile getUsenameWithOrganization];
    self.restKitClient.password = serverProfile.password;
}

// Getting default serializer if no other was provided
- (id<JSSerializer>)serializer {
    if (!_serializer) {
        _serializer = [[JSXMLSerializer alloc] init];
    }
    
    return _serializer;
}

#pragma mark -
#pragma mark Public methods

- (void)sendRequest:(JSRequest *)request {
    // Full uri path including params
    NSString *fullUri = [self fullUri:(request.params.count ? [request.uri stringByAppendingQueryParameters:request.params] : request.uri)];
    
    // Request can be RKRequest or RKOjbectLoader depends on request method
    id restKitRequest = nil;
    
    // Check what type or RestKit's request create: RKObjectLoader or RKRequest
    if (request.responseAsObjects) {
        restKitRequest = [self.restKitObjectManager loaderWithResourcePath:fullUri];
    } else {
        restKitRequest = [self.restKitClient requestWithResourcePath:fullUri];
    }
    
    NSString *body = (request.method == JSRequestMethodPOST || 
                      request.method == JSRequestMethodPUT) ? [self.serializer stringFromObject:request.body] : request.body;
    [restKitRequest setHTTPBodyString:body];
    [restKitRequest setTimeoutInterval:request.timeoutInterval ?: self.timeoutInterval];
    
    // Bridge between RestKit's delegate and JSRequestDelegate
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
    
    // Add callback for RKRequest instance
    [self.requestCallBacks addObject:[[JSCallBack alloc] initWithRestKitRequest:restKitRequest request:request delegate:request.delegate finishedBlock:request.finishedBlock]];
    
    [restKitRequest send];
}

// Cancel all requests by delegate
- (void)cancelRequestsWithDelegate:(id<JSRequestDelegate>)delegate {
    NSMutableIndexSet *indexesOfRemovingCallBacks = [[NSMutableIndexSet alloc] init];
    JSCallBack *callBack = nil;
    
    for (int i = 0; i < self.requestCallBacks.count; i++){
        callBack = [self.requestCallBacks objectAtIndex:i];
        if (callBack.delegate == delegate) {
            [callBack.restKitRequest cancel];
            [indexesOfRemovingCallBacks addIndex:i];
        }
    }
    
    [self.requestCallBacks removeObjectsAtIndexes:indexesOfRemovingCallBacks];
}

// Cancel all requests
- (void)cancelAllRequests {
    for (JSCallBack *callBack in self.requestCallBacks) {
        [callBack.restKitRequest cancel];
    }
    
    [self.requestCallBacks removeAllObjects];
}

#pragma mark -
#pragma mark Private methods

// Get full uri including restServiceUri prefix 
- (NSString *)fullUri:(NSString *)uri {
    return [NSString stringWithFormat:@"%@%@", _restServiceUri, (uri ?: @"")];
}

// Get callBack by request (of types RKRequest or RKObjectLoader) and delete it from requestCallBacks array
- (JSCallBack *)callBackByRestKitRequest:(id)restKitRequest removeFromCallBacks:(BOOL)remove {
    JSCallBack *callBack = nil;
    
    for (int i = 0; i < self.requestCallBacks.count; i++) {
        callBack = [self.requestCallBacks objectAtIndex:i];
        if (callBack.restKitRequest == restKitRequest) {
            if (remove) {
                [self.requestCallBacks removeObjectAtIndex:i];
            }
            break;
        }
    }
    
    return callBack;
}

// Initialize result with helping (readonly) properties: http status code, returned header fields and mimetype
- (JSOperationResult *)operationResultWithResponse:(RKResponse *)response error:(NSError *)error {
    return [[JSOperationResult alloc] initWithStatusCode:response.statusCode
                                         allHeaderFields:response.allHeaderFields
                                                MIMEType:response.MIMEType error:error];
}

- (void)callRequestFinishedCallBackForRestKitRequest:(id)restKitRequest result:(JSOperationResult *)result {
    JSCallBack *callBack = [self callBackByRestKitRequest:restKitRequest removeFromCallBacks:true];
    NSLog(_requestFinishedTemplateMessage, [[restKitRequest URL] absoluteString]);
    
    // Set different parameters for association from our request to result
    if (callBack.request.downloadDestinationPath) {
        result.downloadDestinationPath = callBack.request.downloadDestinationPath;
    }
    
    [callBack.delegate requestFinished:result];
    if (callBack.finishedBlock) { 
        callBack.finishedBlock(result);
    }
}

#pragma mark -
#pragma mark RKObjectLoaderDelegate protocol callbacks

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    JSOperationResult *result = [self operationResultWithResponse:objectLoader.response error:nil];
    result.objects = objects;
    [self callRequestFinishedCallBackForRestKitRequest:objectLoader result:result];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    JSOperationResult *result = [self operationResultWithResponse:objectLoader.response error:error];
    [self callRequestFinishedCallBackForRestKitRequest:objectLoader result:result];
}

#pragma mark -
#pragma mark RKRequestDelegate protocol callbacks

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    // This method also calls for RKObjectLoader so here we need to check if object is not loader
    // Not very good approach to use isKindOfClass. This is a temp solution
    if (![request isKindOfClass:[RKObjectLoader class]]) {
        JSOperationResult *result = [self operationResultWithResponse:response error:nil];
        // Used for downloading files
        result.body = response.body;
        [self callRequestFinishedCallBackForRestKitRequest:request result:result];
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    // This method also calls for RKObjectLoader so here we need to check if object is not loader
    // Or response was timed out (error.code should be equals 5 in this case)
    if (![request isKindOfClass:[RKObjectLoader class]] || error.code == 5) {
        JSOperationResult *result = [self operationResultWithResponse:request.response error:error];
        [self callRequestFinishedCallBackForRestKitRequest:request result:result];
    }
}



@end
