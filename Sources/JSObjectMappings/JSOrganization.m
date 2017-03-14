/*
 * Copyright © 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSOrganization.h"

@implementation JSOrganization

#pragma mark - JSObjectMappingsProtocol

+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"alias", @"parentId", @"tenantName", @"parentId", @"tenantNote",
                                          @"tenantUri", @"tenantFolderUri", @"theme"]];
        
        [mapping mapPropertiesFromDictionary:@{@"id"            : @"organizationId",
                                               @"tenantDesc"    : @"tenantDescription"}];
    }];
}

@end
