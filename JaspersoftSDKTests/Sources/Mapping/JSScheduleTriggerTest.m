/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSScheduleTrigger.h"
#import "JSDateFormatterFactory.h"

@interface JSScheduleTriggerTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation JSScheduleTriggerTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSScheduleTrigger class]];
    self.mapping = [JSScheduleTrigger objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    self.formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd HH:mm"];

}

- (void)testObjectMapping {
    JSScheduleTrigger *expectedObject = [JSScheduleTrigger new];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    expectedObject.startDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"startDate"]];
    expectedObject.endDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"endDate"]];

    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectMappingWithNilDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject removeObjectForKey:@"startDate"];
    [mutJsonObject removeObjectForKey:@"endDate"];
    
    JSScheduleTrigger *expectedObject = [JSScheduleTrigger new];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    expectedObject.startDate = [self.formatter dateFromString:[mutJsonObject valueForKey:@"startDate"]];
    expectedObject.endDate = [self.formatter dateFromString:[mutJsonObject valueForKey:@"endDate"]];
    
    [self testObjectFromExternalRepresentation:mutJsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectMappingWithNSNullDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject setObject:[NSNull null] forKey:@"startDate"];
    [mutJsonObject setObject:[NSNull null] forKey:@"endDate"];
    
    JSScheduleTrigger *expectedObject = [JSScheduleTrigger new];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    [self testObjectFromExternalRepresentation:mutJsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectMappingWithNotSupportedDateFormats {
    NSDateFormatter *formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd"];
    
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject setObject:[formatter stringFromDate:[NSDate date]] forKey:@"startDate"];
    [mutJsonObject setObject:[formatter stringFromDate:[NSDate date]] forKey:@"endDate"];
    
    JSScheduleTrigger *expectedObject = [JSScheduleTrigger new];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    [self testObjectFromExternalRepresentation:mutJsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectSerialization {
    JSScheduleTrigger *expectedObject = [JSScheduleTrigger new];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    
    
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    expectedObject.startDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"startDate"]];
    expectedObject.endDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"endDate"]];

    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject];
}

- (void)testObjectSerializationWithNilDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject removeObjectForKey:@"startDate"];
    [mutJsonObject removeObjectForKey:@"endDate"];
    
    JSScheduleTrigger *expectedObject = [JSScheduleTrigger new];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    expectedObject.startDate = [self.formatter dateFromString:[mutJsonObject valueForKey:@"startDate"]];
    expectedObject.endDate = [self.formatter dateFromString:[mutJsonObject valueForKey:@"endDate"]];
    
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:mutJsonObject];
}

- (void)testObjectSerializationWithNSNullDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject setObject:[NSNull null] forKey:@"startDate"];
    [mutJsonObject setObject:[NSNull null] forKey:@"endDate"];
    

    JSScheduleTrigger *expectedObject = [JSScheduleTrigger new];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    id someValue = [NSNull null];
    expectedObject.startDate = someValue;
    expectedObject.endDate = someValue;
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:mutJsonObject];
}

@end


@interface JSScheduleSimpleTriggerTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation JSScheduleSimpleTriggerTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSScheduleSimpleTrigger class]];
    self.mapping = [JSScheduleSimpleTrigger objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    self.formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd HH:mm"];
}

