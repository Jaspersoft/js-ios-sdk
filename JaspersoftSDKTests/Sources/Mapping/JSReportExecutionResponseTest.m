/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSReportExecutionResponse.h"
#import "EKMapper.h"

@interface JSReportExecutionResponseTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSReportExecutionResponseTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSReportExecutionResponse class]];
    self.mapping = [JSReportExecutionResponse objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_JADE_6_2_0]];
}

- (void)testObjectMapping
{
    JSReportExecutionResponse *expectedObject = [JSReportExecutionResponse new];
    expectedObject.totalPages = [self.jsonObject valueForKey:@"totalPages"];
    expectedObject.currentPage = [self.jsonObject valueForKey:@"currentPage"];
    expectedObject.reportURI = [self.jsonObject valueForKey:@"reportURI"];
    expectedObject.requestId = [self.jsonObject valueForKey:@"requestId"];
    
    NSDictionary *statusesStringRepresentation = @{ @"ready"    : @(kJS_EXECUTION_STATUS_READY),
                                                    @"queued"   : @(kJS_EXECUTION_STATUS_QUEUED),
                                                    @"execution": @(kJS_EXECUTION_STATUS_EXECUTION),
                                                    @"cancelled": @(kJS_EXECUTION_STATUS_CANCELED),
                                                    @"failed"   : @(kJS_EXECUTION_STATUS_FAILED)
                                                    };
    JSExecutionStatus *status = [JSExecutionStatus new];
    status.status = [[statusesStringRepresentation objectForKey:[self.jsonObject objectForKey:@"status"]] integerValue];
    expectedObject.status = status;

    JSProfile *serverProfile = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_JADE_6_2_0];
    if ([self.jsonObject valueForKey:@"errorDescriptor"]) {
        EKObjectMapping *errorMapping = [JSErrorDescriptor objectMappingForServerProfile:serverProfile];
        expectedObject.errorDescriptor = [EKMapper objectFromExternalRepresentation:[self.jsonObject objectForKey:@"errorDescriptor"] withMapping:errorMapping];
    }

    EKObjectMapping *exportsMapping = [JSExportExecutionResponse objectMappingForServerProfile:serverProfile];
    expectedObject.exports = [EKMapper arrayOfObjectsFromExternalRepresentation:[self.jsonObject objectForKey:@"exports"] withMapping:exportsMapping];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}
@end
