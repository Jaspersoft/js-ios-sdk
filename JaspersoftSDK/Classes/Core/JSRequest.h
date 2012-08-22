//
//  JSRequest.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSOperationResult.h"

@class JSRequest;

/**
 Supported HTTP request types
 */
typedef enum {
    JSRequestMethodGET,
    JSRequestMethodPOST,
    JSRequestMethodPUT,
    JSRequestMethodDELETE
} JSRequestMethod;

/** 
 Request blocks as analogue to JSResponseDelegate protocol
 */
typedef void(^JSRequestFinishedBlock)(JSOperationResult *result);


#if TARGET_OS_IPHONE
/**
 Background Request Policy
 
 On iOS 4.x and higher, UIKit provides support for continuing activities for a
 limited amount of time in the background. (This is wrapper for RestKit library which provides simple support for
 continuing a request when in the background).
 */
typedef enum {
    /**
     Take no action with regards to backgrounding
     */
    JSRequestBackgroundPolicyNone,
    /**
     Cancel the request on transition to the background
     */
    JSRequestBackgroundPolicyCancel,
    /**
     Continue the request in the background until time expires
     */
    JSRequestBackgroundPolicyContinue,
    /**
     Stop the request and place it back on the queue. It will fire when the app
     reopens.
     */
    JSRequestBackgroundPolicyRequeue
} JSRequestBackgroundPolicy;

#endif

/** 
 This protocol must be implemented by objects that
 want to call the REST services asynchronously.
 */
@protocol JSRequestDelegate <NSObject>  

@required

/** 
 This method is invoked when the request is complete. 
 The results of the request can be checked looking at 
 the JSOperationResult passed as parameter.
 */
- (void)requestFinished:(JSOperationResult *)result;

@optional

- (void)didReceiveData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExpectedToReceive:(NSInteger)totalBytesExpectedToReceive;

@end

@interface JSRequest : NSObject

@property (nonatomic, retain) NSString *uri;
@property (nonatomic, retain) id body;
@property (nonatomic, retain) NSDictionary *params;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) JSRequestMethod method;
@property (nonatomic, retain) id<JSRequestDelegate> delegate;
@property (nonatomic, copy) JSRequestFinishedBlock finishedBlock;
@property (nonatomic, assign) BOOL responseAsObjects;
@property (nonatomic, retain) NSString *downloadDestinationPath;

#if TARGET_OS_IPHONE
/**
 The policy to take on transition to the background (iOS 4.x and higher only)
 */
@property (nonatomic, assign) JSRequestBackgroundPolicy requestBackgroundPolicy;
#endif

- (JSRequest *)usingBlock:(void (^)(JSRequest *request))block;

@end
