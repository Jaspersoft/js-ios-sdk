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
//  JSRESTResources.m
//  Jaspersoft Corporation
//

#import "JSConstants.h"
#import "JSRequestBuilder.h"
#import "JSResourceLookup.h"
#import "JSResourceDescriptor.h"
#import "JSResourceParameter.h"
#import "JSRESTResource.h"
#import "JSParamsBuilder.h"

// Shared (1-st initialized) resource instance
static JSRESTResource *_sharedInstance;

// HTTP resources search parameters
static NSString * const _parameterQuery = @"q";
static NSString * const _parameterFolderUri = @"folderUri";
static NSString * const _parameterType = @"type";
static NSString * const _parameterLimit = @"limit";
static NSString * const _parameterOffset = @"offset";
static NSString * const _parameterRecursive = @"recursive";
static NSString * const _parameterSortBy = @"sortBy";
static NSString * const _parameterForceFullPage = @"forceFullPage";

// HTTP resources search parameters

@implementation JSRESTResource

+ (JSRESTResource *)sharedInstance {
    return _sharedInstance;
}

- (id)initWithProfile:(JSProfile *)profile {
    NSArray *classesForMappings = [[NSArray alloc] initWithObjects:[JSResourceDescriptor class], [JSResourceLookup class], nil];
    
    if ((self = [super initWithProfile:profile classesForMappings:classesForMappings]) && !_sharedInstance) {
        _sharedInstance = self;
    }
    
    return self;
}

- (id)init {
    return [self initWithProfile:nil];
}

#pragma mark -
#pragma mark Public methods for resources API

- (void)resources:(NSString *)uri delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourcesUri:uri] method:JSRequestMethodGET] delegate:delegate];
    [self sendRequest:builder.request];
}

- (void)resources:(NSString *)uri usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [JSRequestBuilder requestWithUri:[self fullResourcesUri:uri] method:JSRequestMethodGET];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)resources:(NSString *)uri query:(NSString *)query types:(NSArray *)types
        recursive:(BOOL)recursive limit:(NSInteger)limit delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourcesUri:uri] method:JSRequestMethodGET] delegate:delegate];
    
    JSParamsBuilder *paramsBuilder = [[JSParamsBuilder alloc] init];
    [paramsBuilder addParameter:_parameterQuery withStringValue:query];
    [paramsBuilder addParameter:_parameterType withArrayValue:types];
    [paramsBuilder addParameter:_parameterLimit withIntegerValue:limit];
    if (recursive) [paramsBuilder addParameter:_parameterRecursive withStringValue:[JSConstants stringFromBOOL:recursive]];
    
    [self sendRequest:[builder params:paramsBuilder.params].request];
}

- (void)resources:(NSString *)uri query:(NSString *)query types:(NSArray *)types
        recursive:(BOOL)recursive limit:(NSInteger)limit usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [JSRequestBuilder requestWithUri:[self fullResourcesUri:uri] method:JSRequestMethodGET];
    
    JSParamsBuilder *paramsBuilder = [[JSParamsBuilder alloc] init];
    [paramsBuilder addParameter:_parameterQuery withStringValue:query];
    [paramsBuilder addParameter:_parameterType withArrayValue:types];
    [paramsBuilder addParameter:_parameterLimit withIntegerValue:limit];
    if (recursive) [paramsBuilder addParameter:_parameterRecursive withStringValue:[JSConstants stringFromBOOL:recursive]];
    
    [self sendRequest:[[builder params:paramsBuilder.params].request usingBlock:block]];
}

- (void)resourceWithQueryData:(NSString *)uri datasourceUri:(NSString *)datasourceUri
           resourceParameters:(NSArray *)resourceParameters delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourceUri:uri] method:JSRequestMethodGET] delegate:delegate];
    [builder params:[self paramsForICQueryDataByDatasourceUri:datasourceUri resourceParameters:resourceParameters]];
    [self sendRequest:builder.request];
}

- (void)resourceWithQueryData:(NSString *)uri datasourceUri:(NSString *)datasourceUri
           resourceParameters:(NSArray *)resourceParameters usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [JSRequestBuilder requestWithUri:[self fullResourceUri:uri] method:JSRequestMethodGET];
    [builder params:[self paramsForICQueryDataByDatasourceUri:datasourceUri resourceParameters:resourceParameters]];
    [self sendRequest:[builder.request usingBlock:block]];
}

#pragma mark -
#pragma mark Public methods for REST V2 resources API

- (void)resourceLookups:(NSString *)folderUri query:(NSString *)query types:(NSArray *)types
              recursive:(BOOL)recursive offset:(NSInteger)offset limit:(NSInteger)limit delegate:(id<JSRequestDelegate>)delegate {
    [self resourceLookups:folderUri query:query types:types sortBy:nil recursive:recursive offset:offset limit:limit delegate:delegate];
}

- (void)resourceLookups:(NSString *)folderUri query:(NSString *)query types:(NSArray *)types
              recursive:(BOOL)recursive offset:(NSInteger)offset limit:(NSInteger)limit usingBlock:(JSRequestConfigurationBlock)block {
    [self resourceLookups:folderUri query:query types:types sortBy:nil recursive:recursive offset:offset limit:limit usingBlock:block];
}

