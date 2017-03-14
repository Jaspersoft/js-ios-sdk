/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSScheduleJobState.h"
#import "JSDateFormatterFactory.h"
#import "JSServerInfo.h"

@interface JSScheduleJobStateTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSScheduleJobStateTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSScheduleJobState class]];
    self.mapping = [JSScheduleJobState objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSServerInfo *serverInfo = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN].serverInfo;
    NSDateFormatter *formatter = serverInfo.serverDateFormatFormatter;

    JSScheduleJobState *expectedObject = [JSScheduleJobState new];
    expectedObject.value = [self.jsonObject valueForKey:@"value"];
    expectedObject.nextFireTime = [formatter dateFromString:[self.jsonObject valueForKey:@"nextFireTime"]];
    expectedObject.previousFireTime = [formatter dateFromString:[self.jsonObject valueForKey:@"previousFireTime"]];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectMappingWithNilDates {
    JSServerInfo *serverInfo = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN].serverInfo;
    NSDateFormatter *formatter = serverInfo.serverDateFormatFormatter;
    
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject removeObjectForKey:@"nextFireTime"];
    [mutJsonObject removeObjectForKey:@"previousFireTime"];
    
    JSScheduleJobState *expectedObject = [JSScheduleJobState new];
    expectedObject.value = [mutJsonObject valueForKey:@"value"];
    expectedObject.nextFireTime = [formatter dateFromString:[mutJsonObject valueForKey:@"nextFireTime"]];
    expectedObject.previousFireTime = [formatter dateFromString:[mutJsonObject valueForKey:@"previousFireTime"]];
    
    [self testObjectFromExternalRepresentation:mutJsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectMappingWithNSNullDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject setObject:[NSNull null] forKey:@"nextFireTime"];
    [mutJsonObject setObject:[NSNull null] forKey:@"previousFireTime"];
    
    JSScheduleJobState *expectedObject = [JSScheduleJobState new];
    expectedObject.value = [mutJsonObject valueForKey:@"value"];
    
    [self testObjectFromExternalRepresentation:mutJsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectMappingWithNotSupportedDateFormats {
    JSServerInfo *serverInfo = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN].serverInfo;
    NSDateFormatter *formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:serverInfo.dateFormatPattern];
    
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject setObject:[formatter stringFromDate:[NSDate date]] forKey:@"nextFireTime"];
    [mutJsonObject setObject:[formatter stringFromDate:[NSDate date]] forKey:@"previousFireTime"];
    
    JSScheduleJobState *expectedObject = [JSScheduleJobState new];
    expectedObject.value = [mutJsonObject valueForKey:@"value"];
    [self testObjectFromExternalRepresentation:mutJsonObject withMapping:self.mapping expectedObject:expectedObject];
}


- (void)testObjectSerialization {
    JSServerInfo *serverInfo = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN].serverInfo;
    NSDateFormatter *formatter = serverInfo.serverDateFormatFormatter;
    
    JSScheduleJobState *expectedObject = [JSScheduleJobState new];
    expectedObject.value = [self.jsonObject valueForKey:@"value"];
    expectedObject.nextFireTime = [formatter dateFromString:[self.jsonObject valueForKey:@"nextFireTime"]];
    expectedObject.previousFireTime = [formatter dateFromString:[self.jsonObject valueForKey:@"previousFireTime"]];
    
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject];
}

- (void)testObjectSerializationWithNilDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject removeObjectForKey:@"nextFireTime"];
    [mutJsonObject removeObjectForKey:@"previousFireTime"];
    
    JSScheduleJobState *expectedObject = [JSScheduleJobState new];
    expectedObject.value = [mutJsonObject valueForKey:@"value"];
    
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:mutJsonObject];
}

- (void)testObjectSerializationWithNSNullDates {
    NSMutableDictionary *mutJsonObject = [NSMutableDictionary dictionaryWithDictionary:self.jsonObject];
    [mutJsonObject setObject:[NSNull null] forKey:@"nextFireTime"];
    [mutJsonObject setObject:[NSNull null] forKey:@"previousFireTime"];
    
    JSScheduleJobState *expectedObject = [JSScheduleJobState new];
    expectedObject.value = [mutJsonObject valueForKey:@"value"];
    
    id someValue = [NSNull null];
    expectedObject.nextFireTime = someValue;
    expectedObject.previousFireTime = someValue;
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:mutJsonObject];
}

@end
