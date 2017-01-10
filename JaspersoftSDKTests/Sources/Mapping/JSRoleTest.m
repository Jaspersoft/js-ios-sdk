//
//  JSRoleTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 01/06/17.
//  Copyright © 2017 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSRole.h"
#import "JSServerInfo.h"

@interface JSRoleTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSRoleTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSRole class]];
    self.mapping = [JSRole objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSRole *expectedObject = [JSRole new];
    expectedObject.name                 = [self.jsonObject valueForKey:@"name"];
    expectedObject.externallyDefined    = [[self.jsonObject valueForKey:@"externallyDefined"] boolValue];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}
@end
