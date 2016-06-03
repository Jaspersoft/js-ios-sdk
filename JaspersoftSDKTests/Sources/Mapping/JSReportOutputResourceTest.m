//
//  JSReportOutputResourceTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/10/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSReportOutputResource.h"

@interface JSReportOutputResourceTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSReportOutputResourceTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSReportOutputResource class]];
    self.mapping = [JSReportOutputResource objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSReportOutputResource *expectedObject = [JSReportOutputResource new];
    expectedObject.contentType = [self.jsonObject valueForKey:@"contentType"];
    expectedObject.fileName = [self.jsonObject valueForKey:@"fileName"];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

@end
