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

#import <Foundation/Foundation.h>

#import "JSProfile.h"
#import "JSRequest.h"
#import "JSObjectMappingsProtocol.h"
#import "JSServerInfo.h"
#import <AFHTTPSessionManager.h>

extern NSString * const _Nonnull kJSRequestContentType;
extern NSString * const _Nonnull kJSRequestResponceType;


/**
 Provides methods which interacts with the JasperReports Server REST API. The 
 object puts at disposal a set of methods for sending JSRequests for different 
 API parts, different types of cancel request(s). To send a proper request to
 server JSRequest instance should be configured. For this purposes JSRESTResource, 
 JSRESTReport helper classes was provided which do all this configuration in easier
 way for specific API parts (i.e. repository, reports etc.)
 @todo Provide helper classes for job and administration services
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Aleksandr Dakhno odahno@tibco.com
 @author Alexey Gubarev ogubarie@tibco.com

 @since 1.3
*/
@class ServerReachability;

@interface JSRESTBase : AFHTTPSessionManager <NSSecureCoding, NSCopying>

/**
 The server profile instance contains connection details for 
 JasperReports server
 */
@property (nonatomic, strong, readonly, nonnull) JSProfile *serverProfile;

/**
 The timeout interval which will be used as default value for all requests if
 they does not provide its own timeout interval
 
 **Default**: 120.0 seconds
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 An NSArray of NSHTTPCookie objects

 @since 1.8
 */
@property (nonatomic, readonly, null_unspecified) NSArray <NSHTTPCookie *> *cookies;

/**
 If YES REST Client will try to recreate HTTP session.
 
 @since 1.9
 */
@property (nonatomic, assign, readonly) BOOL keepSession;

/**
 Returns a rest base instance. 
 
 @param serverProfile The server profile instance contains connection details for JasperReports server
 @param keepLogged If YES REST Client will try to recreate HTTP session
 @return A fully configured JSRESTBase instance
 */
- (nonnull instancetype) initWithServerProfile:(nonnull JSProfile *)serverProfile keepLogged:(BOOL)keepLogged;

/**
 Sends asynchronous request. Result will be passed as <code>JSOperationResult</code> 
 instance to completionBlock provided in
 <code>JSRequest</code> object 
 
 @param request Models the request portion of an HTTP request/response cycle.
 */
- (void)sendRequest:(nonnull JSRequest *)request;

/**
 Gets server information details
 
 @return the ServerInfo value
 @since 1.4
 */
- (nullable JSServerInfo *)serverInfo;

/** 
 Cancels all requests 
 */
- (void)cancelAllRequests;

/**
 Deletes all cookies for specified server
 
 @since 1.9
 */
- (void)deleteCookies;

/**
 Update cookies

 @since 2.4
 */

- (void)updateCookiesWithCookies:(NSArray <NSHTTPCookie *>* __nullable)cookies;

/**
 Reset reachability to server status
 
 @since 1.9
 */
- (void)resetReachabilityStatus;
@end
