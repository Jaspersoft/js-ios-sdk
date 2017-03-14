/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
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
