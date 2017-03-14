/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSDashboardExportExecutionResource.h"
#import "EKSerializer.h"
#import "EKMapper.h"

@implementation JSDashboardExportExecutionResource
#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"uri", @"format", @"width", @"height"]];
        [mapping mapPropertiesFromDictionary:@{
                                               @"id": @"identifier"
                                               }];
        
        [mapping mapKeyPath:@"parameters" toProperty:@"parameters" withValueBlock:^id(NSString *key, id value) {
            NSArray *arrayOfRepresenations = value[[JSDashboardParameter requestObjectKeyPath]];
            NSArray *parameters = [EKMapper arrayOfObjectsFromExternalRepresentation:arrayOfRepresenations withMapping:[JSDashboardParameter objectMappingForServerProfile:serverProfile]];
            return parameters;
        } reverseBlock:^id(id value) {
            NSArray *parametersArray = [EKSerializer serializeCollection:value withMapping:[JSDashboardParameter objectMappingForServerProfile:serverProfile]];
            return @{[JSDashboardParameter requestObjectKeyPath] : parametersArray};
        }];
    }];
}

@end
