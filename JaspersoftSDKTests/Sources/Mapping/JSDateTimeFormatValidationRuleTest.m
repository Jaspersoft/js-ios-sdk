/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSDateTimeFormatValidationRule.h"
#import "EKMapper.h"


@interface JSDateTimeFormatValidationRuleTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSDateTimeFormatValidationRuleTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSDateTimeFormatValidationRule class]];
    self.mapping = [JSDateTimeFormatValidationRule objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSDateTimeFormatValidationRule *expectedObject = [JSDateTimeFormatValidationRule new];
    expectedObject.errorMessage = [self.jsonObject valueForKey:@"errorMessage"];
    expectedObject.format = [self.jsonObject valueForKey:@"format"];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testNSCopyingProtocolSupport {
    JSDateTimeFormatValidationRule *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSDateTimeFormatValidationRule *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}
@end
