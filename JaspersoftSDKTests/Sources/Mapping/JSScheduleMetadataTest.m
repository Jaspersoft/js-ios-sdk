//
//  JSScheduleMetadataTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/17/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSDateFormatterFactory.h"
#import "JSScheduleMetadata.h"
#import "JSScheduleTrigger.h"
#import "EKMapper.h"

@interface JSScheduleMetadataTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation JSScheduleMetadataTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSScheduleMetadata class]];
    self.mapping = [JSScheduleMetadata objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:[self.jsonObject valueForKey:@"outputTimeZone"]];
    self.formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ" timeZone:timeZone];
    
}

- (void)testObjectMapping {
    JSScheduleMetadata *expectedObject = [JSScheduleMetadata new];
    expectedObject.jobIdentifier = [[self.jsonObject valueForKey:@"id"] integerValue];
    expectedObject.version = [[self.jsonObject valueForKey:@"version"] integerValue];
    expectedObject.username = [self.jsonObject valueForKey:@"username"];
    expectedObject.label = [self.jsonObject valueForKey:@"label"];
    expectedObject.scheduleDescription = [self.jsonObject valueForKey:@"description"];
    expectedObject.reportUnitURI = [self.jsonObject valueForKeyPath:@"source.reportUnitURI"];
    expectedObject.baseOutputFilename = [self.jsonObject valueForKey:@"baseOutputFilename"];
    expectedObject.outputLocale = [self.jsonObject valueForKey:@"outputLocale"];
    expectedObject.mailNotification = [self.jsonObject valueForKey:@"mailNotification"];
    expectedObject.alert = [self.jsonObject valueForKey:@"alert"];
    expectedObject.folderURI = [self.jsonObject valueForKeyPath:@"repositoryDestination.folderURI"];
    expectedObject.outputTimeZone = [self.jsonObject valueForKey:@"outputTimeZone"];
    expectedObject.outputFormats = [self.jsonObject valueForKeyPath:@"outputFormats.outputFormat"];
    expectedObject.source = [self.jsonObject valueForKey:@"source"];
    expectedObject.repositoryDestination = [self.jsonObject valueForKey:@"repositoryDestination"];
    expectedObject.creationDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"creationDate"]];
    
    EKObjectMapping *triggerMapping = [JSScheduleSimpleTrigger objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    expectedObject.trigger = [EKMapper objectFromExternalRepresentation:[self.jsonObject valueForKey:@"trigger"] withMapping:triggerMapping];

    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject skippingKeyPaths:@[@"trigger"]];
}

- (void)testObjectSerialization {
    JSScheduleMetadata *expectedObject = [JSScheduleMetadata new];
    expectedObject.jobIdentifier = [[self.jsonObject valueForKey:@"id"] integerValue];
    expectedObject.version = [[self.jsonObject valueForKey:@"version"] integerValue];
    expectedObject.username = [self.jsonObject valueForKey:@"username"];
    expectedObject.label = [self.jsonObject valueForKey:@"label"];
    expectedObject.scheduleDescription = [self.jsonObject valueForKey:@"description"];
    expectedObject.reportUnitURI = [self.jsonObject valueForKeyPath:@"source.reportUnitURI"];
    expectedObject.baseOutputFilename = [self.jsonObject valueForKey:@"baseOutputFilename"];
    expectedObject.outputLocale = [self.jsonObject valueForKey:@"outputLocale"];
    expectedObject.mailNotification = [self.jsonObject valueForKey:@"mailNotification"];
    expectedObject.alert = [self.jsonObject valueForKey:@"alert"];
    expectedObject.folderURI = [self.jsonObject valueForKeyPath:@"repositoryDestination.folderURI"];
    expectedObject.outputTimeZone = [self.jsonObject valueForKey:@"outputTimeZone"];
    expectedObject.outputFormats = [self.jsonObject valueForKeyPath:@"outputFormats.outputFormat"];
    expectedObject.source = [self.jsonObject valueForKey:@"source"];
    expectedObject.repositoryDestination = [self.jsonObject valueForKey:@"repositoryDestination"];
    expectedObject.creationDate = [self.formatter dateFromString:[self.jsonObject valueForKey:@"creationDate"]];

    EKObjectMapping *triggerMapping = [JSScheduleSimpleTrigger objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    expectedObject.trigger = [EKMapper objectFromExternalRepresentation:[self.jsonObject valueForKeyPath:@"trigger.simpleTrigger"] withMapping:triggerMapping];

    // We skip 'creationDate' field because we have issue with it comparing
    NSDictionary *serializedObject = [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject skippingKeyPaths:@[@"trigger", @"creationDate"]];
    
    NSDate *serializedCreatingDate = [self.formatter dateFromString:[serializedObject valueForKey:@"creationDate"]];
    float expectedDateTimeInterval = floor([expectedObject.creationDate timeIntervalSince1970]);
    float serializedDateTimeInterval = floor([serializedCreatingDate timeIntervalSince1970]);

    XCTAssertEqual(expectedDateTimeInterval, serializedDateTimeInterval);
}

@end
