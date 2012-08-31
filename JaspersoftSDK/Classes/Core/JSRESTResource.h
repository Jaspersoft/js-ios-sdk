//
//  JSRESTResources.h
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 13.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSRESTBase.h"
#import "JSResourceDescriptor.h"
#import <Foundation/Foundation.h>

/**
 Provides wrapper methods for <code>JSRESTBase</code> to interact with the 
 <b>repository</b> JasperReports server REST API. This object puts at disposal
 a set of methods for getting list of resources, getting single resource (also 
 getting with query data), creating, modifying and deleting resource (all sending 
 methods are asynchronous and use base sendRequest method from <code>JSRESTBase</code>
 class). 
 
 Contains two types of methods which differs by last parameter: first type uses 
 delegate and puts request result into it, second type uses pre-configuration 
 block for setting additional parameters of JSRequest object. Pre-configuration 
 block implicitly supports finishedBlock usage instead delegate object (or use
 them both), setting custom timeoutInterval, custom query parameters, 
 requestBackgroundPolicy etc.
 
 @author Vlad Zavadskyi vzavadskii@jaspersoft.com
 @since 1.0
 */
@interface JSRESTResource : JSRESTBase

/**
 Returns the shared instance of the resource
 */
+ (JSRESTResource *)sharedInstance;

/**
 Gets the list of resource descriptors for all resources available in the specified 
 repository URI.
 
 @param uri The repository URI (i.e. /reports/samples/)
 @param delegate A delegate object to inform of the results 
 */
- (void)resources:(NSString *)uri delegate:(id<JSRequestDelegate>)delegate;

/**
 Gets the list of resource descriptors for all resources available in the specified 
 repository URI.
 
 @param uri The repository URI (i.e. /reports/samples/)
 @param block The block to execute with the request before sending it for processing
 */
- (void)resources:(NSString *)uri usingBlock:(void (^)(JSRequest *request))block;

/**
 Gets the list of resource descriptors for the resources available in the specified 
 repository URI and matching the specified parameters
 
 @param uri The repository URI (i.e. /reports/samples/)
 @param query Match only resources having the specified text in the name or 
 description (can be <code>nil</code>)
 @param type Match only resources of the given type (can be <code>nil</code>)
 @param recursive Get the resources recursively and not only in the specified URI.
 Used only when a search criteria is specified, either query or type 
 (can be <code>nil</code>)
 @param limit The maximum number of items returned to the client. The default 
 is 0 (can be <code>nil</code>), meaning no limit
 @param delegate A delegate object to inform of the results
 */
- (void)resources:(NSString *)uri query:(NSString *)query type:(NSString *)type 
       recursive:(BOOL)recursive limit:(NSInteger)limit delegate:(id<JSRequestDelegate>)delegate;

/**
 Gets the list of resource descriptors for the resources available in the specified 
 repository URI and matching the specified parameters
 
 @param uri The repository URI (i.e. /reports/samples/)
 @param query Match only resources having the specified text in the name or 
 description (can be <code>nil</code>)
 @param type Match only resources of the given type (can be <code>nil</code>)
 @param recursive Get the resources recursively and not only in the specified URI.
 Used only when a search criteria is specified, either query or type 
 (can be <code>nil</code>)
 @param limit The maximum number of items returned to the client. The default 
 is 0 (can be <code>nil</code>), meaning no limit 
 @param block The block to execute with the request before sending it for processing
 */
- (void)resources:(NSString *)uri query:(NSString *)query type:(NSString *)type 
       recursive:(BOOL)recursive limit:(NSInteger)limit usingBlock:(void (^)(JSRequest *request))block;

/**
 Gets the query data of a query-based input control, according to specified parameters.
 
 @param uri The repository URI of the input control
 @param datasourceUri The repository URI of a datasource for the control
 @param resourceParameters A parameters for the input control (can be <code>nil</code>)
 @param delegate A delegate object to inform of the results
 */
- (void)resourceWithQueryData:(NSString *)uri datasourceUri:(NSString *)datasourceUri
           resourceParameters:(NSArray *)resourceParameters delegate:(id<JSRequestDelegate>)delegate;

/**
 Gets the query data of a query-based input control, according to specified parameters.
 
 @param uri The repository URI of the input control
 @param datasourceUri The repository URI of a datasource for the control
 @param resourceParameters A parameters for the input control (can be <code>nil</code>)
 @param block The block to execute with the request before sending it for processing
 */
- (void)resourceWithQueryData:(NSString *)uri datasourceUri:(NSString *)datasourceUri 
           resourceParameters:(NSArray *)resourceParameters usingBlock:(void (^)(JSRequest *request))block;

/**
 Gets the resource descriptor for the resource with specified URI.
 
 @param uri The repository URI (i.e. /reports/samples/)
 @param delegate A delegate object to inform of the results
 */
- (void)resource:(NSString *)uri delegate:(id<JSRequestDelegate>)delegate;

/**
 Gets the resource descriptor for the resource with specified URI.
 
 @param uri The repository URI (i.e. /reports/samples/)
 @param block The block to execute with the request before sending it for processing
 */
- (void)resource:(NSString *)uri usingBlock:(void (^)(JSRequest *request))block;

/**
 Creates the resource with specified JSResourceDescriptor
 
 @param resource JSResourceDescriptor of resource being modified
 @param delegate A delegate object to inform of the results
 */
- (void)createResource:(JSResourceDescriptor *)resource delegate:(id<JSRequestDelegate>)delegate;

/**
 Creates the resource with specified JSResourceDescriptor
 
 @param resource JSResourceDescriptor of resource being modified
 @param block The block to execute with the request before sending it for processing
 */
- (void)createResource:(JSResourceDescriptor *)resource usingBlock:(void (^)(JSRequest *request))block;

/**
 Modifies the resource with specified JSResourceDescriptor
 
 @param resource JSResourceDescriptor of resource being modified
 @param delegate A delegate object to inform of the results
 */
- (void)modifyResource:(JSResourceDescriptor *)resource delegate:(id<JSRequestDelegate>)delegate;

/**
 Modifies the resource with specified JSResourceDescriptor
 
 @param resource JSResourceDescriptor of resource being modified
 @param block The block to execute with the request before sending it for processing
 */
- (void)modifyResource:(JSResourceDescriptor *)resource usingBlock:(void (^)(JSRequest *request))block;

/**
 Deletes the resource with the specified URI

 @param uri The repository URI (i.e. /reports/samples/)
 @param delegate A delegate object to inform of the results
 */
- (void)deleteResource:(NSString *)uri delegate:(id<JSRequestDelegate>)delegate;

/**
 Deletes the resource with the specified URI
 
 @param uri The repository URI (i.e. /reports/samples/)
 @param block The block to execute with the request before sending it for processing
 */
- (void)deleteResource:(NSString *)uri usingBlock:(void (^)(JSRequest *request))block;

@end
