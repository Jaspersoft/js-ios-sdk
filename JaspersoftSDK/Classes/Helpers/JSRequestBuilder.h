//
//  JSRequestBuilder.h
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 10.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSRequest.h"
#import <Foundation/Foundation.h>

/** 
 @cond EXCLUDE_JS_REQUEST_BUILDER
 
 Helps to build <code>JSRequest</code> instance which consists of different
 independent parts. The object puts at disposal a set of methods for setting 
 different parts of request
 
 @author Vlad Zavadskyi vzavadskii@jaspersoft.com
 @since version 1.0
 */
@interface JSRequestBuilder : NSObject

/**
 Configured request instance. Property initializes every time with the new instance of builder
 */
@property (nonatomic, readonly) JSRequest *request;

/**
 Returns a new builder contains initialized request with provided uri and HTTP method
 
 @param uri The URI for loading
 @param method The HTTP method
 @return A configured JSRequestBuilder instance for further request building
 */
+ (JSRequestBuilder *)requestWithUri:(NSString *)uri method:(JSRequestMethod)method;

/**
 Returns a new builder contains initialized request with provided uri and HTTP method
 
 @param uri The URI for loading
 @param method The HTTP method
 @return A configured JSRequestBuilder instance for further request building
 */
- (JSRequestBuilder *)requestWithUri:(NSString *)uri method:(JSRequestMethod)method;

/**
 Sets body for the request
 
 @param body The HTTP body used for request. Uses only for POST and PUT HTTP methods
 @return The request builder
 */
- (JSRequestBuilder *)body:(id)body;

/**
 Sets params for the request
 
 @param params A collection of parameters of the request. Automatically will be
 added to URL
 @return The request builder
 */
- (JSRequestBuilder *)params:(NSDictionary *)params;

/**
 Sets timeout interval for request
 
 @param timeoutInterval The timeout interval within which the request should be 
 cancelled if no data has been received
 @return The request builder
 */
- (JSRequestBuilder *)timeoutInterval:(NSTimeInterval)timeoutInterval;

/**
 Sets delegate for request
 
 @see JSRequestDelegate
 @param delegate The delegate to inform when the request is completed
 @return The request builder
 */
- (JSRequestBuilder *)delegate:(id<JSRequestDelegate>)delegate;

/**
 Sets finishedBlock for request
 
 @see JSRequestFinishedBlock
 @param finishedBlock A finishedBlock invoke when the request is completed
 @return The request builder
 */
- (JSRequestBuilder *)finishedBlock:(JSRequestFinishedBlock)finishedBlock;

/**
 Sets responseAsObjects for request
 
 @param responseAsObjects The responseAsObjects indicates if response result 
 should be serialized and returned as a list of objects instead plain text
 @return The request builder
 */
- (JSRequestBuilder *)responseAsObjects:(BOOL)responseAsObjects;

/**
 Sets downloadDestinationPath for request
 
 @param downloadDestinationPath The save path of downloaded file. This is an 
 additional parameter which helps to determine which file will be downloaded 
 (because all requests are asynchronous)
 @return The request builder
 */
- (JSRequestBuilder *)downloadDestinationPath:(NSString *)downloadDestinationPath;

@end

/** @endcond */
