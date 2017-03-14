/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSInputControlDescriptor.h"
#import "EKMapper.h"

@interface JSInputControlDescriptorTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSInputControlDescriptorTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSInputControlDescriptor class]];
    self.mapping = [JSInputControlDescriptor objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSInputControlDescriptor *expectedObject = [JSInputControlDescriptor new];
    expectedObject.uuid = [self.jsonObject valueForKey:@"id"];
    expectedObject.label = [self.jsonObject valueForKey:@"label"];
    expectedObject.mandatory = [self.jsonObject valueForKey:@"mandatory"];
    expectedObject.readOnly = [self.jsonObject valueForKey:@"readOnly"];
    expectedObject.uri = [self.jsonObject valueForKey:@"uri"];
    expectedObject.visible = [self.jsonObject valueForKey:@"visible"];
    expectedObject.masterDependencies = [self.jsonObject valueForKey:@"masterDependencies"];
    expectedObject.slaveDependencies = [self.jsonObject valueForKey:@"slaveDependencies"];

    
    EKObjectMapping *dataTypeMapping = [JSDataType objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    expectedObject.dataType = [EKMapper objectFromExternalRepresentation:[self.jsonObject valueForKey:@"dataType"] withMapping:dataTypeMapping];

    EKObjectMapping *stateMapping = [JSInputControlState objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    expectedObject.state = [EKMapper objectFromExternalRepresentation:[self.jsonObject valueForKey:@"state"] withMapping:stateMapping];

    NSDictionary *typesDictionary = @{ @"bool":                  @(kJS_ICD_TYPE_BOOL),
                                       @"singleValueText":       @(kJS_ICD_TYPE_SINGLE_VALUE_TEXT),
                                       @"singleValueNumber":     @(kJS_ICD_TYPE_SINGLE_VALUE_NUMBER),
                                       @"singleValueDate":       @(kJS_ICD_TYPE_SINGLE_VALUE_DATE),
                                       @"singleValueTime":       @(kJS_ICD_TYPE_SINGLE_VALUE_TIME),
                                       @"singleValueDatetime":   @(kJS_ICD_TYPE_SINGLE_VALUE_DATETIME),
                                       @"singleSelect":          @(kJS_ICD_TYPE_SINGLE_SELECT),
                                       @"singleSelectRadio":     @(kJS_ICD_TYPE_SINGLE_SELECT_RADIO),
                                       @"multiSelect":           @(kJS_ICD_TYPE_MULTI_SELECT),
                                       @"multiSelectCheckbox":   @(kJS_ICD_TYPE_MULTI_SELECT_CHECKBOX)};
    
    expectedObject.type = [[typesDictionary valueForKey:[self.jsonObject valueForKey:@"type"]] integerValue];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject skippingKeyPaths:@[@"validationRules"]];
}

- (void)testNSCopyingProtocolSupport {
    JSInputControlDescriptor *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSInputControlDescriptor *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject skippingKeyPaths:@[@"validationRules"]];
}

- (void)testMandatoryValidationRule {
    NSDictionary *jsonObject = [JSObjectRepresentationProvider JSONObjectFromFileNamed:@"InputControlDescriptorMandatoryRule"];
    JSInputControlDescriptor *expectedObject = [EKMapper objectFromExternalRepresentation:jsonObject withMapping:self.mapping];
    XCTAssertNotNil(expectedObject.mandatoryValidationRule);
}

- (void)testDateTimeFormatValidationRule {
    NSDictionary *jsonObject = [JSObjectRepresentationProvider JSONObjectFromFileNamed:@"InputControlDescriptorDateTimeRule"];
    JSInputControlDescriptor *expectedObject = [EKMapper objectFromExternalRepresentation:jsonObject withMapping:self.mapping];
    XCTAssertNotNil(expectedObject.dateTimeFormatValidationRule);
}

- (void)testSelectedValues {
    NSDictionary *jsonObject = [JSObjectRepresentationProvider JSONObjectFromFileNamed:@"InputControlDescriptorSingleValue"];
    JSInputControlDescriptor *expectedObject = [EKMapper objectFromExternalRepresentation:jsonObject withMapping:self.mapping];
    
    XCTAssertEqual(expectedObject.selectedValues.lastObject, [jsonObject valueForKeyPath:@"state.value"]);
    
    jsonObject = [JSObjectRepresentationProvider JSONObjectFromFileNamed:@"InputControlDescriptorSelectableValue"];
    expectedObject = [EKMapper objectFromExternalRepresentation:jsonObject withMapping:self.mapping];
    
    NSMutableArray *valuesArray = [NSMutableArray array];
    for (NSDictionary *dictionary in [expectedObject valueForKeyPath:@"state.options"]) {
        if ([[dictionary valueForKey:@"selected"] boolValue]) {
            [valuesArray addObject:[dictionary valueForKey:@"value"]];
        }
    }

    XCTAssertEqualObjects(expectedObject.selectedValues, valuesArray);

}

@end
