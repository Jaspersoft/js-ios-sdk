//
//  JSReportComponentTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/11/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSReportComponent.h"
#import "EKMapper.h"

@interface JSReportComponentTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSReportComponentTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSReportComponent class]];
    self.mapping = [JSReportComponent objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSReportComponent *expectedObject = [JSReportComponent new];
    expectedObject.identifier = [self.jsonObject valueForKey:@"id"];
    
    NSDictionary *componentTypes = @{
                                     @"undefined"    : @(JSReportComponentTypeUndefined),
                                     @"chart"        : @(JSReportComponentTypeChart),
                                     @"table"        : @(JSReportComponentTypeTable),
                                     @"column"       : @(JSReportComponentTypeColumn),
                                     @"fusionWidget" : @(JSReportComponentTypeFusion),
                                     @"crosstab"     : @(JSReportComponentTypeCrosstab),
                                     @"hyperlinks"   : @(JSReportComponentTypeHyperlinks),
                                     @"bookmarks"    : @(JSReportComponentTypeBookmarks),
                                     };
    expectedObject.type = [[componentTypes objectForKey:[self.jsonObject valueForKey:@"type"]] integerValue];

    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectSerialization {
    JSReportComponent *expectedObject = [JSReportComponent new];
    expectedObject.identifier = [self.jsonObject valueForKey:@"id"];
    
    NSDictionary *componentTypes = @{
                                     @"undefined"    : @(JSReportComponentTypeUndefined),
                                     @"chart"        : @(JSReportComponentTypeChart),
                                     @"table"        : @(JSReportComponentTypeTable),
                                     @"column"       : @(JSReportComponentTypeColumn),
                                     @"fusionWidget" : @(JSReportComponentTypeFusion),
                                     @"crosstab"     : @(JSReportComponentTypeCrosstab),
                                     @"hyperlinks"   : @(JSReportComponentTypeHyperlinks),
                                     @"bookmarks"    : @(JSReportComponentTypeBookmarks),
                                     };
    expectedObject.type = [[componentTypes objectForKey:[self.jsonObject valueForKey:@"type"]] integerValue];
    
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject];
}

