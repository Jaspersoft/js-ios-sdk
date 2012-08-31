//
//  JSRequest.h
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 10.08.12.
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
 Models the request portion of an HTTP request/response cycle. Used by 
 <code>JSRESTBase</code> class to send requests
 
 @see JSRESTBase#sendRequest:
 */
@interface JSRequest : NSObject

/**
 The URI this request is loading
 */
@property (nonatomic, retain) NSString *uri;

/**
 The HTTP body used for this request. Uses only for POST and PUT HTTP methods.
 Automatically will be serialized as string in the format (i.e XML, JSON, etc) provided 
 by the serializer
 
 @see JSSerializer
 @see JSXMLSerializer
 @see JSRESTBase#serializer
 */
@property (nonatomic, retain) id body;

/**
 A collection of parameters of the request. Automatically will be added to URL
 */
@property (nonatomic, retain) NSDictionary *params;

/**
 The timeout interval within which the request should be cancelled if no data
 has been received.
 
 The timeout timer is cancelled as soon as we start receiving data and are
 expecting the request to finish
 
 **Default**: 120.0 seconds (defined in <code>JSRESTBase</code> class)
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 The HTTP method
 */
@property (nonatomic, assign) JSRequestMethod method;

/**
 The delegate to inform when the request is completed. If the object implements 
 the <code>JSRequestDelegate</code> protocol and if object is not <code>nil</code>, 
 it will receive request result (instance of <code>JSOperationResult</code> class)
 */
@property (nonatomic, retain) id<JSRequestDelegate> delegate;

/**
 A finishedBlock invoke when the request is completed. If block is not 
 <code>nil</code>, it will receive request result (instance of
 <code>JSOperationResult</code> class). Provides as analogue to delegate object
 */
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
