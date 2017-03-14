/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSDataType.h"
#import "EKMapper.h"

@interface JSDataTypeTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSDataTypeTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSDataType class]];
    self.mapping = [JSDataType objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSDataType *expectedObject = [JSDataType new];
    expectedObject.pattern = [self.jsonObject valueForKey:@"pattern"];
    expectedObject.maxValue = [self.jsonObject valueForKey:@"maxValue"];
    expectedObject.minValue = [self.jsonObject valueForKey:@"minValue"];
    expectedObject.strictMax = [[self.jsonObject valueForKey:@"strictMax"] boolValue];
    expectedObject.strictMin = [[self.jsonObject valueForKey:@"strictMin"] boolValue];
    expectedObject.maxLength = [[self.jsonObject valueForKey:@"maxLength"] integerValue];
    
    NSDictionary *typesDictionary = @{ @"text": @(kJS_DT_TYPE_TEXT),
                                       @"number": @(kJS_DT_TYPE_NUMBER),
                                       @"date": @(kJS_DT_TYPE_DATE),
                                       @"time": @(kJS_DT_TYPE_TIME),
                                       @"datetime": @(kJS_DT_TYPE_DATE_TIME)};
    NSString *type = [self.jsonObject valueForKey:@"type"];
    expectedObject.type = [typesDictionary[type] integerValue];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectSerialization {
    JSDataType *expectedObject = [JSDataType new];
    expectedObject.maxValue = [self.jsonObject valueForKey:@"maxValue"];
    expectedObject.minValue = [self.jsonObject valueForKey:@"minValue"];
    expectedObject.strictMax = [[self.jsonObject valueForKey:@"strictMax"] boolValue];
    expectedObject.strictMin = [[self.jsonObject valueForKey:@"strictMax"] boolValue];

    NSDictionary *typesDictionary = @{ @"text": @(kJS_DT_TYPE_TEXT),
                                       @"number": @(kJS_DT_TYPE_NUMBER),
                                       @"date": @(kJS_DT_TYPE_DATE),
                                       @"time": @(kJS_DT_TYPE_TIME),
                                       @"datetime": @(kJS_DT_TYPE_DATE_TIME)};
    expectedObject.type = [[typesDictionary objectForKey:[self.jsonObject valueForKey:@"type"]] integerValue];

    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject skippingKeyPaths:@[@"maxLength", @"pattern"]];
}

- (void)testNSCopyingProtocolSupport {
    JSDataType *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSDataType *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}
@end
