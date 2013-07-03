//
//  JSRESTResources.m
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 13.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSConstants.h"
#import "JSRequestBuilder.h"
#import "JSResourceDescriptor.h"
#import "JSResourceParameter.h"
#import "JSRESTResource.h"

// Shared (1-st initialized) resource instance
static JSRESTResource *_sharedInstance;

@implementation JSRESTResource

+ (JSRESTResource *)sharedInstance {
    return _sharedInstance;
}

- (id)initWithProfile:(JSProfile *)profile {
    NSArray *classesForMappings = [[NSArray alloc] initWithObjects:[JSResourceDescriptor class], nil];
    
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

- (void)resources:(NSString *)uri usingBlock:(void (^)(JSRequest *request))block {
    JSRequestBuilder *builder = [JSRequestBuilder requestWithUri:[self fullResourcesUri:uri] method:JSRequestMethodGET];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)resources:(NSString *)uri query:(NSString *)query types:(NSArray *)types
        recursive:(BOOL)recursive limit:(NSInteger)limit delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourcesUri:uri] method:JSRequestMethodGET] delegate:delegate];
    [builder params:[self createParamsForResources:query types:types recursive:recursive limit:limit]];
    [self sendRequest:builder.request];
}

- (void)resources:(NSString *)uri query:(NSString *)query types:(NSArray *)types
        recursive:(BOOL)recursive limit:(NSInteger)limit usingBlock:(void (^)(JSRequest *request))block {
    JSRequestBuilder *builder = [JSRequestBuilder requestWithUri:[self fullResourcesUri:uri] method:JSRequestMethodGET];
    [builder params:[self createParamsForResources:query types:types recursive:recursive limit:limit]];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)resourceWithQueryData:(NSString *)uri datasourceUri:(NSString *)datasourceUri
           resourceParameters:(NSArray *)resourceParameters delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourceUri:uri] method:JSRequestMethodGET] delegate:delegate];
    [builder params:[self paramsForICQueryDataByDatasourceUri:datasourceUri resourceParameters:resourceParameters]];
    [self sendRequest:builder.request];
}

- (void)resourceWithQueryData:(NSString *)uri datasourceUri:(NSString *)datasourceUri
           resourceParameters:(NSArray *)resourceParameters usingBlock:(void (^)(JSRequest *request))block {
    JSRequestBuilder *builder = [JSRequestBuilder requestWithUri:[self fullResourceUri:uri] method:JSRequestMethodGET];
    [builder params:[self paramsForICQueryDataByDatasourceUri:datasourceUri resourceParameters:resourceParameters]];
    [self sendRequest:[builder.request usingBlock:block]];
}

#pragma mark -
#pragma mark Public methods for resource API

- (void)resource:(NSString *)uri delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourceUri:uri] method:JSRequestMethodGET] delegate:delegate];
    [self sendRequest:builder.request];
}

- (void)resource:(NSString *)uri usingBlock:(void (^)(JSRequest *request))block {
    JSRequestBuilder *builder = [JSRequestBuilder requestWithUri:[self fullResourceUri:uri]
                                                          method:JSRequestMethodGET];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)createResource:(JSResourceDescriptor *)resource delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullResourceUri:nil] method:JSRequestMethodPUT]
                                  delegate:delegate] body:resource];
    [self sendRequest:builder.request];
}

- (void)createResource:(JSResourceDescriptor *)resource usingBlock:(void (^)(JSRequest *request))block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourceUri:nil] method:JSRequestMethodPUT] body:resource];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)modifyResource:(JSResourceDescriptor *)resource delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullResourceUri:resource.uriString] method:JSRequestMethodPOST]
                                  delegate:delegate] body:resource];
    [self sendRequest:builder.request];
}

- (void)modifyResource:(JSResourceDescriptor *)resource usingBlock:(void (^)(JSRequest *request))block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourceUri:resource.uriString] method:JSRequestMethodPOST]
                                 body:resource];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)deleteResource:(NSString *)uri delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullResourceUri:uri] method:JSRequestMethodDELETE] delegate:delegate];
    [self sendRequest:builder.request];
    
}

- (void)deleteResource:(NSString *)uri usingBlock:(void (^)(JSRequest *request))block {
    JSRequestBuilder *builder = [JSRequestBuilder requestWithUri:[self fullResourceUri:uri] method:JSRequestMethodDELETE];
    [self sendRequest:[builder.request usingBlock:block]];
}

#pragma mark -
#pragma mark Private methods

// Creates NSMutableDictionary params for resources by query, type, recursive, limit arguments
- (NSMutableDictionary *)createParamsForResources:(NSString *)query types:(NSArray *)types recursive:(BOOL)recursive limit:(NSInteger)limit {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if (query && query.length) {
        [params setObject:query forKey:@"q"];
    }
    if (types && types.count) {
        [params setObject:types forKey:@"type"];
    }
    if (recursive) {
        [params setObject:@"true" forKey:@"recursive"];
    }
    if (limit && limit > 0) {
        [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    }
    
    return params;
}

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
