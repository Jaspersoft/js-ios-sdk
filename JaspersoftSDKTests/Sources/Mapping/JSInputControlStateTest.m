//
//  JSInputControlStateTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/6/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSInputControlState.h"
#import "EKMapper.h"
#import "JSInputControlOption.h"

@interface JSInputControlStateTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSInputControlStateTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSInputControlState class]];
    self.mapping = [JSInputControlState objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSInputControlState *expectedObject = [JSInputControlState new];
    expectedObject.uuid = [self.jsonObject valueForKey:@"id"];
    expectedObject.uri = [self.jsonObject valueForKey:@"uri"];
    expectedObject.value = [self.jsonObject valueForKey:@"value"];
    expectedObject.error = [self.jsonObject valueForKey:@"error"];
    
    EKObjectMapping *optionMapping = [JSInputControlOption objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    expectedObject.options = [EKMapper arrayOfObjectsFromExternalRepresentation:[self.jsonObject valueForKey:@"options"] withMapping:optionMapping];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testNSCopyingProtocolSupport {
    JSInputControlState *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSInputControlState *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}

@end
