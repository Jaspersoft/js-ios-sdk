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
#import "JSDateFormatterFactory.h"

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

        // Date mapping
        id(^valueBlock)(NSString *key, id value) = ^id(NSString *key, id value) {
            if (value == nil)
                return [NSNull null];

            if (![value isKindOfClass:[NSString class]]) {
                return [NSNull null];
            }

            NSDateFormatter *formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
            NSDate *date = [formatter dateFromString:value];
            if (!date) {
                formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd'T'HH:mm:ssZ"];
                date = [formatter dateFromString:value];
            }
            return date;
        };

        id(^reverseBlock)(id value) = ^id(id value) {
            if (value == nil)
                return [NSNull null];

            if (![value isKindOfClass:[NSDate class]]) {
                return [NSNull null];
            }

            NSDateFormatter *formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
            NSString *string = [formatter stringFromDate:value];
            return string;
        };

        [mapping mapKeyPath:@"creationDate"
                 toProperty:@"creationDate"
             withValueBlock:valueBlock
               reverseBlock:reverseBlock];

        // Trigger mapping
        [mapping mapKeyPath:@"trigger"
                 toProperty:@"trigger"
             withValueBlock:^id(NSString *key, id value) {
                 if (value == nil)
                     return nil;

                 if (![value isKindOfClass:[NSDictionary class]]) {
                     return [NSNull null];
                 }

                 if (value[@"simpleTrigger"]) {
                     JSScheduleSimpleTrigger *trigger = [EKMapper objectFromExternalRepresentation:value[@"simpleTrigger"]
                                                                                       withMapping:[JSScheduleSimpleTrigger objectMappingForServerProfile:serverProfile]];
                     return @{
                             @(JSScheduleTriggerTypeSimple) : trigger
                     };
                 } else if (value[@"calendarTrigger"]) {
                     JSScheduleCalendarTrigger *trigger = [EKMapper objectFromExternalRepresentation:value[@"calendarTrigger"]
                                                                                         withMapping:[JSScheduleCalendarTrigger objectMappingForServerProfile:serverProfile]];
                     return @{
                             @(JSScheduleTriggerTypeCalendar) : trigger
                     };
                 } else {
                     return [NSNull null];
                 }
             } reverseBlock:^id(id value) {
                    if (value == nil)
                        return [NSNull null];

                    if (![value isKindOfClass:[NSDictionary class]]) {
                        return [NSNull null];
                    }

                    NSDictionary *trigger = value;
                    if (trigger[@(JSScheduleTriggerTypeSimple)]) {
                        NSDictionary *represenatation = [EKSerializer serializeObject:trigger[@(JSScheduleTriggerTypeSimple)]
                                                                          withMapping:[JSScheduleSimpleTrigger objectMappingForServerProfile:serverProfile]];
                        return @{
                                @"simpleTrigger" : represenatation
                        };
                    } else if (trigger[@(JSScheduleTriggerTypeCalendar)]) {
                        NSDictionary *represenatation = [EKSerializer serializeObject:trigger[@(JSScheduleTriggerTypeCalendar)]
                                                                          withMapping:[JSScheduleCalendarTrigger objectMappingForServerProfile:serverProfile]];
                        return @{
                                @"calendarTrigger" : represenatation
                        };
                    } else {
                        return [NSNull null];
                    }
                }];
    }];
}

@end