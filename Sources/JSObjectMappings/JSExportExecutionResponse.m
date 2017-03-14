/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSExportExecutionResponse.h"
#import "EKMapper.h"

@implementation JSExportExecutionResponse

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"id": @"uuid",
                                               }];
        [mapping mapKeyPath:@"status" toProperty:@"status" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *statusDictionary = @{@"value" : value};
            return [EKMapper objectFromExternalRepresentation:statusDictionary withMapping:[JSExecutionStatus objectMappingForServerProfile:serverProfile]];
        }];
        [mapping hasOne:[JSErrorDescriptor class] forKeyPath:@"errorDescriptor" forProperty:@"errorDescriptor" withObjectMapping:[JSErrorDescriptor objectMappingForServerProfile:serverProfile]];
        [mapping hasOne:[JSReportOutputResource class] forKeyPath:@"outputResource" forProperty:@"outputResource" withObjectMapping:[JSReportOutputResource objectMappingForServerProfile:serverProfile]];
        [mapping hasMany:[JSReportOutputResource class] forKeyPath:@"attachments" forProperty:@"attachments" withObjectMapping:[JSReportOutputResource objectMappingForServerProfile:serverProfile]];
    }];
}

@end
