//
//  JSExportExecutionRequest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/5/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSExportExecutionRequest.h"
#import "JSReportPagesRange.h"

@interface JSExportExecutionRequestTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSExportExecutionRequestTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSExportExecutionRequest class]];
    self.mapping = [JSExportExecutionRequest objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_JADE_6_2_0]];
}

- (void)testObjectMapping
{
    JSExportExecutionRequest *expectedObject = [JSExportExecutionRequest new];
    
    expectedObject.outputFormat = [self.jsonObject valueForKey:@"outputFormat"];
    expectedObject.pages = [self.jsonObject valueForKey:@"pages"];
    expectedObject.attachmentsPrefix = [self.jsonObject valueForKey:@"attachmentsPrefix"];
    expectedObject.baseUrl = [self.jsonObject valueForKey:@"baseUrl"];
    NSDictionary *markupTypes = @{
                                  @"full": @(JSMarkupTypeFull),
                                  @"embeddable": @(JSMarkupTypeEmbeddable)
                                  };

    expectedObject.markupType = [[markupTypes objectForKey:[self.jsonObject valueForKey:@"markupType"]] integerValue];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectSerialization {
    JSExportExecutionRequest *expectedObject = [JSExportExecutionRequest new];
    expectedObject.outputFormat = [self.jsonObject valueForKey:@"outputFormat"];
    expectedObject.pages = [self.jsonObject valueForKey:@"pages"];
    expectedObject.attachmentsPrefix = [self.jsonObject valueForKey:@"attachmentsPrefix"];
    expectedObject.baseUrl = [self.jsonObject valueForKey:@"baseUrl"];
    NSDictionary *markupTypes = @{
                                  @"full": @(JSMarkupTypeFull),
                                  @"embeddable": @(JSMarkupTypeEmbeddable)
                                  };
    
    expectedObject.markupType = [[markupTypes objectForKey:[self.jsonObject valueForKey:@"markupType"]] integerValue];

    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject];
}
@end
