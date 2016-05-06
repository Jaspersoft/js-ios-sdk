//
//  JSExportExecutionResponseTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/5/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSExportExecutionResponse.h"
#import "EKMapper.h"

@interface JSExportExecutionResponseTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSExportExecutionResponseTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSExportExecutionResponse class]];
    self.mapping = [JSExportExecutionResponse objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_JADE_6_2_0]];
}

- (void)testObjectMapping
{
    JSExportExecutionResponse *expectedObject = [JSExportExecutionResponse new];
    expectedObject.uuid = [self.jsonObject valueForKey:@"id"];

    JSProfile *serverProfile = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_JADE_6_2_0];
    
    NSDictionary *statusesStringRepresentation = @{ @"ready"    : @(kJS_EXECUTION_STATUS_READY),
                                                    @"queued"   : @(kJS_EXECUTION_STATUS_QUEUED),
                                                    @"execution": @(kJS_EXECUTION_STATUS_EXECUTION),
                                                    @"cancelled": @(kJS_EXECUTION_STATUS_CANCELED),
                                                    @"failed"   : @(kJS_EXECUTION_STATUS_FAILED)
                                                    };
    JSExecutionStatus *status = [JSExecutionStatus new];
    status.status = [[statusesStringRepresentation objectForKey:[self.jsonObject objectForKey:@"status"]] integerValue];
    expectedObject.status = status;
    
    if ([self.jsonObject valueForKey:@"errorDescriptor"]) {
        EKObjectMapping *errorMapping = [JSErrorDescriptor objectMappingForServerProfile:serverProfile];
        expectedObject.errorDescriptor = [EKMapper objectFromExternalRepresentation:[self.jsonObject objectForKey:@"errorDescriptor"] withMapping:errorMapping];
    }
    
    EKObjectMapping *outputMapping = [JSReportOutputResource objectMappingForServerProfile:serverProfile];
    expectedObject.outputResource = [EKMapper objectFromExternalRepresentation:[self.jsonObject objectForKey:@"outputResource"] withMapping:outputMapping];
    
    expectedObject.attachments = [EKMapper arrayOfObjectsFromExternalRepresentation:[self.jsonObject objectForKey:@"attachments"] withMapping:outputMapping];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

@end
