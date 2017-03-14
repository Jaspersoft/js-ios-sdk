/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSReportExecutionRequest.h"
#import "EKMapper.h"

@interface JSReportExecutionRequestTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSReportExecutionRequestTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSReportExecutionRequest class]];
    self.mapping = [JSReportExecutionRequest objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_JADE_6_2_0]];
}

- (void)testObjectMapping
{
    JSReportExecutionRequest *expectedObject = [JSReportExecutionRequest new];
    expectedObject.reportUnitUri = [self.jsonObject valueForKey:@"reportUnitUri"];
    expectedObject.async = [self.jsonObject valueForKey:@"async"];
    expectedObject.outputFormat = [self.jsonObject valueForKey:@"outputFormat"];
    expectedObject.interactive = [self.jsonObject valueForKey:@"interactive"];
    expectedObject.freshData = [self.jsonObject valueForKey:@"freshData"];
    expectedObject.saveDataSnapshot = [self.jsonObject valueForKey:@"saveDataSnapshot"];
    expectedObject.ignorePagination = [self.jsonObject valueForKey:@"ignorePagination"];
    expectedObject.baseURL = [self.jsonObject valueForKey:@"baseUrl"];
    expectedObject.transformerKey = [self.jsonObject valueForKey:@"transformerKey"];
    expectedObject.pages = [self.jsonObject valueForKey:@"pages"];
    expectedObject.attachmentsPrefix = [self.jsonObject valueForKey:@"attachmentsPrefix"];
    
    NSDictionary *markupTypes = @{
                                  @"full": @(JSMarkupTypeFull),
                                  @"embeddable": @(JSMarkupTypeEmbeddable)
                                  };
    expectedObject.markupType = [[markupTypes objectForKey:[self.jsonObject valueForKey:@"markupType"]] integerValue];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject skippingKeyPaths:@[@"parameters"]];
}

- (void)testObjectSerialization {
    JSReportExecutionRequest *expectedObject = [JSReportExecutionRequest new];
    expectedObject.pages = [self.jsonObject valueForKey:@"pages"];

    
    expectedObject.reportUnitUri = [self.jsonObject valueForKey:@"reportUnitUri"];
    expectedObject.async = [self.jsonObject valueForKey:@"async"];
    expectedObject.outputFormat = [self.jsonObject valueForKey:@"outputFormat"];
    expectedObject.interactive = [self.jsonObject valueForKey:@"interactive"];
    expectedObject.freshData = [self.jsonObject valueForKey:@"freshData"];
    expectedObject.saveDataSnapshot = [self.jsonObject valueForKey:@"saveDataSnapshot"];
    expectedObject.ignorePagination = [self.jsonObject valueForKey:@"ignorePagination"];
    expectedObject.baseURL = [self.jsonObject valueForKey:@"baseUrl"];
    expectedObject.transformerKey = [self.jsonObject valueForKey:@"transformerKey"];
    expectedObject.attachmentsPrefix = [self.jsonObject valueForKey:@"attachmentsPrefix"];
    
    NSDictionary *markupTypes = @{
                                  @"full": @(JSMarkupTypeFull),
                                  @"embeddable": @(JSMarkupTypeEmbeddable)
                                  };
    expectedObject.markupType = [[markupTypes objectForKey:[self.jsonObject valueForKey:@"markupType"]] integerValue];

    EKObjectMapping *parametersMapping = [JSReportParameter objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    expectedObject.parameters = [EKMapper arrayOfObjectsFromExternalRepresentation:[self.jsonObject valueForKeyPath:@"parameters.reportParameter"] withMapping:parametersMapping];
    
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject];
}
@end
