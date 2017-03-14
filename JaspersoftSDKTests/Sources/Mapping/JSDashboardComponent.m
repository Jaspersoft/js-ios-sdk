/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSDashboardComponent.h"
#import "JSServerInfo.h"
#import "EKMapper.h"


@interface JSDashboardComponentTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSDashboardComponentTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSDashboardComponent class]];
    self.mapping = [JSDashboardComponent objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSDashboardComponent *expectedObject = [JSDashboardComponent new];
    expectedObject.identifier           = [self.jsonObject valueForKey:@"id"];
    expectedObject.type                 = [self.jsonObject valueForKey:@"type"];
    expectedObject.label                = [self.jsonObject valueForKey:@"label"];
    expectedObject.name                 = [self.jsonObject valueForKey:@"name"];
    expectedObject.resourceId           = [self.jsonObject valueForKey:@"resourceId"];
    expectedObject.resourceURI          = [self.jsonObject valueForKey:@"resource"];
    expectedObject.ownerResourceURI     = [self.jsonObject valueForKey:@"ownerResourceId"];
    expectedObject.ownerResourceParameterName = [self.jsonObject valueForKey:@"ownerResourceParameterName"];
    expectedObject.dashletHyperlinkUrl  = [self.jsonObject valueForKey:@"dashletHyperlinkUrl"];
    
    NSDictionary *targetTypes = @{
                                  @"Blank" : @(JSDashletHyperlinksTargetTypeBlank),
                                  @"Self"  : @(JSDashletHyperlinksTargetTypeSelf),
                                  @"Parent": @(JSDashletHyperlinksTargetTypeParent),
                                  @"Top"   : @(JSDashletHyperlinksTargetTypeTop)
                                  };

    expectedObject.dashletHyperlinkTarget = [[targetTypes objectForKey:[self.jsonObject valueForKey:@"dashletHyperlinkTarget"]] integerValue];

    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectSerialization {
    JSDashboardComponent *expectedObject = [JSDashboardComponent new];
    expectedObject.identifier           = [self.jsonObject valueForKey:@"id"];
    expectedObject.type                 = [self.jsonObject valueForKey:@"type"];
    expectedObject.label                = [self.jsonObject valueForKey:@"label"];
    expectedObject.name                 = [self.jsonObject valueForKey:@"name"];
    expectedObject.resourceId           = [self.jsonObject valueForKey:@"resourceId"];
    expectedObject.resourceURI          = [self.jsonObject valueForKey:@"resource"];
    expectedObject.ownerResourceURI     = [self.jsonObject valueForKey:@"ownerResourceId"];
    expectedObject.ownerResourceParameterName = [self.jsonObject valueForKey:@"ownerResourceParameterName"];
    expectedObject.dashletHyperlinkUrl  = [self.jsonObject valueForKey:@"dashletHyperlinkUrl"];
    
    NSDictionary *targetTypes = @{
                                  @"Blank" : @(JSDashletHyperlinksTargetTypeBlank),
                                  @"Self"  : @(JSDashletHyperlinksTargetTypeSelf),
                                  @"Parent": @(JSDashletHyperlinksTargetTypeParent),
                                  @"Top"   : @(JSDashletHyperlinksTargetTypeTop)
                                  };
    
    expectedObject.dashletHyperlinkTarget = [[targetTypes objectForKey:[self.jsonObject valueForKey:@"dashletHyperlinkTarget"]] integerValue];
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject];
}

- (void)testRequestObjectKeyPath {
    XCTAssertEqual([JSDashboardComponent requestObjectKeyPath], @"dashboardComponent");
}
@end
