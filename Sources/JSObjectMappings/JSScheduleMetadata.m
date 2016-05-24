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
@dynamic reportUnitURI;
@dynamic folderURI;

- (NSString *)folderURI {
    return self.repositoryDestination[@"folderURI"];
}

- (void)setFolderURI:(NSString *)folderURI {
    NSMutableDictionary *mutableRepositoryDestination = [NSMutableDictionary dictionaryWithDictionary:self.repositoryDestination];
    mutableRepositoryDestination[@"folderURI"] = folderURI;
    self.repositoryDestination = mutableRepositoryDestination;
}

- (NSString *)reportUnitURI {
    return self.source[@"reportUnitURI"];
}

- (void)setReportUnitURI:(NSString *)reportUnitURI {
    NSMutableDictionary *mutableSource = [NSMutableDictionary dictionaryWithDictionary:self.source];
    mutableSource[@"reportUnitURI"] = reportUnitURI;
    self.source = mutableSource;
}

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"version", @"label", @"outputTimeZone", @"baseOutputFilename",
                                        @"username", @"outputLocale", @"alert", @"mailNotification",
                                          @"source", @"repositoryDestination",
                                               ]];

        
        [mapping mapPropertiesFromDictionary:@{
                @"id"                              : @"jobIdentifier",
                @"description"                     : @"scheduleDescription",
                @"outputFormats.outputFormat"      : @"outputFormats",
        }];

        
        
        // Date mapping
        id(^valueBlock)(NSString *key, id value) = ^id(NSString *key, id value) {
            if (value == nil)
                return [NSNull null];

            if (![value isKindOfClass:[NSString class]]) {
                return [NSNull null];
            }

            NSDateFormatter *formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
            NSDate *date = [formatter dateFromString:value];
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
                     id reccurenceInterval = value[@"simpleTrigger"][@"recurrenceInterval"];
                     id recurrenceIntervalUnit = value[@"simpleTrigger"][@"recurrenceIntervalUnit"];
                     if (!reccurenceInterval && !recurrenceIntervalUnit) {
                         trigger.type = JSScheduleTriggerTypeNone;
                     } else {
                         trigger.type = JSScheduleTriggerTypeSimple;
                     }
                     return trigger;
                 } else if (value[@"calendarTrigger"]) {
                     JSScheduleCalendarTrigger *trigger = [EKMapper objectFromExternalRepresentation:value[@"calendarTrigger"]
                                                                                         withMapping:[JSScheduleCalendarTrigger objectMappingForServerProfile:serverProfile]];
                     trigger.type = JSScheduleTriggerTypeCalendar;
                     return trigger;
                 }

                 return nil;
             } reverseBlock:^id(id value) {
                    if (value == nil)
                        return nil;

                    if (![value isKindOfClass:[JSScheduleTrigger class]]) {
                        return [NSNull null];
                    }

                    JSScheduleTrigger *trigger = value;
                    if (trigger.type == JSScheduleTriggerTypeSimple || trigger.type == JSScheduleTriggerTypeNone) {
                        NSDictionary *represenatation = [EKSerializer serializeObject:trigger
                                                                          withMapping:[JSScheduleSimpleTrigger objectMappingForServerProfile:serverProfile]];
                        return @{
                                @"simpleTrigger" : represenatation
                        };
                    } else if (trigger.type == JSScheduleTriggerTypeCalendar) {
                        NSDictionary *represenatation = [EKSerializer serializeObject:trigger
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