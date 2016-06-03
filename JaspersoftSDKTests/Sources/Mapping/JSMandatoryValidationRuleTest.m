//
//  JSMandatoryValidationRuleTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/5/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSMandatoryValidationRule.h"
#import "EKMapper.h"


@interface JSMandatoryValidationRuleTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSMandatoryValidationRuleTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSMandatoryValidationRule class]];
    self.mapping = [JSMandatoryValidationRule objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSMandatoryValidationRule *expectedObject = [JSMandatoryValidationRule new];
    expectedObject.errorMessage = [self.jsonObject valueForKey:@"errorMessage"];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testNSCopyingProtocolSupport {
    JSMandatoryValidationRule *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSMandatoryValidationRule *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}
@end
