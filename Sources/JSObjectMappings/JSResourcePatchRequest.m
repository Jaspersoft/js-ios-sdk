/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */



#import "JSResourcePatchRequest.h"
#import "JSPatchResourceParameter.h"

@implementation JSResourcePatchRequest

- (nonnull instancetype)initWithResource:(nonnull JSResourceLookup *)resource {
    self = [super init];
    if (self) {
        self.version = resource.version;
        self.patch = [self patchesArrayFromResource:resource];
    }
    return self;
}

+ (nonnull instancetype)patchRecuestWithResource:(nonnull JSResourceLookup *)resource {
    return [[[self class] alloc] initWithResource:resource];
}

#pragma mark - JSObjectMappingsProtocol

+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"version": @"version"
                                               }];
        [mapping hasMany:[JSPatchResourceParameter class] forKeyPath:@"patch" forProperty:@"patch" withObjectMapping:[JSPatchResourceParameter objectMappingForServerProfile:serverProfile]];
    }];
}

#pragma mark - Private API
- (NSArray *)patchesArrayFromResource:(JSResourceLookup *)resource {
    NSMutableArray *patchesArray = [NSMutableArray array];
    [patchesArray addObject:[JSPatchResourceParameter parameterWithName:@"label" value:resource.label]];
    [patchesArray addObject:[JSPatchResourceParameter parameterWithName:@"description" value:resource.resourceDescription]];
    return [patchesArray copy];
}

@end
