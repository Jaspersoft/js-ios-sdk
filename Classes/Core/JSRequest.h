/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2013 Jaspersoft Corporation. All rights reserved.
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
//  JSRequest.h
//  Jaspersoft Corporation
//

#import "JSOperationResult.h"

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
     Take no action with regards to background
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
 Supported REST versions
 
 Tells what REST service URI prefix should be used to send request (i.e. for
 JSRESTVersion_1 URI could look like http://host:port/jasperserver-pro/rest/serverInfo/version
 while for JSRESTVersion_2: http://host:port/jasperserver-pro/rest_v2/serverInfo/version )
 */
typedef enum {
    JSRESTVersion_1,
    JSRESTVersion_2
} JSRESTVersion;

/**
 This protocol must be implemented by objects used to retrieve request result asynchronously
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
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.3
 @see JSRESTBase#sendRequest:
 */
@interface JSRequest : NSObject

/**
 The URI this request is loading
 */
@property (nonatomic, retain) NSString *uri;

/**
 The HTTP body used for this request. Uses only for POST and PUT HTTP methods.
 Automatically will be serialized as string in the format (i.e XML, JSON, etc.) provided
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
 
 **Default**: 120.0 seconds (defined in JSRESTBase class)
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
@property (nonatomic, weak) id <JSRequestDelegate> delegate;

/**
 A finishedBlock invoke when the request is completed. If block is not
 <code>nil</code>, it will receive request result (instance of
 <code>JSOperationResult</code> class). Provided as analogue to delegate object
 */
@property (nonatomic, copy) JSRequestFinishedBlock finishedBlock;

/**
 The responseAsObjects indicates if response result should be serialized and
 returned as a list of objects instead plain text
 */
@property (nonatomic, assign) BOOL responseAsObjects;

/**
 The save path of downloaded file. This is an additional parameter which helps
 to determine which file will be downloaded (because all requests are asynchronous)
 */
@property (nonatomic, retain) NSString *downloadDestinationPath;

#if TARGET_OS_IPHONE
/**
 The policy to take on transition to the background (iOS 4.x and higher only)
 */
@property (nonatomic, assign) JSRequestBackgroundPolicy requestBackgroundPolicy;
#endif

/**
 Determine asynchronous nature of request
 
 **Default**: YES
 */
@property (nonatomic, assign) BOOL asynchronous;

/**
 The rest version of JasperReports server (affects for URI part)
 
 **Default**: JSRESTVersion_1
 */
@property (nonatomic, assign) JSRESTVersion restVersion;

/**
 Pre-configures request via block. Block implicitly supports finishedBlock usage
 instead delegate object (or use them both), setting custom timeoutInterval,
 custom query parameters, requestBackgroundPolicy etc. Some of request parameters
 can be configured only by using block
 
 @param block The block to execute with the request before sending it
 */
- (JSRequest *)usingBlock:(void (^)(JSRequest *request))block;

@end
