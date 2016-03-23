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
#import "EKMapper.h"
#import "EKSerializer.h"

@implementation JSScheduleMetadata

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
        [mapping mapKeyPath:@"creationDate"
                 toProperty:@"creationDate"
          withDateFormatter:[serverProfile.serverInfo serverDateFormatFormatter]];

        [mapping mapKeyPath:@"trigger"
                 toProperty:@"trigger"
             withValueBlock:^id(NSString *key, id value) {
                 if (value == nil)
                     return nil;

                 if (![value isKindOfClass:[NSDictionary class]]) {
                     return [NSNull null];
                 }

                 if (value[@"simpleTrigger"]) {
                     JSScheduleSimpleTrigger *trigger = [EKMapper objectFromExternalRepresentation:value
                                                                                       withMapping:[JSScheduleSimpleTrigger objectMappingForServerProfile:serverProfile]];
                     return @{
                             @(JSScheduleTriggerTypeSimple) : trigger
                     };
                 } else if (value[@"calendarTrigger"]) {
                     JSScheduleCalendarTrigger *trigger = [EKMapper objectFromExternalRepresentation:value
                                                                                         withMapping:[JSScheduleCalendarTrigger objectMappingForServerProfile:serverProfile]];
                     return @{
                             @(JSScheduleTriggerTypeCalendar) : trigger
                     };
                 } else {
                     return [NSNull null];
                 }
             } reverseBlock:^id(id value) {
                    if (value == nil)
                        return nil;

                    if (![value isKindOfClass:[NSDictionary class]]) {
                        return [NSNull null];
                    }

                    NSDictionary *trigger = value;
                    if (trigger[@(JSScheduleTriggerTypeSimple)]) {
                        NSDictionary *represenatation = [EKSerializer serializeObject:value
                                                                          withMapping:[JSScheduleSimpleTrigger objectMappingForServerProfile:serverProfile]];
                    } else if (trigger[@(JSScheduleTriggerTypeCalendar)]) {
                        NSDictionary *represenatation = [EKSerializer serializeObject:value
                                                                          withMapping:[JSScheduleCalendarTrigger objectMappingForServerProfile:serverProfile]];
                    } else {
                        return [NSNull null];
                    }
                }];

    }];
}

@end