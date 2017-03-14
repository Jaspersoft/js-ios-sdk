/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSDashboardExportExecutionStatus.h"
#import "EKMapper.h"

@implementation JSDashboardExportExecutionStatus
#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"progress": @"progress",
                                               @"id": @"identifier"
                                               }];
        [mapping mapKeyPath:@"status" toProperty:@"status" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *statusDictionary = @{@"value" : value};
            return [EKMapper objectFromExternalRepresentation:statusDictionary withMapping:[JSExecutionStatus objectMappingForServerProfile:serverProfile]];
        }];
    }];
}

@end
