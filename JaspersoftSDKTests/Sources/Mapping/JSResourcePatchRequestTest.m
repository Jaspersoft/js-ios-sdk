//
//  JSResourcePatchRequestTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/10/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSResourcePatchRequest.h"
#import "JSResourceLookup.h"
#import "JSPatchResourceParameter.h"
#import "EKMapper.h"

@interface JSResourcePatchRequestTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@property (nonatomic, strong) JSResourceLookup *resource;

@end

@implementation JSResourcePatchRequestTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSResourcePatchRequest class]];
    self.mapping = [JSResourcePatchRequest objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    NSDictionary *resourceLookupSource = [JSObjectRepresentationProvider JSONObjectForClass:[JSResourceLookup class]];
    EKObjectMapping *resourceMapping = [JSResourceLookup objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    self.resource = [EKMapper objectFromExternalRepresentation:resourceLookupSource withMapping:resourceMapping];
}

- (void)testObjectMapping {
    JSResourcePatchRequest *expectedObject = [JSResourcePatchRequest new];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    EKObjectMapping *parameterMapping = [JSPatchResourceParameter objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    expectedObject.patch = [EKMapper arrayOfObjectsFromExternalRepresentation:[self.jsonObject valueForKey:@"patch"] withMapping:parameterMapping];

    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testObjectSerialization {
    JSResourcePatchRequest *expectedObject = [JSResourcePatchRequest new];
    expectedObject.version = [self.jsonObject valueForKey:@"version"];
    EKObjectMapping *parameterMapping = [JSPatchResourceParameter objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
    expectedObject.patch = [EKMapper arrayOfObjectsFromExternalRepresentation:[self.jsonObject valueForKey:@"patch"] withMapping:parameterMapping];
    
    [self testSerializeObject:expectedObject withMapping:self.mapping expectedRepresentation:self.jsonObject];
}

- (void)testInitialization {
    JSResourcePatchRequest *patchRequest = [JSResourcePatchRequest patchRecuestWithResource:self.resource];

    XCTAssertNotNil(patchRequest);
    XCTAssertEqualObjects(patchRequest.version, self.resource.version);
    
    for (JSPatchResourceParameter *parameter in patchRequest.patch) {
        XCTAssertNotNil(parameter.name);
        if ([parameter.name isEqualToString:@"label"]) {
            XCTAssertEqualObjects(parameter.value, self.resource.label);
        } else if ([parameter.name isEqualToString:@"description"]) {
            XCTAssertEqualObjects(parameter.value, self.resource.resourceDescription);
        }
    }
}

@end
