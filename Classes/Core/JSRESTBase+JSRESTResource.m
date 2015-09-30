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
//  JSRESTBase+JSRESTResource.m
//  Jaspersoft Corporation
//

#import "JSConstants.h"
#import "JSResourceLookup.h"
#import "JSResourceDescriptor.h"
#import "JSRESTBase+JSRESTResource.h"

// HTTP resources search parameters
static NSString * const _parameterQuery = @"q";
static NSString * const _parameterFolderUri = @"folderUri";
static NSString * const _parameterType = @"type";
static NSString * const _parameterLimit = @"limit";
static NSString * const _parameterOffset = @"offset";
static NSString * const _parameterRecursive = @"recursive";
static NSString * const _parameterSortBy = @"sortBy";
static NSString * const _parameterAccessType = @"accessType";
static NSString * const _parameterForceFullPage = @"forceFullPage";

// HTTP resources search parameters

@implementation JSRESTBase(JSRESTResource)

#pragma mark -
#pragma mark Public methods for resources API

- (void)createResource:(JSResourceDescriptor *)resource completionBlock:(nullable JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullResourceUri:nil]];
    request.expectedModelClass = [JSResourceDescriptor class];
    request.method = RKRequestMethodPOST;
    request.body = resource;
    request.completionBlock = block;
    [self sendRequest:request];
}

- (void)modifyResource:(JSResourceDescriptor *)resource completionBlock:(nullable JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullResourceUri:resource.uriString]];
    request.expectedModelClass = [JSResourceDescriptor class];
    request.method = RKRequestMethodPUT;
    request.body = resource;
    request.completionBlock = block;
    [self sendRequest:request];
}

#pragma mark -
#pragma mark Public methods for REST V2 resources API

- (void)deleteResource:(NSString *)uri completionBlock:(nullable JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullResourceUri:uri]];
    request.restVersion = JSRESTVersion_2;
    request.method = RKRequestMethodDELETE;
    request.completionBlock = block;
    [self sendRequest:request];
}

- (void)resourceLookupForURI:(NSString *)resourceURI
                resourceType:(NSString *)resourceType
                   modelClass:(Class)modelClass
             completionBlock:(nullable JSRequestCompletionBlock)block
{
    NSString *uri = [JSConstants sharedInstance].REST_RESOURCES_URI;
    if (resourceURI && ![resourceURI isEqualToString:@"/"]) {
        uri = [uri stringByAppendingString:resourceURI];
    }
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.restVersion = JSRESTVersion_2;
    request.expectedModelClass = modelClass;
    request.completionBlock = block;
    NSString *responceType = @"application/json";
    if (resourceType) {
        responceType = [NSString stringWithFormat:@"application/repository.%@+json", resourceType];
    }
    [self sendRequest:request additionalHTTPHeaderFields:@{kJSRequestResponceType : responceType}];
}

- (void)resourceLookupForURI:(NSString *)resourceURI
                resourceType:(NSString *)resourceType
             completionBlock:(nullable JSRequestCompletionBlock)block
{
    [self resourceLookupForURI:resourceURI
                  resourceType:resourceType
                    modelClass:[JSResourceLookup class]
               completionBlock:block];
}

- (void)resourceLookups:(NSString *)folderUri
                  query:(NSString *)query
                  types:(NSArray *)types
                 sortBy:(NSString *)sortBy
              recursive:(BOOL)recursive
                 offset:(NSInteger)offset
                  limit:(NSInteger)limit
        completionBlock:(nullable JSRequestCompletionBlock)block
{
    [self resourceLookups:folderUri query:query types:types sortBy:sortBy accessType:@"viewed" recursive:recursive offset:offset limit:limit completionBlock:block];
}

- (void)resourceLookups:(NSString *)folderUri
                  query:(NSString *)query
                  types:(NSArray <NSString *> *)types
                 sortBy:(NSString *)sortBy
             accessType:(NSString *)accessType
              recursive:(BOOL)recursive
                 offset:(NSInteger)offset
                  limit:(NSInteger)limit
        completionBlock:(nullable JSRequestCompletionBlock)block
{
    JSRequest *request = [[JSRequest alloc] initWithUri:[JSConstants sharedInstance].REST_RESOURCES_URI];
    request.restVersion = JSRESTVersion_2;
    request.expectedModelClass = [JSResourceLookup class];
    
    [request addParameter:_parameterFolderUri withStringValue:folderUri];
    [request addParameter:_parameterQuery withStringValue:query];
    [request addParameter:_parameterType withArrayValue:types];
    [request addParameter:_parameterSortBy withStringValue:sortBy];
    [request addParameter:_parameterAccessType withStringValue:accessType];
    [request addParameter:_parameterRecursive withStringValue:[JSConstants stringFromBOOL:recursive]];
    [request addParameter:_parameterOffset withIntegerValue:offset];
    [request addParameter:_parameterLimit withIntegerValue:limit];
    [request addParameter:_parameterForceFullPage withStringValue:[JSConstants stringFromBOOL:YES]];
    
    request.completionBlock = block;
    [self sendRequest:request];
}

- (NSString *)generateThumbnailImageUrl:(NSString *)resourceURI
{
    NSString *restURI = [JSConstants sharedInstance].REST_SERVICES_V2_URI;
    NSString *thumbnailURI = [JSConstants sharedInstance].REST_RESOURCE_THUMBNAIL_URI;
    return  [NSString stringWithFormat:@"%@/%@%@%@?defaultAllowed=false", self.serverProfile.serverUrl, restURI, thumbnailURI, resourceURI];
}

#pragma mark -
#pragma mark Private methods

- (NSString *)fullResourcesUri:(NSString *)uri {
    return [NSString stringWithFormat:@"%@%@", [JSConstants sharedInstance].REST_RESOURCES_URI, (uri ?: @"")];
}

- (NSString *)fullResourceUri:(NSString *)uri {
    return [NSString stringWithFormat:@"%@%@", [JSConstants sharedInstance].REST_RESOURCE_URI, (uri ?: @"")];
}

@end
