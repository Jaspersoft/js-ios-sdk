/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSInputControlOption.h"
#import "EKMapper.h"

@interface JSInputControlOptionTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSInputControlOptionTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSInputControlOption class]];
    self.mapping = [JSInputControlOption objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSInputControlOption *expectedObject = [JSInputControlOption new];
    expectedObject.label = [self.jsonObject valueForKey:@"label"];
    expectedObject.value = [self.jsonObject valueForKey:@"value"];
    expectedObject.selected = [[self.jsonObject valueForKey:@"selected"] boolValue];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testNSCopyingProtocolSupport {
    JSInputControlOption *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSInputControlOption *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}
@end