- (void)testObjectMapping {
    JSScheduleSimpleTrigger *expectedObject = [JSScheduleSimpleTrigger new];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    expectedObject.startDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"startDate"]];
    expectedObject.endDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"endDate"]];
    expectedObject.occurrenceCount = [self.jsonObject valueForKey:@"occurrenceCount"];
    expectedObject.recurrenceInterval = [self.jsonObject valueForKey:@"recurrenceInterval"];

    NSDictionary *recurrenceIntervalUnits = @{
                                              @"MINUTE": @(JSScheduleSimpleTriggerRecurrenceIntervalTypeMinute),
                                              @"HOUR"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeHour),
                                              @"DAY"   : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeDay),
                                              @"WEEK"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeWeek)
                                              };

    expectedObject.recurrenceIntervalUnit = [[recurrenceIntervalUnits objectForKey:[self.jsonObject valueForKey:@"recurrenceIntervalUnit"]] integerValue];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectMappingWithNilDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject removeObjectForKey:@"startDate"];
    [mutJsonObject removeObjectForKey:@"endDate"];
    
    JSScheduleSimpleTrigger *expectedObject = [JSScheduleSimpleTrigger new];
    expectedObject.occurrenceCount = [self.jsonObject valueForKey:@"occurrenceCount"];
    expectedObject.recurrenceInterval = [self.jsonObject valueForKey:@"recurrenceInterval"];
    
    NSDictionary *recurrenceIntervalUnits = @{
                                              @"MINUTE": @(JSScheduleSimpleTriggerRecurrenceIntervalTypeMinute),
                                              @"HOUR"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeHour),
                                              @"DAY"   : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeDay),
                                              @"WEEK"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeWeek)
                                              };
    
    expectedObject.recurrenceIntervalUnit = [[recurrenceIntervalUnits objectForKey:[self.jsonObject valueForKey:@"recurrenceIntervalUnit"]] integerValue];

    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    expectedObject.startDate = [self.formatter dateFromString:[mutJsonObject valueForKey:@"startDate"]];
    expectedObject.endDate = [self.formatter dateFromString:[mutJsonObject valueForKey:@"endDate"]];
    
    [self testObjectFromExternalRepresentation:mutJsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectMappingWithNSNullDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject setObject:[NSNull null] forKey:@"startDate"];
    [mutJsonObject setObject:[NSNull null] forKey:@"endDate"];
    
    JSScheduleSimpleTrigger *expectedObject = [JSScheduleSimpleTrigger new];
    expectedObject.occurrenceCount = [self.jsonObject valueForKey:@"occurrenceCount"];
    expectedObject.recurrenceInterval = [self.jsonObject valueForKey:@"recurrenceInterval"];
    
    NSDictionary *recurrenceIntervalUnits = @{
                                              @"MINUTE": @(JSScheduleSimpleTriggerRecurrenceIntervalTypeMinute),
                                              @"HOUR"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeHour),
                                              @"DAY"   : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeDay),
                                              @"WEEK"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeWeek)
                                              };
    
    expectedObject.recurrenceIntervalUnit = [[recurrenceIntervalUnits objectForKey:[self.jsonObject valueForKey:@"recurrenceIntervalUnit"]] integerValue];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    [self testObjectFromExternalRepresentation:mutJsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectMappingWithNotSupportedDateFormats {
    NSDateFormatter *formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd"];
    
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject setObject:[formatter stringFromDate:[NSDate date]] forKey:@"startDate"];
    [mutJsonObject setObject:[formatter stringFromDate:[NSDate date]] forKey:@"endDate"];
    
    JSScheduleSimpleTrigger *expectedObject = [JSScheduleSimpleTrigger new];
    expectedObject.occurrenceCount = [self.jsonObject valueForKey:@"occurrenceCount"];
    expectedObject.recurrenceInterval = [self.jsonObject valueForKey:@"recurrenceInterval"];
    
    NSDictionary *recurrenceIntervalUnits = @{
                                              @"MINUTE": @(JSScheduleSimpleTriggerRecurrenceIntervalTypeMinute),
                                              @"HOUR"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeHour),
                                              @"DAY"   : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeDay),
                                              @"WEEK"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeWeek)
                                              };
    
    expectedObject.recurrenceIntervalUnit = [[recurrenceIntervalUnits objectForKey:[self.jsonObject valueForKey:@"recurrenceIntervalUnit"]] integerValue];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    [self testObjectFromExternalRepresentation:mutJsonObject withMapping:self.mapping expectedObject:expectedObject];
}


- (void)testObjectSerialization {
    JSScheduleSimpleTrigger *expectedObject = [JSScheduleSimpleTrigger new];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    
    
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    expectedObject.startDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"startDate"]];
    expectedObject.endDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"endDate"]];
    expectedObject.occurrenceCount = [self.jsonObject valueForKey:@"occurrenceCount"];
    expectedObject.recurrenceInterval = [self.jsonObject valueForKey:@"recurrenceInterval"];
    
    NSDictionary *recurrenceIntervalUnits = @{
                                              @"MINUTE": @(JSScheduleSimpleTriggerRecurrenceIntervalTypeMinute),
                                              @"HOUR"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeHour),
                                              @"DAY"   : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeDay),
                                              @"WEEK"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeWeek)
                                              };
    
    expectedObject.recurrenceIntervalUnit = [[recurrenceIntervalUnits objectForKey:[self.jsonObject valueForKey:@"recurrenceIntervalUnit"]] integerValue];
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject];
}

- (void)testObjectSerializationWithNilDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject removeObjectForKey:@"startDate"];
    [mutJsonObject removeObjectForKey:@"endDate"];
    
    JSScheduleSimpleTrigger *expectedObject = [JSScheduleSimpleTrigger new];
    expectedObject.occurrenceCount = [self.jsonObject valueForKey:@"occurrenceCount"];
    expectedObject.recurrenceInterval = [self.jsonObject valueForKey:@"recurrenceInterval"];
    
    NSDictionary *recurrenceIntervalUnits = @{
                                              @"MINUTE": @(JSScheduleSimpleTriggerRecurrenceIntervalTypeMinute),
                                              @"HOUR"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeHour),
                                              @"DAY"   : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeDay),
                                              @"WEEK"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeWeek)
                                              };
    
    expectedObject.recurrenceIntervalUnit = [[recurrenceIntervalUnits objectForKey:[self.jsonObject valueForKey:@"recurrenceIntervalUnit"]] integerValue];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    expectedObject.startDate = [self.formatter dateFromString:[mutJsonObject valueForKey:@"startDate"]];
    expectedObject.endDate = [self.formatter dateFromString:[mutJsonObject valueForKey:@"endDate"]];
    
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:mutJsonObject];
}

- (void)testObjectSerializationWithNSNullDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject setObject:[NSNull null] forKey:@"startDate"];
    [mutJsonObject setObject:[NSNull null] forKey:@"endDate"];
    
    
    JSScheduleSimpleTrigger *expectedObject = [JSScheduleSimpleTrigger new];
    expectedObject.occurrenceCount = [self.jsonObject valueForKey:@"occurrenceCount"];
    expectedObject.recurrenceInterval = [self.jsonObject valueForKey:@"recurrenceInterval"];
    
    NSDictionary *recurrenceIntervalUnits = @{
                                              @"MINUTE": @(JSScheduleSimpleTriggerRecurrenceIntervalTypeMinute),
                                              @"HOUR"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeHour),
                                              @"DAY"   : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeDay),
                                              @"WEEK"  : @(JSScheduleSimpleTriggerRecurrenceIntervalTypeWeek)
                                              };
    
    expectedObject.recurrenceIntervalUnit = [[recurrenceIntervalUnits objectForKey:[self.jsonObject valueForKey:@"recurrenceIntervalUnit"]] integerValue];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    id someValue = [NSNull null];
    expectedObject.startDate = someValue;
    expectedObject.endDate = someValue;
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:mutJsonObject];
}

@end

@interface JSScheduleCalendarTriggerTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation JSScheduleCalendarTriggerTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSScheduleCalendarTrigger class]];
    self.mapping = [JSScheduleCalendarTrigger objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    self.formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd HH:mm"];
}

