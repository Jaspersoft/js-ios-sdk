//
//  JSErrorDescriptorTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/5/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSErrorDescriptor.h"

@interface JSErrorDescriptorTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSErrorDescriptorTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSErrorDescriptor class]];
    self.mapping = [JSErrorDescriptor objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping
{
    JSErrorDescriptor *expectedObject = [JSErrorDescriptor new];
    expectedObject.message      = [self.jsonObject valueForKey:@"message"];
    expectedObject.errorCode     = [self.jsonObject valueForKey:@"errorCode"];
    expectedObject.parameters    = [self.jsonObject valueForKey:@"parameters"];

    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}
@end
