//
//  JSRequest.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 10.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSOperationResult.h"

@class JSRequest;

/**
 Supported HTTP methods
 */
typedef enum {
    JSRequestMethodGET,
    JSRequestMethodPOST,
    JSRequestMethodPUT,
    JSRequestMethodDELETE
} JSRequestMethod;

/** 
 This block invoked when the request is complete. 
 Provided as analogue to JSResponseDelegate protocol
 */
typedef void(^JSRequestFinishedBlock)(JSOperationResult *result);

#if TARGET_OS_IPHONE
/**
 Background Request Policy
 
 On iOS 4.x and higher, UIKit provides support for continuing activities for a
 limited amount of time in the background. (This is wrapper for RestKit library 
 which provides simple support for this option)
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
     reopens
     */
    JSRequestBackgroundPolicyRequeue
} JSRequestBackgroundPolicy;

#endif

/** 
 This protocol must be implemented by objects that want to call the REST services
 */
@protocol JSRequestDelegate <NSObject>  

@required

/** 
 This method is invoked when the request is complete. The results of the request 
 can be checked looking at the JSOperationResult object passed as parameter
 */
- (void)requestFinished:(JSOperationResult *)result;

@end

/**
 The class models the request portion of an HTTP request/response cycle. Used by 
 <code>JSRESTBase</code> class to send requests
 
 @see JSRESTBase#sendRequest
 */
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