- (void)testObjectMapping {
    JSScheduleCalendarTrigger *expectedObject = [JSScheduleCalendarTrigger new];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    
    
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    expectedObject.startDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"startDate"]];
    expectedObject.endDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"endDate"]];
    expectedObject.minutes = [self.jsonObject valueForKey:@"minutes"];
    expectedObject.hours = [self.jsonObject valueForKey:@"hours"];
    expectedObject.monthDays = [self.jsonObject valueForKey:@"monthDays"];

    NSDictionary *calendarTriggerDaysTypes = @{
                                               @"ALL"   : @(JSScheduleCalendarTriggerDaysTypeAll),
                                               @"WEEK"  : @(JSScheduleCalendarTriggerDaysTypeWeek),
                                               @"MONTH" : @(JSScheduleCalendarTriggerDaysTypeMonth)
                                               };
    
    expectedObject.daysType = [[calendarTriggerDaysTypes objectForKey:[self.jsonObject valueForKey:@"daysType"]] integerValue];
    
    NSArray *weekDays = [self.jsonObject valueForKeyPath:@"weekDays.day"];
    if (weekDays.count) {
        expectedObject.weekDays = weekDays;
    }

    NSArray *months = [self.jsonObject valueForKeyPath:@"months.month"];
    if (months.count) {
        expectedObject.months = months;
    }
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectMappingWithNilDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject removeObjectForKey:@"startDate"];
    [mutJsonObject removeObjectForKey:@"endDate"];
    
    JSScheduleCalendarTrigger *expectedObject = [JSScheduleCalendarTrigger new];
    expectedObject.minutes = [self.jsonObject valueForKey:@"minutes"];
    expectedObject.hours = [self.jsonObject valueForKey:@"hours"];
    expectedObject.monthDays = [self.jsonObject valueForKey:@"monthDays"];
    
    NSDictionary *calendarTriggerDaysTypes = @{
                                               @"ALL"   : @(JSScheduleCalendarTriggerDaysTypeAll),
                                               @"WEEK"  : @(JSScheduleCalendarTriggerDaysTypeWeek),
                                               @"MONTH" : @(JSScheduleCalendarTriggerDaysTypeMonth)
                                               };
    
    expectedObject.daysType = [[calendarTriggerDaysTypes objectForKey:[self.jsonObject valueForKey:@"daysType"]] integerValue];
    
    NSArray *weekDays = [self.jsonObject valueForKeyPath:@"weekDays.day"];
    if (weekDays.count) {
        expectedObject.weekDays = weekDays;
    }
    
    NSArray *months = [self.jsonObject valueForKeyPath:@"months.month"];
    if (months.count) {
        expectedObject.months = months;
    }
    
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    expectedObject.startDate = [self.formatter dateFromString:[mutJsonObject valueForKey:@"startDate"]];
    expectedObject.endDate = [self.formatter dateFromString:[mutJsonObject valueForKey:@"endDate"]];
    
    [self testObjectFromExternalRepresentation:mutJsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectMappingWithNSNullDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject setObject:[NSNull null] forKey:@"startDate"];
    [mutJsonObject setObject:[NSNull null] forKey:@"endDate"];
    
    JSScheduleCalendarTrigger *expectedObject = [JSScheduleCalendarTrigger new];
    expectedObject.minutes = [self.jsonObject valueForKey:@"minutes"];
    expectedObject.hours = [self.jsonObject valueForKey:@"hours"];
    expectedObject.monthDays = [self.jsonObject valueForKey:@"monthDays"];
    
    NSDictionary *calendarTriggerDaysTypes = @{
                                               @"ALL"   : @(JSScheduleCalendarTriggerDaysTypeAll),
                                               @"WEEK"  : @(JSScheduleCalendarTriggerDaysTypeWeek),
                                               @"MONTH" : @(JSScheduleCalendarTriggerDaysTypeMonth)
                                               };
    
    expectedObject.daysType = [[calendarTriggerDaysTypes objectForKey:[self.jsonObject valueForKey:@"daysType"]] integerValue];
    
    NSArray *weekDays = [self.jsonObject valueForKeyPath:@"weekDays.day"];
    if (weekDays.count) {
        expectedObject.weekDays = weekDays;
    }
    
    NSArray *months = [self.jsonObject valueForKeyPath:@"months.month"];
    if (months.count) {
        expectedObject.months = months;
    }
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    [self testObjectFromExternalRepresentation:mutJsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectMappingWithNotSupportedDateFormats {
    NSDateFormatter *formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd"];
    
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject setObject:[formatter stringFromDate:[NSDate date]] forKey:@"startDate"];
    [mutJsonObject setObject:[formatter stringFromDate:[NSDate date]] forKey:@"endDate"];
    
    JSScheduleCalendarTrigger *expectedObject = [JSScheduleCalendarTrigger new];
    expectedObject.minutes = [self.jsonObject valueForKey:@"minutes"];
    expectedObject.hours = [self.jsonObject valueForKey:@"hours"];
    expectedObject.monthDays = [self.jsonObject valueForKey:@"monthDays"];
    
    NSDictionary *calendarTriggerDaysTypes = @{
                                               @"ALL"   : @(JSScheduleCalendarTriggerDaysTypeAll),
                                               @"WEEK"  : @(JSScheduleCalendarTriggerDaysTypeWeek),
                                               @"MONTH" : @(JSScheduleCalendarTriggerDaysTypeMonth)
                                               };
    
    expectedObject.daysType = [[calendarTriggerDaysTypes objectForKey:[self.jsonObject valueForKey:@"daysType"]] integerValue];
    
    NSArray *weekDays = [self.jsonObject valueForKeyPath:@"weekDays.day"];
    if (weekDays.count) {
        expectedObject.weekDays = weekDays;
    }
    
    NSArray *months = [self.jsonObject valueForKeyPath:@"months.month"];
    if (months.count) {
        expectedObject.months = months;
    }
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    [self testObjectFromExternalRepresentation:mutJsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectSerialization {
    JSScheduleCalendarTrigger *expectedObject = [JSScheduleCalendarTrigger new];
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    
    
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    expectedObject.startDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"startDate"]];
    expectedObject.endDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"endDate"]];
    expectedObject.minutes = [self.jsonObject valueForKey:@"minutes"];
    expectedObject.hours = [self.jsonObject valueForKey:@"hours"];
    expectedObject.monthDays = [self.jsonObject valueForKey:@"monthDays"];
    
    NSDictionary *calendarTriggerDaysTypes = @{
                                               @"ALL"   : @(JSScheduleCalendarTriggerDaysTypeAll),
                                               @"WEEK"  : @(JSScheduleCalendarTriggerDaysTypeWeek),
                                               @"MONTH" : @(JSScheduleCalendarTriggerDaysTypeMonth)
                                               };
    
    expectedObject.daysType = [[calendarTriggerDaysTypes objectForKey:[self.jsonObject valueForKey:@"daysType"]] integerValue];
    
    NSArray *weekDays = [self.jsonObject valueForKeyPath:@"weekDays.day"];
    if (weekDays.count) {
        expectedObject.weekDays = weekDays;
    }
    
    NSArray *months = [self.jsonObject valueForKeyPath:@"months.month"];
    if (months.count) {
        expectedObject.months = months;
    }
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject];
}

- (void)testObjectSerializationWithNilDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject removeObjectForKey:@"startDate"];
    [mutJsonObject removeObjectForKey:@"endDate"];
    
    JSScheduleCalendarTrigger *expectedObject = [JSScheduleCalendarTrigger new];
    expectedObject.minutes = [self.jsonObject valueForKey:@"minutes"];
    expectedObject.hours = [self.jsonObject valueForKey:@"hours"];
    expectedObject.monthDays = [self.jsonObject valueForKey:@"monthDays"];
    
    NSDictionary *calendarTriggerDaysTypes = @{
                                               @"ALL"   : @(JSScheduleCalendarTriggerDaysTypeAll),
                                               @"WEEK"  : @(JSScheduleCalendarTriggerDaysTypeWeek),
                                               @"MONTH" : @(JSScheduleCalendarTriggerDaysTypeMonth)
                                               };
    
    expectedObject.daysType = [[calendarTriggerDaysTypes objectForKey:[self.jsonObject valueForKey:@"daysType"]] integerValue];
    
    NSArray *weekDays = [self.jsonObject valueForKeyPath:@"weekDays.day"];
    if (weekDays.count) {
        expectedObject.weekDays = weekDays;
    }
    
    NSArray *months = [self.jsonObject valueForKeyPath:@"months.month"];
    if (months.count) {
        expectedObject.months = months;
    }
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    expectedObject.startDate = [self.formatter dateFromString:[mutJsonObject valueForKey:@"startDate"]];
    expectedObject.endDate = [self.formatter dateFromString:[mutJsonObject valueForKey:@"endDate"]];
    
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:mutJsonObject];
}

- (void)testObjectSerializationWithNSNullDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject setObject:[NSNull null] forKey:@"startDate"];
    [mutJsonObject setObject:[NSNull null] forKey:@"endDate"];
    
    
    JSScheduleCalendarTrigger *expectedObject = [JSScheduleCalendarTrigger new];
    expectedObject.minutes = [self.jsonObject valueForKey:@"minutes"];
    expectedObject.hours = [self.jsonObject valueForKey:@"hours"];
    expectedObject.monthDays = [self.jsonObject valueForKey:@"monthDays"];
    
    NSDictionary *calendarTriggerDaysTypes = @{
                                               @"ALL"   : @(JSScheduleCalendarTriggerDaysTypeAll),
                                               @"WEEK"  : @(JSScheduleCalendarTriggerDaysTypeWeek),
                                               @"MONTH" : @(JSScheduleCalendarTriggerDaysTypeMonth)
                                               };
    
    expectedObject.daysType = [[calendarTriggerDaysTypes objectForKey:[self.jsonObject valueForKey:@"daysType"]] integerValue];
    
    NSArray *weekDays = [self.jsonObject valueForKeyPath:@"weekDays.day"];
    if (weekDays.count) {
        expectedObject.weekDays = weekDays;
    }
    
    NSArray *months = [self.jsonObject valueForKeyPath:@"months.month"];
    if (months.count) {
        expectedObject.months = months;
    }
    expectedObject.triggerIdentifier = [self.jsonObject valueForKey:@"id"];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    expectedObject.timezone = [self.jsonObject valueForKey:@"timezone"];
    expectedObject.misfireInstruction = [self.jsonObject valueForKey:@"misfireInstruction"];
    
    NSDictionary *startTypes = @{
                                 @(1): @(JSScheduleTriggerStartTypeImmediately),
                                 @(2): @(JSScheduleTriggerStartTypeAtDate)
                                 };
    expectedObject.startType = [[startTypes objectForKey:[self.jsonObject valueForKey:@"startType"]] integerValue];
    
    id someValue = [NSNull null];
    expectedObject.startDate = someValue;
    expectedObject.endDate = someValue;
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:mutJsonObject];
}

@end
