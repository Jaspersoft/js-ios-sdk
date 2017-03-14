/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSScheduleLookup.h"
#import "JSScheduleJobState.h"


@implementation JSScheduleLookup

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"id"                          : @"jobIdentifier",
                                               @"version"                     : @"version",
                                               @"reportUnitURI"               : @"reportUnitURI",
                                               @"label"                       : @"label",
                                               @"description"                 : @"scheduleDescription",
                                               @"owner"                       : @"owner",
                                               @"reportLabel"                 : @"reportLabel",
                                               }];
        [mapping hasOne:[JSScheduleJobState class] forKeyPath:@"state" forProperty:@"state" withObjectMapping:[JSScheduleJobState objectMappingForServerProfile:serverProfile]];
    }];
}

@end
