//
//  JSReportParameterTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/10/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSReportParameter.h"

@interface JSReportParameterTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSReportParameterTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSReportParameter class]];
    self.mapping = [JSReportParameter objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSReportParameter *expectedObject = [JSReportParameter new];
    expectedObject.name = [self.jsonObject valueForKey:@"name"];
    expectedObject.value = [self.jsonObject valueForKey:@"value"];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectSerialization {
    JSReportParameter *expectedObject = [JSReportParameter new];
    expectedObject.name = [self.jsonObject valueForKey:@"name"];
    expectedObject.value = [self.jsonObject valueForKey:@"value"];
    
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject];
}

- (void)testRequestObjectKeyPath {
    XCTAssertEqual([JSReportParameter requestObjectKeyPath], @"reportParameter");
}

@end
