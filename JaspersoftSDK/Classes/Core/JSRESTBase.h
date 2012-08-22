

//
//  JSClient.h
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
 The <code>JSRESTBase</code> object providing helper methods 
 for classes which interact with the JasperReports Server REST
 API. The object puts at disposal a set of methods for creating JSRequests 
 for different API parts, different types of cancel request(s)

 @author Vlad Zavadskii
 @version $Id: JSRESTBase.h 2012-07-03 11:33:35 vzavadskii $
 @since 1.0
 */
@interface JSRESTBase : NSObject

// Check if network is available
+ (BOOL)isNetworkReachable;

/**
 JSProfile uses to store connection details to use the JasperReports Server REST API
 */
@property (nonatomic, retain) JSProfile *serverProfile;

/** 
 JSSerializer uses to convert object to encoded string (i.e. XML, JSON, etc) 
 for PUT/POST request (default is JSXMLParser)
 */
@property (nonatomic, retain) id<JSSerializer> serializer;

/**
 Timeout interval which will be used (as default) for all requests without its own interval
 Default value is 120s
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/** 
 Initialization with JSProfile instance.
 */
- (id)initWithProfile:(JSProfile *)profile;

/** 
 Initialization with JSProfile instance and mapping rules 
 (map XML, JSON etc directly to object) for specified classes
 from ObjectMapping directory
 */
- (id)initWithProfile:(JSProfile *)profile classesForMappings:(NSArray *)classes;

/**
 Sending asynchronous request
 */
- (void)sendRequest:(JSRequest *)request;

/** 
 Cancel AllRequests for specified delegate object
 */
- (void)cancelRequestsWithDelegate:(id<JSRequestDelegate>)delegate;

/** 
 Cancel AllRequests
 */
- (void)cancelAllRequests;

@end
