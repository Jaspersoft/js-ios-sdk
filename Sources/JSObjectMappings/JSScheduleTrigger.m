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
//  JSScheduleTrigger.m
//  TIBCO JasperMobile
//


#import "JSScheduleTrigger.h"
#import "JSServerInfo.h"
#import "JSDateFormatterFactory.h"


@implementation JSScheduleTrigger

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {

        [mapping mapPropertiesFromDictionary:@{
                @"id"                 : @"triggerIdentifier",
                @"version"            : @"version",
                @"timezone"           : @"timezone",
                @"calendarName"       : @"calendarName",
                @"misfireInstruction" : @"misfireInstruction",
                @"timestampPattern"   : @"timestampPattern",
        }];

        // Start type
        NSDictionary *startTypes = @{
                @(1): @(JSScheduleTriggerStartTypeImmediately),
                @(2): @(JSScheduleTriggerStartTypeAtDate)
        };

        [mapping mapKeyPath:@"startType" toProperty:@"startType" withValueBlock:^(NSString *key, id value) {
            return startTypes[value];
        } reverseBlock:^id(id value) {
            return [startTypes allKeysForObject:value].lastObject;
        }];

        // Start date and End date
        id(^valueBlock)(NSString *key, id value) = ^id(NSString *key, id value) {
            if (value == nil)
                return nil;

            if (![value isKindOfClass:[NSString class]]) {
                return [NSNull null];
            }

            NSDateFormatter *formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd HH:mm"];
            NSDate *date = [formatter dateFromString:value];
            return date;
        };

        id(^reverseBlock)(id value) = ^id(id value) {
            if (value == nil)
                return nil;

            if (![value isKindOfClass:[NSDate class]]) {
                return [NSNull null];
            }

            NSDateFormatter *formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd HH:mm"];
            NSString *string = [formatter stringFromDate:value];
            return string;
        };

        [mapping mapKeyPath:@"startDate"
                 toProperty:@"startDate"
             withValueBlock:valueBlock
               reverseBlock:reverseBlock];

        [mapping mapKeyPath:@"endDate"
                 toProperty:@"endDate"
             withValueBlock:valueBlock
               reverseBlock:reverseBlock];
    }];
}

@end


@implementation JSScheduleSimpleTrigger

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    EKObjectMapping *mapping = [super objectMappingForServerProfile:serverProfile];

    [mapping mapPropertiesFromArray:@[
            @"occurrenceCount",
            @"recurrenceInterval",
    ]];

    // Recurrence interval type
    NSDictionary *recurrenceIntervalUnits = @{
            @"MINUTE": @(JSScheduleSimpleTriggerRecurrenceIntervalTypeMinute),
            @"HOUR"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeHour),
            @"DAY"   : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeDay),
            @"WEEK"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeWeek)
    };

    [mapping mapKeyPath:@"recurrenceIntervalUnit" toProperty:@"recurrenceIntervalUnit" withValueBlock:^(NSString *key, id value) {
        return recurrenceIntervalUnits[value];
    } reverseBlock:^id(id value) {
        if (!value) {
            return nil;
        }

        if (![value isKindOfClass:[NSNumber class]]) {
            return [NSNull null];
        }
        JSScheduleSimpleTriggerRecurrenceIntervalType recurrenceIntervalType = (JSScheduleSimpleTriggerRecurrenceIntervalType) ((NSNumber *)value).integerValue;
        if (recurrenceIntervalType == JSScheduleSimpleTriggerRecurrenceIntervalTypeNone) {
            return [NSNull null];
        } else {
            return [recurrenceIntervalUnits allKeysForObject:value].lastObject;
        }
    }];

    return mapping;
}

@end


@implementation JSScheduleCalendarTrigger

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    EKObjectMapping *mapping = [super objectMappingForServerProfile:serverProfile];

    [mapping mapPropertiesFromArray:@[
            @"minutes",
            @"hours",
            @"months",
    ]];

    // Calendar Days Type
    NSDictionary *calendarTriggerDaysTypes = @{
            @"ALL"   : @(JSScheduleCalendarTriggerDaysTypeAll),
            @"WEEK"  : @(JSScheduleCalendarTriggerDaysTypeWeek),
            @"MONTH" : @(JSScheduleCalendarTriggerDaysTypeMonth)
    };

    [mapping mapKeyPath:@"recurrenceIntervalUnit" toProperty:@"recurrenceIntervalUnit" withValueBlock:^(NSString *key, id value) {
        return calendarTriggerDaysTypes[value];
    } reverseBlock:^id(id value) {
        return [calendarTriggerDaysTypes allKeysForObject:value].lastObject;
    }];

    // TODO: add mapping for 'weekDays' and 'monthDays'

    return mapping;
}

@end