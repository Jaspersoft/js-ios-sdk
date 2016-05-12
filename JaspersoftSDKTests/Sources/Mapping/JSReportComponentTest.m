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
    JSReportComponent *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}

@end
