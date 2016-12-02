//
//  JSParameterTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/6/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSParameter.h"

NSString *const kJSParameterTestName = @"kJSParameterTestName";
NSString *const kJSParameterTestValue = @"kJSParameterTestValue";

@interface JSParameterTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSParameterTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSParameter class]];
    self.mapping = [JSParameter objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSParameter *expectedObject = [JSParameter new];
    expectedObject.name = [self.jsonObject valueForKey:@"name"];
    expectedObject.value = [self.jsonObject valueForKey:@"value"];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectSerialization {
    JSParameter *expectedObject = [JSParameter new];
    expectedObject.name = [self.jsonObject valueForKey:@"name"];
    expectedObject.value = [self.jsonObject valueForKey:@"value"];
    
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject];
}

- (void)testInitialization {
    JSParameter *parameter = [JSParameter parameterWithName:kJSParameterTestName value:kJSParameterTestValue];
    XCTAssertEqualObjects(parameter.name, kJSParameterTestName);
    XCTAssertEqualObjects(parameter.value, kJSParameterTestValue);
}
@end
