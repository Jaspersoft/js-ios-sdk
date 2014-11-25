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
//  JSRESTBase.h
//  Jaspersoft Corporation
//

#import "JSProfile.h"
#import "JSRequest.h"
#import "JSSerializer.h"
#import "JSServerInfo.h"
#import <Foundation/Foundation.h>

/**
 Provides methods which interacts with the JasperReports Server REST API. The 
 object puts at disposal a set of methods for sending JSRequests for different 
 API parts, different types of cancel request(s). To send a proper request to
 server JSRequest instance should be configured. For this purposes JSRESTResource, 
 JSRESTReport helper classes was provided which do all this configuration in easier
 way for specific API parts (i.e. repository, reports etc.)
 @todo Provide helper classes for job and administration services
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Ivan Gadzhega  igadzhega@jaspersoft.com
 @author Alexey Gubarev  ogubarie@tibco.com

 @since 1.3
*/

extern NSString * const kJSRequestCharset;
extern NSString * const kJSRequestContentType;
extern NSString * const kJSRequestResponceType;

@interface JSRESTBase : NSObject

/**
 Checks if network is available
 
 @return A boolean value represents network is availability
 */
+ (BOOL)isNetworkReachable;

/**
 The server profile instance contains connection details for 
 JasperReports server
 */
@property (nonatomic, retain) JSProfile *serverProfile;

/** 
 The serializer instance uses to convert object to encoded string 
 (i.e. XML, JSON, etc.) for PUT/POST request
 
 **Default**: JSXMLSerializer
 */
@property (nonatomic, retain) id<JSSerializer> serializer;

/**
 The timeout interval which will be used as default value for all requests if
 they does not provide its own timeout interval
 
 **Default**: 120.0 seconds
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

#if TARGET_OS_IPHONE
/**
 The policy to take on transition to the background (iOS 4.x and higher only)
 
 **Default**: JSRequestBackgroundPolicyCancel
 */
@property (nonatomic, assign) JSRequestBackgroundPolicy requestBackgroundPolicy;
#endif

/**
 An NSArray of NSHTTPCookie objects

 @since 1.8
 */
@property (nonatomic, readonly) NSArray *cookies;

/** 
 Returns a rest base instance with provided server profile (for authentication) 
 and list of classes for which mapping rules will be created. 
 
 Class mapping rule describes how returned HTTP response (in JSON, XML and other
 formats) should be mapped directly to this class.
 
 @param profile The profile contains server connection details
 @param classes A list of classes for which mapping rules will be created
 @return A fully configured JSRESTBase instance include mapping rules
 */
- (id)initWithProfile:(JSProfile *)profile classesForMappings:(NSArray *)classes;

/**
 Sends asynchronous request. Result will be passed as <code>JSOperationResult</code> 
 instance to delegate object or finishedBlock (or both also) provided in 
 <code>JSRequest</code> object 
 
 @param request Models the request portion of an HTTP request/response cycle.
 */
- (void)sendRequest:(JSRequest *)request;

/**
 Sends asynchronous request. Result will be passed as <code>JSOperationResult</code>
 instance to delegate object or finishedBlock (or both also) provided in
 <code>JSRequest</code> object
 
 @param request Models the request portion of an HTTP request/response cycle.
 @param headerFields Additional HTTP header fields for sending request.

 @since 1.9
 */
- (void)sendRequest:(JSRequest *)request additionalHTTPHeaderFields:(NSDictionary *)headerFields;

/**
 Gets server information details
 
 @return the ServerInfo value
 @since 1.4
 */
- (JSServerInfo *)serverInfo;

/**
 Gets server information details asynchronously

 @param delegate The delegate object
 @since 1.7
 */
- (void)serverInfo:(id<JSRequestDelegate>)delegate;

/** 
 Cancels all requests for specified delegate object
 
 @param delegate The delegate object
 */
- (void)cancelRequestsWithDelegate:(id<JSRequestDelegate>)delegate;

/** 
 Cancels all requests 
 */
- (void)cancelAllRequests;

@end
