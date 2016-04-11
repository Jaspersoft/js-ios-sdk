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
//  JSScheduleTrigger.h
//  TIBCO JasperMobile
//

/**
@author Aleksandr Dakhno odahno@tibco.com
@since 2.3
*/


#import "JSObjectMappingsProtocol.h"

typedef NS_ENUM(NSInteger, JSScheduleTriggerStartType) {
    JSScheduleTriggerStartTypeImmediately = 1,
    JSScheduleTriggerStartTypeAtDate,
};

typedef NS_ENUM(NSInteger, JSScheduleTriggerType) {
    JSScheduleTriggerTypeNone,
    JSScheduleTriggerTypeSimple,
    JSScheduleTriggerTypeCalendar
};

@interface JSScheduleTrigger : NSObject <JSObjectMappingsProtocol>
@property (nonatomic, strong) NSNumber *triggerIdentifier;
@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSString *timezone;
@property (nonatomic, strong) NSString *calendarName;
@property (nonatomic, strong) NSString *timestampPattern;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) JSScheduleTriggerStartType startType;
@property (nonatomic, assign) JSScheduleTriggerType type;
@property (nonatomic, strong) NSNumber *misfireInstruction;
@end


typedef NS_ENUM(NSInteger, JSScheduleSimpleTriggerRecurrenceIntervalType) {
    JSScheduleSimpleTriggerRecurrenceIntervalTypeNone,
    JSScheduleSimpleTriggerRecurrenceIntervalTypeMinute,
    JSScheduleSimpleTriggerRecurrenceIntervalTypeHour,
    JSScheduleSimpleTriggerRecurrenceIntervalTypeDay,
    JSScheduleSimpleTriggerRecurrenceIntervalTypeWeek
};

@interface JSScheduleSimpleTrigger : JSScheduleTrigger
@property (nonatomic, strong) NSNumber *occurrenceCount;
@property (nonatomic, strong) NSNumber *recurrenceInterval;
@property (nonatomic, assign) JSScheduleSimpleTriggerRecurrenceIntervalType recurrenceIntervalUnit;
@end

typedef NS_ENUM(NSInteger, JSScheduleCalendarTriggerDaysType) {
    JSScheduleCalendarTriggerDaysTypeAll,
    JSScheduleCalendarTriggerDaysTypeWeek,
    JSScheduleCalendarTriggerDaysTypeMonth
};

@interface JSScheduleCalendarTrigger : JSScheduleTrigger
@property (nonatomic, strong) NSString *minutes;
@property (nonatomic, strong) NSString *hours;
@property (nonatomic, strong) NSString *monthDays;
@property (nonatomic, assign) JSScheduleCalendarTriggerDaysType daysType;
@property (nonatomic, strong) NSArray <NSNumber *>*weekDays;
@property (nonatomic, strong) NSArray <NSNumber *>*months;
@end