/*
 * Copyright © 2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Olexandr Dahno odahno@tibco.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.3
 */


#import <Foundation/Foundation.h>

#import "JSProfile.h"
#import "JSRequest.h"
#import "JSObjectMappingsProtocol.h"
#import "JSServerInfo.h"
#import "AFHTTPSessionManager.h"

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
*/

@interface JSRESTBase : AFHTTPSessionManager <NSSecureCoding, NSCopying>

/**
 The server profile instance contains connection details for 
 JasperReports server
 */
@property (nonatomic, strong, readonly, nonnull) JSProfile *serverProfile;

/**
 An NSArray of NSHTTPCookie objects

 @since 1.8
 */
@property (nonatomic, readonly, null_unspecified) NSArray <NSHTTPCookie *> *cookies;

/**
 Returns a rest base instance. 
 
 @param serverProfile The server profile instance contains connection details for JasperReports server
 @return A fully configured JSRESTBase instance
 */
- (nonnull instancetype) initWithServerProfile:(nonnull JSProfile *)serverProfile;

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

 @since 2.5
 */

- (void)updateCookiesWithCookies:(NSArray <NSHTTPCookie *>* __nullable)cookies;

@end
