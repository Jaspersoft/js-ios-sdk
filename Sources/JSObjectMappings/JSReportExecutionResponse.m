/*
 * Copyright © 2013 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSReportExecutionResponse.h"
#import "EKMapper.h"

@implementation JSReportExecutionResponse

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"totalPages": @"totalPages",
                                               @"currentPage": @"currentPage",
                                               @"reportURI": @"reportURI",
                                               @"requestId": @"requestId",
                                               }];
        [mapping hasOne:[JSErrorDescriptor class] forKeyPath:@"errorDescriptor" forProperty:@"errorDescriptor" withObjectMapping:[JSErrorDescriptor objectMappingForServerProfile:serverProfile]];
        [mapping mapKeyPath:@"status" toProperty:@"status" withValueBlock:^id(NSString *key, id value) {
            NSDictionary *statusDictionary = @{@"value" : value};
            return [EKMapper objectFromExternalRepresentation:statusDictionary withMapping:[JSExecutionStatus objectMappingForServerProfile:serverProfile]];
        }];
        [mapping hasMany:[JSExportExecutionResponse class] forKeyPath:@"exports" forProperty:@"exports" withObjectMapping:[JSExportExecutionResponse objectMappingForServerProfile:serverProfile]];
    }];
}

@end