- (void)testNSCopyingProtocolSupport {
    JSReportComponent *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    
    NSDictionary *structureDictionary = [JSObjectRepresentationProvider JSONObjectForClass:[JSReportComponentTableStructure class]];
    EKObjectMapping *structureMapping = [JSReportComponentTableStructure objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    mappedObject.structure = [EKMapper objectFromExternalRepresentation:structureDictionary withMapping:structureMapping];
    
    JSReportComponent *copiedObject = [mappedObject copy];
    
    XCTAssertNotNil(copiedObject);
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
    XCTAssertNotNil(copiedObject.structure);
}

@end

#pragma mark - JSReportComponentTableStructureTest
@interface JSReportComponentTableStructureTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSReportComponentTableStructureTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSReportComponentTableStructure class]];
    self.mapping = [JSReportComponentTableStructure objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSReportComponentTableStructure *expectedObject = [JSReportComponentTableStructure new];
    expectedObject.module = [self.jsonObject valueForKey:@"module"];
    expectedObject.uimodule = [self.jsonObject valueForKey:@"uimodule"];
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testNSCopyingProtocolSupport {
    JSReportComponentTableStructure *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSReportComponentTableStructure *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}
@end

#pragma mark - JSReportComponentColumnStructureTest
@interface JSReportComponentColumnStructureTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSReportComponentColumnStructureTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSReportComponentColumnStructure class]];
    self.mapping = [JSReportComponentColumnStructure objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSReportComponentColumnStructure *expectedObject = [JSReportComponentColumnStructure new];
    expectedObject.name = [self.jsonObject valueForKey:@"name"];
    expectedObject.parentId = [self.jsonObject valueForKey:@"parentId"];
    expectedObject.selector = [self.jsonObject valueForKey:@"selector"];
    expectedObject.proxySelector = [self.jsonObject valueForKey:@"proxySelector"];
    expectedObject.columnIndex = [[self.jsonObject valueForKey:@"columnIndex"] integerValue];
    expectedObject.columnLabel = [self.jsonObject valueForKey:@"columnLabel"];
    expectedObject.dataType = [self.jsonObject valueForKey:@"dataType"];
    expectedObject.canSort = [[self.jsonObject valueForKey:@"canSort"] boolValue];
    expectedObject.canFilter = [[self.jsonObject valueForKey:@"canFilter"] boolValue];
    expectedObject.canFormatConditionally = [[self.jsonObject valueForKey:@"canFormatConditionally"] boolValue];

    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testNSCopyingProtocolSupport {
    JSReportComponentColumnStructure *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSReportComponentColumnStructure *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}
@end


#pragma mark - JSReportComponentCrosstabStructureTest
@interface JSReportComponentCrosstabStructureTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSReportComponentCrosstabStructureTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSReportComponentCrosstabStructure class]];
    self.mapping = [JSReportComponentCrosstabStructure objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSReportComponentCrosstabStructure *expectedObject = [JSReportComponentCrosstabStructure new];
    expectedObject.module = [self.jsonObject valueForKey:@"module"];
    expectedObject.uimodule = [self.jsonObject valueForKey:@"uimodule"];
    expectedObject.fragmentId = [self.jsonObject valueForKey:@"fragmentId"];
    expectedObject.crosstabId = [self.jsonObject valueForKey:@"crosstabId"];
    expectedObject.startColumnIndex = [[self.jsonObject valueForKey:@"startColumnIndex"] integerValue];
    expectedObject.hasFloatingHeaders = [[self.jsonObject valueForKey:@"hasFloatingHeaders"] boolValue];

    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testNSCopyingProtocolSupport {
    JSReportComponentCrosstabStructure *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSReportComponentCrosstabStructure *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}
@end

#pragma mark - JSReportComponentFusionStructureTest
@interface JSReportComponentFusionStructureTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSReportComponentFusionStructureTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSReportComponentFusionStructure class]];
    self.mapping = [JSReportComponentFusionStructure objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSReportComponentFusionStructure *expectedObject = [JSReportComponentFusionStructure new];
    expectedObject.module = [self.jsonObject valueForKey:@"module"];
    expectedObject.instanceData = [self.jsonObject valueForKey:@"instanceData"];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testNSCopyingProtocolSupport {
    JSReportComponentFusionStructure *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSReportComponentFusionStructure *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}
@end


#pragma mark - JSReportComponentChartStructureTest
@interface JSReportComponentChartStructureTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSReportComponentChartStructureTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSReportComponentChartStructure class]];
    self.mapping = [JSReportComponentChartStructure objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSReportComponentChartStructure *expectedObject = [JSReportComponentChartStructure new];
    expectedObject.module = [self.jsonObject valueForKey:@"module"];
    expectedObject.uimodule = [self.jsonObject valueForKey:@"uimodule"];
    expectedObject.charttype = [self.jsonObject valueForKey:@"charttype"];
    expectedObject.interactive = [[self.jsonObject valueForKey:@"interactive"] boolValue];
    expectedObject.datetimeSupported = [[self.jsonObject valueForKey:@"datetimeSupported"] boolValue];
    expectedObject.treemapSupported = [[self.jsonObject valueForKey:@"treemapSupported"] boolValue];
    expectedObject.globalOptions = [self.jsonObject valueForKey:@"globalOptions"];
    expectedObject.hcinstancedata = [self.jsonObject valueForKey:@"hcinstancedata"];

    NSDictionary *serviceTypes = @{
                                   @"undefined"                     : @(JSHighchartServiceTypeUndefined),
                                   @"adhocHighchartsSettingService" : @(JSHighchartServiceTypeAdhoc),
                                   @"dataSettingService"            : @(JSHighchartServiceTypeData),
                                   @"defaultSettingService"         : @(JSHighchartServiceTypeDefault),
                                   @"xAxisSettingService"           : @(JSHighchartServiceTypeXAxis),
                                   @"yAxisSettingService"           : @(JSHighchartServiceTypeYAxis),
                                   @"itemHyperlinkSettingService"   : @(JSHighchartServiceTypeItemHyperlink),
                                   };
    
    NSArray *services = [self.jsonObject valueForKeyPath:@"hcinstancedata.services"];
    NSMutableArray *serviceNames = [NSMutableArray array];
    for (NSDictionary *service in services) {
        NSString *serviceName = service[@"service"];
        if (serviceName) {
            [serviceNames addObject:serviceTypes[serviceName]];
        }
    }
    expectedObject.services = serviceNames;
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testNSCopyingProtocolSupport {
    JSReportComponentChartStructure *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSReportComponentChartStructure *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}
@end

