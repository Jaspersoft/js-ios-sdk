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
//  JSRESTBase+JSRESTResource.h
//  Jaspersoft Corporation
//

#import "JSRESTBase.h"
#import "JSResourceDescriptor.h"
#import <Foundation/Foundation.h>

/**
 Extention to <code>JSRESTBase</code> class for working with resources by REST calls.
 
 Contains two types of methods which differs by last parameter: first type uses
 delegate and puts request result into it, second type uses completion
 block.
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Alexey Gubarev ogubarie@tibco.com

 @since 1.3
 */
@interface JSRESTBase(JSRESTResource)

/**
 Creates the resource with specified JSResourceDescriptor
 
 @param resource JSResourceDescriptor of resource being modified
 @param delegate A delegate object to inform of the results
 */
- (void)createResource:(JSResourceDescriptor *)resource delegate:(id<JSRequestDelegate>)delegate;

/**
 Creates the resource with specified JSResourceDescriptor
 
 @param resource JSResourceDescriptor of resource being modified
 @param block The block to inform of the results
 */
- (void)createResource:(JSResourceDescriptor *)resource completionBlock:(JSRequestCompletionBlock)block;

/**
 Modifies the resource with specified JSResourceDescriptor
 
 @param resource JSResourceDescriptor of resource being modified
 @param delegate A delegate object to inform of the results
 */
- (void)modifyResource:(JSResourceDescriptor *)resource delegate:(id<JSRequestDelegate>)delegate;

/**
 Modifies the resource with specified JSResourceDescriptor
 
 @param resource JSResourceDescriptor of resource being modified
 @param block The block to inform of the results
 */
- (void)modifyResource:(JSResourceDescriptor *)resource completionBlock:(JSRequestCompletionBlock)block;

/**
 Deletes the resource with the specified URI

 @param uri The repository URI (i.e. /reports/samples/)
 @param delegate A delegate object to inform of the results
 */
- (void)deleteResource:(NSString *)uri delegate:(id<JSRequestDelegate>)delegate;

/**
 Deletes the resource with the specified URI
 
 @param uri The repository URI (i.e. /reports/samples/)
 @param block The block to inform of the results
 */
- (void)deleteResource:(NSString *)uri completionBlock:(JSRequestCompletionBlock)block;

//---------------------------------------------------------------------
// The Resources Service v2
//---------------------------------------------------------------------

/**
 Gets resource lookup for resource.
 
 @param resourceURI The repository URI (i.e. /reports/samples/)
 @param resourceType Type of required resource
 @param delegate A delegate object to inform of the results

 @since 1.9
 */

- (void)resourceLookupForURI:(NSString *)resourceURI resourceType:(NSString *)resourceType
                    delegate:(id<JSRequestDelegate>)delegate;

/**
 Gets resource lookup for resource.
 
 @param resourceURI The repository URI (i.e. /reports/samples/)
 @param resourceType Type of required resource
 @param block The block to inform of the results
 
 @since 1.9
 */
- (void)resourceLookupForURI:(NSString *)resourceURI resourceType:(NSString *)resourceType
             completionBlock:(JSRequestCompletionBlock)block;


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
 @param block The block to inform of the results
 
 @since 1.7
 */
- (void)resourceLookups:(NSString *)folderUri query:(NSString *)query types:(NSArray *)types
              recursive:(BOOL)recursive offset:(NSInteger)offset limit:(NSInteger)limit completionBlock:(JSRequestCompletionBlock)block;

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
 @param block The block to inform of the results
 
 @since 1.8
 */
- (void)resourceLookups:(NSString *)folderUri query:(NSString *)query types:(NSArray *)types sortBy:(NSString *)sortBy
              recursive:(BOOL)recursive offset:(NSInteger)offset limit:(NSInteger)limit completionBlock:(JSRequestCompletionBlock)block;

@end
