//
//  JSRESTBase.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 03.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSProfile.h"
#import "JSRequest.h"
#import "JSSerializer.h"
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
 @since 1.0
*/
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
 Cancels all requests for specified delegate object
 
 @param delegate The delegate object
 */
- (void)cancelRequestsWithDelegate:(id<JSRequestDelegate>)delegate;

/** 
 Cancels all requests 
 */
- (void)cancelAllRequests;

@end
