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
//  JSRequestBuilder.h
//  Jaspersoft Corporation
//

#import "JSRequest.h"
#import <Foundation/Foundation.h>

/** 
 @cond EXCLUDE_JS_REQUEST_BUILDER
 
 Helps to build <code>JSRequest</code> instance which consists of different
 independent parts. The object puts at disposal a set of methods for setting 
 different parts of request
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.3
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

/**
 Sets asynchronous for request
 
 @param asynchronous Determine asynchronous nature of request
 @return The request builder
 */
- (JSRequestBuilder *)asynchronous:(BOOL)asynchronous;

/**
 Sets restVersion for request
 
 @param restVersion Tells what REST service URI prefix should be used to send request (i.e. for
 JSRESTVersion_1 URI could look like http://host:port/jasperserver-pro/rest/serverInfo/version
 while for JSRESTVersion_2: http://host:port/jasperserver-pro/rest_v2/serverInfo/version )
 @return The request builder
 */
- (JSRequestBuilder *)restVersion:(JSRESTVersion)restVersion;

@end

/** @endcond */
