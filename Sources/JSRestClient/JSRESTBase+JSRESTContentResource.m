/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSRESTBase+JSRESTContentResource.h"
#import "JSResourceLookup.h"
#import "JSContentResource.h"
#import "JSRESTBase+JSRESTResource.h"

@implementation JSRESTBase(JSRESTContentResource)

- (void)contentResourceWithResourceLookup:(JSResourceLookup *__nonnull)resourceLookup
                               completion:(void(^ __nonnull)(JSContentResource *resource, NSError *error))completion
{
    [self resourceLookupForURI:resourceLookup.uri
                  resourceType:kJS_WS_TYPE_FILE
                    modelClass:[JSContentResource class]
   autoCompleteSessionIfNeeded:YES
               completionBlock:^(JSOperationResult *result) {
                   if (result.error) {
                       completion(nil, result.error);
                   } else {
                       JSContentResource *resource = result.objects.firstObject;
                       if (resource) {
                           completion(resource, nil);
                       } else {
                           NSError *error = [JSErrorBuilder errorWithCode:JSDataMappingErrorCode];
                           completion(nil, error);
                       }
                   }
               }];
}

@end
