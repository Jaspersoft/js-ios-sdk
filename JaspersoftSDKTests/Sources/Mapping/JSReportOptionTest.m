//
//  JSReportOptionTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/6/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSReportOption.h"
#import "EKMapper.h"

@interface JSReportOptionTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSReportOptionTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSReportOption class]];
    self.mapping = [JSReportOption objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSReportOption *expectedObject = [JSReportOption new];
    expectedObject.label = [self.jsonObject valueForKey:@"label"];
    expectedObject.uri = [self.jsonObject valueForKey:@"uri"];
    expectedObject.identifier = [self.jsonObject valueForKey:@"id"];

    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectSerialization {
    JSReportOption *expectedObject = [JSReportOption new];
    expectedObject.label = [self.jsonObject valueForKey:@"label"];
    expectedObject.uri = [self.jsonObject valueForKey:@"uri"];
    expectedObject.identifier = [self.jsonObject valueForKey:@"id"];

    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject skippingKeyPaths:@[@"maxLength", @"pattern"]];
}

- (void)testDefaultReportOption {
    JSReportOption *option = [JSReportOption new];
    option.label = JSCustomLocalizedString(@"report.options.default.option.title", nil);
    
    JSReportOption *defaultOption = [JSReportOption defaultReportOption];
    XCTAssertNotNil(defaultOption.label);
    XCTAssertNil(defaultOption.uri);
    XCTAssertNil(defaultOption.identifier);
    XCTAssertNil(defaultOption.inputControls);
    XCTAssertEqualObjects(option, defaultOption);
}

- (void)testIsEquals {
    JSReportOption *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    XCTAssertTrue([mappedObject isEqual:mappedObject]);
    JSReportOption *newObject = [JSReportOption new];
    newObject.label = mappedObject.label;
    newObject.uri = mappedObject.uri;
    XCTAssertTrue([mappedObject isEqual:newObject]);
}

- (void)testNSCopyingProtocolSupport {
    JSReportOption *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSReportOption *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}
@end
