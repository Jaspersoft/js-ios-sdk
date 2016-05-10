//
//  JSExecutionStatusTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/5/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSExecutionStatus.h"
#import "EKMapper.h"

@interface JSExecutionStatusTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSExecutionStatusTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSExecutionStatus class]];
    self.mapping = [JSExecutionStatus objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping
{
    JSExecutionStatus *expectedObject = [JSExecutionStatus new];
    NSDictionary *statusesStringRepresentation = @{ @"ready"    : @(kJS_EXECUTION_STATUS_READY),
                                                    @"queued"   : @(kJS_EXECUTION_STATUS_QUEUED),
                                                    @"execution": @(kJS_EXECUTION_STATUS_EXECUTION),
                                                    @"cancelled": @(kJS_EXECUTION_STATUS_CANCELED),
                                                    @"failed"   : @(kJS_EXECUTION_STATUS_FAILED)
                                                    };

    expectedObject.status = [[statusesStringRepresentation objectForKey:[self.jsonObject valueForKey:@"value"] ] integerValue];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectSerialization {
    JSExecutionStatus *expectedObject = [JSExecutionStatus new];
    NSDictionary *statusesStringRepresentation = @{ @"ready"    : @(kJS_EXECUTION_STATUS_READY),
                                                    @"queued"   : @(kJS_EXECUTION_STATUS_QUEUED),
                                                    @"execution": @(kJS_EXECUTION_STATUS_EXECUTION),
                                                    @"cancelled": @(kJS_EXECUTION_STATUS_CANCELED),
                                                    @"failed"   : @(kJS_EXECUTION_STATUS_FAILED)
                                                    };
    
    expectedObject.status = [[statusesStringRepresentation objectForKey:[self.jsonObject valueForKey:@"value"] ] integerValue];
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject];
}

- (void)testIsEquals {
    JSExecutionStatus *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    XCTAssertFalse([mappedObject isEqual:self]);
    
    XCTAssertTrue([mappedObject isEqual:mappedObject]);
    JSExecutionStatus *newObject = [JSExecutionStatus new];
    newObject.status = mappedObject.status;
    XCTAssertTrue([mappedObject isEqual:newObject]);
}

@end
