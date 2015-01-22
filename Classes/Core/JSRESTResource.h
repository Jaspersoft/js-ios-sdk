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
//  JSRESTResources.h
//  Jaspersoft Corporation
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
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Alexey Gubarev ogubarie@tibco.com

 @since 1.3
 */
@interface JSRESTResource : JSRESTBase

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
- (void)resources:(NSString *)uri usingBlock:(JSRequestConfigurationBlock)block;

/**
 Gets the list of resource descriptors for the resources available in the specified 
 repository URI and matching the specified parameters
 
 @param uri The repository URI (i.e. /reports/samples/)
 @param query Match only resources having the specified text in the name or 
 description (can be <code>nil</code>)
 @param types Match only resources of the given types (can be <code>nil</code>)
 @param recursive Get the resources recursively and not only in the specified URI.
 Used only when a search criteria is specified, either query or type 
 (can be <code>nil</code>)
 @param limit The maximum number of items returned to the client. The default 
 is 0 (can be <code>nil</code>), meaning no limit
 @param delegate A delegate object to inform of the results
 */
- (void)resources:(NSString *)uri query:(NSString *)query types:(NSArray *)types
       recursive:(BOOL)recursive limit:(NSInteger)limit delegate:(id<JSRequestDelegate>)delegate;

/**
 Gets the list of resource descriptors for the resources available in the specified 
 repository URI and matching the specified parameters
 
 @param uri The repository URI (i.e. /reports/samples/)
 @param query Match only resources having the specified text in the name or 
 description (can be <code>nil</code>)
 @param types Match only resources of the given types (can be <code>nil</code>)
 @param recursive Get the resources recursively and not only in the specified URI.
 Used only when a search criteria is specified, either query or type 
 (can be <code>nil</code>)
 @param limit The maximum number of items returned to the client. The default 
 is 0 (can be <code>nil</code>), meaning no limit 
 @param block The block to execute with the request before sending it for processing
 */
- (void)resources:(NSString *)uri query:(NSString *)query types:(NSArray *)types 
       recursive:(BOOL)recursive limit:(NSInteger)limit usingBlock:(JSRequestConfigurationBlock)block;

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
           resourceParameters:(NSArray *)resourceParameters usingBlock:(JSRequestConfigurationBlock)block;

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
- (void)resource:(NSString *)uri usingBlock:(JSRequestConfigurationBlock)block;

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
- (void)createResource:(JSResourceDescriptor *)resource usingBlock:(JSRequestConfigurationBlock)block;

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
- (void)modifyResource:(JSResourceDescriptor *)resource usingBlock:(JSRequestConfigurationBlock)block;

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
- (void)deleteResource:(NSString *)uri usingBlock:(JSRequestConfigurationBlock)block;

//---------------------------------------------------------------------
// The Resources Service v2
//---------------------------------------------------------------------

/**
 Gets resource lookup for resource.
 
 @param resourceURI The repository URI (i.e. /reports/samples/)
 @param delegate A delegate object to inform of the results

 @since 1.9
 */

- (void)getResourceLookup:(NSString *)resourceURI delegate:(id<JSRequestDelegate>)delegate;

/**
 Gets resource lookup for resource.
 
 @param resourceURI The repository URI (i.e. /reports/samples/)
 @param block The block to execute with the request before sending it for processing
 
 @since 1.9
 */
- (void)getResourceLookup:(NSString *)resourceURI usingBlock:(JSRequestConfigurationBlock)block;


/**
 Gets the list of resource lookups for the resources available in the specified
 folder and matching the specified parameters
 
 @param folderUri The repository URI (i.e. /reports/samples/)
 @param query Match only resources having the specified text in the name or
 description (can be <code>nil</code>)
 @param types Match only resources of the given types (can be <code>nil</code>)
 @param recursive Get the resources recursively (can be <code>nil</code>)
 @param offset Start index for requested page
 @param limit The maximum number of items returned to the client. The default
 is 0 (can be <code>nil</code>), meaning no limit
 @param delegate A delegate object to inform of the results
 
 @since 1.7
 */
- (void)resourceLookups:(NSString *)folderUri query:(NSString *)query types:(NSArray *)types
              recursive:(BOOL)recursive offset:(NSInteger)offset limit:(NSInteger)limit delegate:(id<JSRequestDelegate>)delegate;

/**
 Gets the list of resource lookups for the resources available in the specified
 folder and matching the specified parameters
 
 @param folderUri The repository URI (i.e. /reports/samples/)
 @param query Match only resources having the specified text in the name or
 description (can be <code>nil</code>)
 @param types Match only resources of the given types (can be <code>nil</code>)
 @param recursive Get the resources recursively (can be <code>nil</code>)
 @param offset Start index for requested page
 @param limit The maximum number of items returned to the client. The default
 is 0 (can be <code>nil</code>), meaning no limit
 @param block The block to execute with the request before sending it for processing
 
 @since 1.7
 */
- (void)resourceLookups:(NSString *)folderUri query:(NSString *)query types:(NSArray *)types
              recursive:(BOOL)recursive offset:(NSInteger)offset limit:(NSInteger)limit usingBlock:(JSRequestConfigurationBlock)block;

/**
 Gets the list of resource lookups for the resources available in the specified
 folder and matching the specified parameters
 
 @param folderUri The repository URI (i.e. /reports/samples/)
 @param query Match only resources having the specified text in the name or
 description (can be <code>nil</code>)
 @param types Match only resources of the given types (can be <code>nil</code>)
 @param sortBy Represents a field in the results to sort by: uri, label, description, 
 type, creationDate, updateDate, accessTime, or popularity (based on access events).
 @param recursive Get the resources recursively (can be <code>nil</code>)
 @param offset Start index for requested page
 @param limit The maximum number of items returned to the client. The default
 is 0 (can be <code>nil</code>), meaning no limit
 @param delegate A delegate object to inform of the results
 
 @since 1.8
 */
- (void)resourceLookups:(NSString *)folderUri query:(NSString *)query types:(NSArray *)types sortBy:(NSString *)sortBy
              recursive:(BOOL)recursive offset:(NSInteger)offset limit:(NSInteger)limit delegate:(id<JSRequestDelegate>)delegate;

/**
 Gets the list of resource lookups for the resources available in the specified
 folder and matching the specified parameters
 
 @param folderUri The repository URI (i.e. /reports/samples/)
 @param query Match only resources having the specified text in the name or
 description (can be <code>nil</code>)
 @param types Match only resources of the given types (can be <code>nil</code>)
 @param sortBy Represents a field in the results to sort by: uri, label, description,
 type, creationDate, updateDate, accessTime, or popularity (based on access events).
 @param recursive Get the resources recursively (can be <code>nil</code>)
 @param offset Start index for requested page
 @param limit The maximum number of items returned to the client. The default
 is 0 (can be <code>nil</code>), meaning no limit
 @param block The block to execute with the request before sending it for processing
 
 @since 1.8
 */
- (void)resourceLookups:(NSString *)folderUri query:(NSString *)query types:(NSArray *)types sortBy:(NSString *)sortBy
              recursive:(BOOL)recursive offset:(NSInteger)offset limit:(NSInteger)limit usingBlock:(JSRequestConfigurationBlock)block;

@end
