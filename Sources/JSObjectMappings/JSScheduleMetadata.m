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
#import "JSServerInfo.h"

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
    simpleTrigger.startType = JSScheduleTriggerStartTypeAtDate;
    simpleTrigger.occurrenceCount = 1;
    simpleTrigger.startDate = [NSDate date];
    return simpleTrigger;
}

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"id"                              : @"jobIdentifier",
                                               @"version"                         : @"version",
                                               @"username"                        : @"username",
                                               @"label"                           : @"label",               // request
                                               @"description"                     : @"scheduleDescription", // request
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
        [mapping mapKeyPath:@"creationDate" toProperty:@"creationDate" withDateFormatter:[serverProfile.serverInfo serverDateFormatFormatter]];
        [mapping hasOne:[JSScheduleTrigger class] forKeyPath:@"trigger.simpleTrigger" forProperty:@"trigger" withObjectMapping:[JSScheduleTrigger objectMappingForServerProfile:serverProfile]];
    }];
}

+ (nonnull NSString *)requestObjectKeyPath {
    return @"scheduleMetadata";
}

@end