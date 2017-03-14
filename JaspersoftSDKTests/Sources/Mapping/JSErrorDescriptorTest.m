/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

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