- (void)resourceLookups:(NSString *)folderUri query:(NSString *)query types:(NSArray *)types sortBy:(NSString *)sortBy
              recursive:(BOOL)recursive offset:(NSInteger)offset limit:(NSInteger)limit delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[JSConstants sharedInstance].REST_RESOURCES_URI method:JSRequestMethodGET]
                                 restVersion:JSRESTVersion_2];
    
    JSParamsBuilder *paramsBuilder = [[JSParamsBuilder alloc] init];
    [paramsBuilder addParameter:_parameterFolderUri withStringValue:folderUri];
    [paramsBuilder addParameter:_parameterQuery withStringValue:query];
    [paramsBuilder addParameter:_parameterType withArrayValue:types];
    [paramsBuilder addParameter:_parameterSortBy withStringValue:sortBy];
    [paramsBuilder addParameter:_parameterLimit withIntegerValue:limit];
    [paramsBuilder addParameter:_parameterRecursive withStringValue:[JSConstants stringFromBOOL:recursive]];
    [paramsBuilder addParameter:_parameterOffset withIntegerValue:offset];
    [paramsBuilder addParameter:_parameterLimit withIntegerValue:limit];
    [paramsBuilder addParameter:_parameterForceFullPage withStringValue:[JSConstants stringFromBOOL:YES]];
    
    [[builder params:paramsBuilder.params] delegate:delegate];
    [self sendRequest:builder.request];
}

- (void)resourceLookups:(NSString *)folderUri query:(NSString *)query types:(NSArray *)types sortBy:(NSString *)sortBy
              recursive:(BOOL)recursive offset:(NSInteger)offset limit:(NSInteger)limit usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[JSConstants sharedInstance].REST_RESOURCES_URI method:JSRequestMethodGET]
                                 restVersion:JSRESTVersion_2];
    
    JSParamsBuilder *paramsBuilder = [[JSParamsBuilder alloc] init];
    [paramsBuilder addParameter:_parameterFolderUri withStringValue:folderUri];
    [paramsBuilder addParameter:_parameterQuery withStringValue:query];
    [paramsBuilder addParameter:_parameterType withArrayValue:types];
    [paramsBuilder addParameter:_parameterSortBy withStringValue:sortBy];
    [paramsBuilder addParameter:_parameterLimit withIntegerValue:limit];
    [paramsBuilder addParameter:_parameterRecursive withStringValue:[JSConstants stringFromBOOL:recursive]];
    [paramsBuilder addParameter:_parameterOffset withIntegerValue:offset];
    [paramsBuilder addParameter:_parameterLimit withIntegerValue:limit];
    [paramsBuilder addParameter:_parameterForceFullPage withStringValue:[JSConstants stringFromBOOL:YES]];
    
    [builder params:paramsBuilder.params];
    [self sendRequest:[builder.request usingBlock:block]];
}

#pragma mark -
#pragma mark Public methods for resource API

- (void)resource:(NSString *)uri delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourceUri:uri] method:JSRequestMethodGET] delegate:delegate];
    [self sendRequest:builder.request];
}

- (void)resource:(NSString *)uri usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [JSRequestBuilder requestWithUri:[self fullResourceUri:uri]
                                                          method:JSRequestMethodGET];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)createResource:(JSResourceDescriptor *)resource delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullResourceUri:nil] method:JSRequestMethodPUT]
                                  delegate:delegate] body:resource];
    [self sendRequest:builder.request];
}

- (void)createResource:(JSResourceDescriptor *)resource usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourceUri:nil] method:JSRequestMethodPUT] body:resource];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)modifyResource:(JSResourceDescriptor *)resource delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullResourceUri:resource.uriString] method:JSRequestMethodPOST]
                                  delegate:delegate] body:resource];
    [self sendRequest:builder.request];
}

- (void)modifyResource:(JSResourceDescriptor *)resource usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourceUri:resource.uriString] method:JSRequestMethodPOST]
                                 body:resource];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)deleteResource:(NSString *)uri delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourceUri:uri] method:JSRequestMethodDELETE] delegate:delegate];
    [self sendRequest:builder.request];
}

- (void)deleteResource:(NSString *)uri usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [JSRequestBuilder requestWithUri:[self fullResourceUri:uri] method:JSRequestMethodDELETE];
    [self sendRequest:[builder.request usingBlock:block]];
}

#pragma mark -
#pragma mark Private methods

- (NSDictionary *)paramsForICQueryDataByDatasourceUri:(NSString *)datasourceUri resourceParameters:(NSArray *)resourceParameters {
    NSMutableDictionary *configuredParams = [[NSMutableDictionary alloc] init] ;
    if (datasourceUri == nil || datasourceUri.length == 0) {
        datasourceUri = @"null";
    }
    [configuredParams setObject:datasourceUri forKey:@"IC_GET_QUERY_DATA"];
    for (JSResourceParameter *resourceParameter in resourceParameters) {
        NSString *paramKey = [NSString stringWithFormat:([resourceParameter.isListItem boolValue] ? @"PL_%@" : @"P_%@"), resourceParameter.name];
        
        if (resourceParameter.isListItem) {
            NSMutableArray *values = [configuredParams objectForKey:paramKey] ?: [[NSMutableArray alloc] init];
            [values addObject:resourceParameter.value];
            [configuredParams setObject:values forKey:paramKey];
        } else {
            [configuredParams setObject:resourceParameter.value forKey:paramKey];
        }
    }
    
    return configuredParams;
}

- (NSString *)fullResourcesUri:(NSString *)uri {
    return [NSString stringWithFormat:@"%@%@", [JSConstants sharedInstance].REST_RESOURCES_URI, (uri ?: @"")];
}

- (NSString *)fullResourceUri:(NSString *)uri {
    return [NSString stringWithFormat:@"%@%@", [JSConstants sharedInstance].REST_RESOURCE_URI, (uri ?: @"")];
}

@end
