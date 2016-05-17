//
//  JSScheduleLookupTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/13/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSScheduleLookup.h"
#import "JSScheduleJobState.h"
#import "EKMapper.h"

@interface JSScheduleLookupTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSScheduleLookupTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSScheduleLookup class]];
    self.mapping = [JSScheduleLookup objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSScheduleLookup *expectedObject = [JSScheduleLookup new];
    expectedObject.jobIdentifier = [[self.jsonObject valueForKey:@"id"] integerValue];
    expectedObject.version = [[self.jsonObject valueForKey:@"version"] integerValue];
    expectedObject.reportUnitURI = [self.jsonObject valueForKey:@"reportUnitURI"];
    expectedObject.label = [self.jsonObject valueForKey:@"label"];
    expectedObject.scheduleDescription = [self.jsonObject valueForKey:@"description"];
    expectedObject.owner = [self.jsonObject valueForKey:@"owner"];
    expectedObject.reportLabel = [self.jsonObject valueForKey:@"reportLabel"];
    
    EKObjectMapping *jobStateMapping = [JSScheduleJobState objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    expectedObject.state = [EKMapper objectFromExternalRepresentation:[self.jsonObject valueForKey:@"state"] withMapping:jobStateMapping];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

@end
