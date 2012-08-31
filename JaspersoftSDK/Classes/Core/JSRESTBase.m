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

// Prefix for REST service uri
static NSString * const _restServiceUri = @"/rest";

// Access key and default value for content-type
static NSString * const _contentType = @"application/octet-stream; charset=UTF-8";
static NSString * const _keyContentType = @"Content-Type";

// Default value for timeout interval
static NSTimeInterval const defaultTimeoutInterval = 120;

// Helper template message indicates that request was finished successfully
static NSString * const _requestFinishedTemplateMessage = @"Request finished: %@";

// RestKit's reachability observer for checking internet connection
static RKReachabilityObserver *networkReachabilityObserver;

// Inner JSCallback class contains delegate, finished and failed blocks for 
// specified request. This class is bridge between RestKit's delegate and 
// library delegate
@interface JSCallBack : NSObject

// Here reqeust uses only for setting additional parameters to JSOperationResult
// instance (i.e. downloadDestinationPath for files) which we wan't to associate
// with returned response.
@property (nonatomic, retain) JSRequest *request;

@property (nonatomic, retain) id restKitRequest;
@property (nonatomic, retain) id<JSRequestDelegate> delegate;
@property (nonatomic, copy) JSRequestFinishedBlock finishedBlock;

- (id)initWithRestKitRequest:(id)restKitRequest 
                     request:(JSRequest *)request 
                    delegate:(id<JSRequestDelegate>)delegate 
               finishedBlock:(JSRequestFinishedBlock)finishedBlock;

@end

@implementation JSCallBack

@synthesize request = _request;
@synthesize restKitRequest = _restKitRequest;
@synthesize delegate = _delegate;
@synthesize finishedBlock = _finishedBlock;

- (id)initWithRestKitRequest:(id)restKitRequest 
                     request:(JSRequest *)request 
                    delegate:(id<JSRequestDelegate>)delegate 
               finishedBlock:(JSRequestFinishedBlock)finishedBlock {
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

// RestKit's RKClient instance for simple GET/POST/PUT/DELETE requests.
// Also this class uses for base HTTP autnetication
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
    networkReachabilityObserver = [RKReachabilityObserver reachabilityObserverForInternet];
}

+ (BOOL)isNetworkReachable {
    // Checks if reachability was determined
    if (!networkReachabilityObserver.isReachabilityDetermined) {
        // Wait 0.1 second for reachability response (otherwise it wan't work)
        // Strange solution I know but delegate is not an option too :)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    return networkReachabilityObserver.isReachabilityDetermined && networkReachabilityObserver.isNetworkReachable;
}

#pragma mark -
#pragma mark Initialization

- (id)initWithProfile:(JSProfile *)profile classesForMappings:(NSArray *)classes {
    if (self = [super init]) {
        self.restKitClient = [[RKClient alloc] init];
        // Sets default content-type for RKClient. This is required step or 
        // there will be an error
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

- (id)init {
    return [self initWithProfile:nil classesForMappings:nil];
}

- (void)setServerProfile:(JSProfile *)serverProfile {    
    _serverProfile = serverProfile;
    
    // Sets authentication. This will also change authentication for 
    // RKObjectManager instance
    self.restKitClient.baseURL = [RKURL URLWithString:serverProfile.serverUrl];
    self.restKitClient.username = [serverProfile getUsenameWithOrganization];
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
        fullUri = [self fullUri:[request.uri stringByAppendingQueryParameters:request.params]];
    } else {
        fullUri = request.uri;
    }
    
    // Request can be RKRequest or RKOjbectLoader depends on request method (GET or POST/PUT)
    id restKitRequest = nil;
    
    // Checks what type or RestKit's request to create: RKObjectLoader or RKRequest
    if (request.responseAsObjects) {
        restKitRequest = [self.restKitObjectManager loaderWithResourcePath:fullUri];
    } else {
        restKitRequest = [self.restKitClient requestWithResourcePath:fullUri];
    }
    
    NSString *body = nil;
    if (request.method == JSRequestMethodPOST || request.method == JSRequestMethodPUT) {
        body = [self.serializer stringFromObject:request.body];
    } else {
        body = request.body;
    }
    
    [restKitRequest setHTTPBodyString:body];
    [restKitRequest setTimeoutInterval:request.timeoutInterval ?: self.timeoutInterval];
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
    
    // Creates bridge between RestKit's delegate and library delegate
    [self.requestCallBacks addObject:[[JSCallBack alloc] initWithRestKitRequest:restKitRequest 
                                                                        request:request delegate:request.delegate 
                                                                  finishedBlock:request.finishedBlock]];
    
    [restKitRequest send];
}

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

- (void)cancelAllRequests {
    for (JSCallBack *callBack in self.requestCallBacks) {
        [callBack.restKitRequest cancel];
    }
    
    [self.requestCallBacks removeAllObjects];
}

#pragma mark -
#pragma mark Private methods

// Gets full uri includes _restServiceUri prefix 
- (NSString *)fullUri:(NSString *)uri {
    return [NSString stringWithFormat:@"%@%@", _restServiceUri, (uri ?: @"")];
}

// Gets callBack by request (RKRequest or RKObjectLoader) and deletes it from 
// requestCallBacks list
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

// Initializes result with helping properties: http status code, 
// returned header fields and mimetype
- (JSOperationResult *)operationResultWithResponse:(RKResponse *)response error:(NSError *)error {
    return [[JSOperationResult alloc] initWithStatusCode:response.statusCode
                                         allHeaderFields:response.allHeaderFields
                                                MIMEType:response.MIMEType error:error];
}

- (void)callRequestFinishedCallBackForRestKitRequest:(id)restKitRequest result:(JSOperationResult *)result {
    JSCallBack *callBack = [self callBackByRestKitRequest:restKitRequest removeFromCallBacks:true];
    NSLog(_requestFinishedTemplateMessage, [[restKitRequest URL] absoluteString]);
    
    // Sets different parameters for associations from request to result
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
    // This method also calls for RKObjectLoader so here we need to check if 
    // object is not loader. Not very good approach to use isKindOfClass. 
    // Temp solution
    if (![request isKindOfClass:[RKObjectLoader class]]) {
        JSOperationResult *result = [self operationResultWithResponse:response error:nil];
        // Used for downloading files
        result.body = response.body;
        [self callRequestFinishedCallBackForRestKitRequest:request result:result];
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    // This method also calls for RKObjectLoader so here we need to check if object
    // is not loader or response was timed out (error.code should be equals 5 in this case)
    if (![request isKindOfClass:[RKObjectLoader class]] || error.code == 5) {
        JSOperationResult *result = [self operationResultWithResponse:request.response error:error];
        [self callRequestFinishedCallBackForRestKitRequest:request result:result];
    }
}



@end
