/*
 * TIBCO JasperMobile for iOS
 * Copyright © 2005-2016 TIBCO Software, Inc. All rights reserved.
 * http://community.jaspersoft.com/project/jaspermobile-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/lgpl>.
 */


//
//  JSScheduleJob.m
//  TIBCO JasperMobile
//

#import "JSScheduleMetadata.h"
#import "JSScheduleTrigger.h"

@implementation JSScheduleMetadata

#pragma mark - Custom Accessors
- (JSScheduleTrigger *)trigger
{
    if (!_trigger) {
        _trigger = [self simpleTrigger];
    }
    return _trigger;
}

- (NSString *)outputTimeZone
{
    if (!_outputTimeZone) {
        _outputTimeZone = @"Europe/Helsinki";
    }
    return _outputTimeZone;
}

#pragma mark - Helpers
- (JSScheduleTrigger *)simpleTrigger
{
    JSScheduleTrigger *simpleTrigger = [JSScheduleTrigger new];
    simpleTrigger.timezone = self.outputTimeZone;
    simpleTrigger.startType = 2;
    simpleTrigger.occurrenceCount = 1;
    simpleTrigger.startDate = [NSDate date];
    return simpleTrigger;
}

+ (nonnull NSString *)resourceRootKeyPath
{
    return @"scheduleMetadata";
}

+ (nonnull NSArray <RKRequestDescriptor *> *)rkRequestDescriptorsForServerProfile:(nonnull JSProfile *)serverProfile {
    NSMutableArray *descriptorsArray = [NSMutableArray array];
    [descriptorsArray addObject:[RKRequestDescriptor requestDescriptorWithMapping:[[self classMappingForServerProfile:serverProfile] inverseMapping]
                                                                      objectClass:self
                                                                      rootKeyPath:nil
                                                                           method:RKRequestMethodAny]];
    return descriptorsArray;
}

#pragma mark - JSSerializationDescriptorHolder
+ (nonnull NSArray <RKResponseDescriptor *> *)rkResponseDescriptorsForServerProfile:(nonnull JSProfile *)serverProfile {
    NSMutableArray *descriptorsArray = [NSMutableArray array];
    for (NSString *keyPath in [self classMappingPathes]) {
        [descriptorsArray addObject:[RKResponseDescriptor responseDescriptorWithMapping:[self classMappingForServerProfile:serverProfile]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:nil
                                                                                keyPath:keyPath
                                                                            statusCodes:nil]];
    }
    return descriptorsArray;
}

+ (nonnull RKObjectMapping *)classMappingForServerProfile:(nonnull JSProfile *)serverProfile
{
    RKObjectMapping *classMapping = [RKObjectMapping mappingForClass:self];
    [classMapping addAttributeMappingsFromDictionary:@{
            @"id"                              : @"jobIdentifier",
            @"version"                         : @"version",
            @"username"                        : @"username",
            @"label"                           : @"label",               // request
            @"description"                     : @"scheduleDescription", // request
            @"creationDate"                    : @"creationDate",
            // trigger
            @"source.reportUnitURI"            : @"reportUnitURI",       // request
            // may be source parameters
            @"baseOutputFilename"              : @"baseOutputFilename",  // request
            @"outputLocale"                    : @"outputLocale",
            @"mailNotification"                : @"mailNotification",
            @"alert"                           : @"alert",
            @"outputTimeZone"                  : @"outputTimeZone",      // request
            @"repositoryDestination.folderURI" : @"folderURI",           // request
            @"outputFormats.outputFormat"      : @"outputFormats",       // request
    }];

    [classMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"trigger.simpleTrigger"
                                                                                 toKeyPath:@"trigger"
                                                                               withMapping:[JSScheduleTrigger classMappingForServerProfile:serverProfile]]];


    return classMapping;
}

+ (nonnull NSArray *)classMappingPathes {
    return @[[self resourceRootKeyPath], @""];
}

@end