//
//  JSOrganizationTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 01/06/17.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSOrganization.h"
#import "JSServerInfo.h"

@interface JSOrganizationTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSOrganizationTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSOrganization class]];
    self.mapping = [JSOrganization objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSOrganization *expectedObject = [JSOrganization new];
    
    expectedObject.organizationId   = [self.jsonObject valueForKey:@"id"];
    expectedObject.alias            = [self.jsonObject valueForKey:@"alias"];
    expectedObject.parentId         = [self.jsonObject valueForKey:@"parentId"];
    expectedObject.tenantName       = [self.jsonObject valueForKey:@"tenantName"];
    expectedObject.tenantDescription = [self.jsonObject valueForKey:@"tenantDesc"];
    expectedObject.tenantNote       = [self.jsonObject valueForKey:@"tenantNote"];
    expectedObject.tenantUri        = [self.jsonObject valueForKey:@"tenantUri"];
    expectedObject.tenantFolderUri  = [self.jsonObject valueForKey:@"tenantFolderUri"];
    expectedObject.theme            = [self.jsonObject valueForKey:@"theme"];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}
@end
