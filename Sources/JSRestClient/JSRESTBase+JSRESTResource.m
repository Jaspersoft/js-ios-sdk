/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSResourceLookup.h"
#import "JSRESTBase+JSRESTResource.h"
#import "JSResourcePatchRequest.h"
#import "JSResourceLookup.h"

// HTTP resources search parameters
NSString * const _parameterQuery = @"q";
NSString * const _parameterFolderUri = @"folderUri";
NSString * const _parameterType = @"type";
NSString * const _parameterLimit = @"limit";
NSString * const _parameterOffset = @"offset";
NSString * const _parameterRecursive = @"recursive";
NSString * const _parameterSortBy = @"sortBy";
NSString * const _parameterAccessType = @"accessType";
NSString * const _parameterForceFullPage = @"forceFullPage";

// HTTP resources search parameters

@implementation JSRESTBase(JSRESTResource)

#pragma mark -
#pragma mark Public methods for REST V2 resources API

- (void)modifyResource:(nonnull JSResourceLookup *)resource completionBlock:(nullable JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullResourceUri:resource.uri]];
    request.restVersion = JSRESTVersion_2;
    request.method = JSRequestHTTPMethodPATCH;
    request.completionBlock = block;
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSResourceLookup objectMappingForServerProfile:self.serverProfile] keyPath:@"resourceLookup"];

    JSResourcePatchRequest *patchRequest = [JSResourcePatchRequest patchRecuestWithResource:resource];
    request.body = patchRequest;

    [self sendRequest:request];
}


- (void)deleteResource:(NSString *)uri completionBlock:(nullable JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullResourceUri:uri]];
    request.restVersion = JSRESTVersion_2;
    request.method = JSRequestHTTPMethodDELETE;
    request.completionBlock = block;
    [self sendRequest:request];
}

- (void)resourceLookupForURI:(NSString *)resourceURI
                resourceType:(NSString *)resourceType
                   modelClass:(Class)modelClass
autoCompleteSessionIfNeeded:(BOOL)autoCompleteSessionIfNeeded
             completionBlock:(nullable JSRequestCompletionBlock)block
{
    NSString *uri = kJS_REST_RESOURCES_URI;
    if (resourceURI && ![resourceURI isEqualToString:@"/"]) {
        uri = [uri stringByAppendingString:resourceURI.hostEncodedString];
    }
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.restVersion = JSRESTVersion_2;
    if (modelClass) {
        request.objectMapping = [JSMapping mappingWithObjectMapping:[modelClass objectMappingForServerProfile:self.serverProfile] keyPath:nil];
    }
    request.completionBlock = block;
    NSString *responceType = [JSUtils usedMimeType];
    if (resourceType) {
        responceType = [NSString stringWithFormat:@"application/repository.%@+json", resourceType];
    }
    request.additionalHeaders = @{kJSRequestResponceType : responceType};
    request.shouldResendRequestAfterSessionExpiration = autoCompleteSessionIfNeeded;
    
    [self sendRequest:request];
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
    JSRequest *request = [[JSRequest alloc] initWithUri:kJS_REST_RESOURCES_URI];
    request.restVersion = JSRESTVersion_2;
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSResourceLookup objectMappingForServerProfile:self.serverProfile] keyPath:@"resourceLookup"];

    [request addParameter:_parameterFolderUri withStringValue:folderUri];
    [request addParameter:_parameterQuery withStringValue:query];
    [request addParameter:_parameterType withArrayValue:types];
    [request addParameter:_parameterSortBy withStringValue:sortBy];
    [request addParameter:_parameterAccessType withStringValue:accessType];
    [request addParameter:_parameterRecursive withStringValue:[JSUtils stringFromBOOL:recursive]];
    [request addParameter:_parameterOffset withIntegerValue:offset];
    [request addParameter:_parameterLimit withIntegerValue:limit];
    [request addParameter:_parameterForceFullPage withStringValue:[JSUtils stringFromBOOL:YES]];
    
    request.completionBlock = block;
    [self sendRequest:request];
}

- (NSString *)generateThumbnailImageUrl:(NSString *)resourceURI
{
    return  [NSString stringWithFormat:@"%@/%@%@%@?defaultAllowed=false", self.serverProfile.serverUrl, kJS_REST_SERVICES_V2_URI, kJS_REST_RESOURCE_THUMBNAIL_URI, resourceURI.hostEncodedString];
}

#pragma mark -
#pragma mark Private methods

- (NSString *)fullResourceUri:(NSString *)uri {
    return [NSString stringWithFormat:@"%@%@", kJS_REST_RESOURCE_URI, (uri.hostEncodedString ?: @"")];
}

@end
