/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.3
 */


#import "JSRESTBase.h"
#import "JSResourceLookup.h"

/**
 Extention to <code>JSRESTBase</code> class for working with resources by REST calls.
 */
@interface JSRESTBase(JSRESTResource)

//---------------------------------------------------------------------
// The Resources Service v2
//---------------------------------------------------------------------

/**
 Modifies the resource with specified JSResourceLookup
 
 @param resource JSResourceLookup of resource being modified
 @param block The block to inform of the results
 */
- (void)modifyResource:(nonnull JSResourceLookup *)resource completionBlock:(nullable JSRequestCompletionBlock)block;


/**
 Deletes the resource with the specified URI
 
 @param uri The repository URI (i.e. /reports/samples/)
 @param block The block to inform of the results
 */
- (void)deleteResource:(nonnull NSString *)uri completionBlock:(nullable JSRequestCompletionBlock)block;

/**
Gets resource lookup for resource.

@param resourceURI The repository URI (i.e. /reports/samples/)
@param resourceType Type of required resource
@param modelClass expected model class
@param block The block to inform of the results

@since 2.1
*/
- (void)resourceLookupForURI:(nonnull NSString *)resourceURI
                resourceType:(nonnull NSString *)resourceType
                  modelClass:(nonnull Class)modelClass
             completionBlock:(nullable JSRequestCompletionBlock)block;

/**
 Gets the list of resource lookups for the resources available in the specified
 folder and matching the specified parameters
 
 @param folderUri The repository URI (i.e. /reports/samples/)
 @param query Match only resources having the specified text in the name or
 description (can be <code>nil</code>)
 @param types Match only resources of the given types (can be <code>nil</code>)
 @param sortBy Represents a field in the results to sort by: uri, label, description,
 type, creationDate, updateDate, accessTime, or popularity (based on access events).
 @param accessType Used if sortBy is equal to accessTime or popularity
 @param recursive Get the resources recursively (can be <code>nil</code>)
 @param offset Start index for requested page
 @param limit The maximum number of items returned to the client. The default
 is 0 (can be <code>nil</code>), meaning no limit
 @param block The block to inform of the results
 
 @since 2.1
 */
- (void)resourceLookups:(nullable NSString *)folderUri query:(nullable NSString *)query types:(nullable NSArray <NSString *> *)types
                 sortBy:(nullable NSString *)sortBy accessType:(nonnull NSString *)accessType recursive:(BOOL)recursive
                 offset:(NSInteger)offset limit:(NSInteger)limit completionBlock:(nullable JSRequestCompletionBlock)block;

/**
 Generates the resource thumbnail url
 
 @param resourceURI A resourceURI for generating for thumbnail url for it
 @return A generated recource thumbnail image url
 
 @since 2.1
 */
- (nonnull NSString *)generateThumbnailImageUrl:(nonnull NSString *)resourceURI;

@end
