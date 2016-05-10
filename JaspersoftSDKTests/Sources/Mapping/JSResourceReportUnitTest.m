//
//  JSResourceReportUnitTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/10/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSResourceReportUnit.h"
#import "JSServerInfo.h"

@interface JSResourceReportUnitTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSResourceReportUnitTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSResourceReportUnit class]];
    self.mapping = [JSResourceReportUnit objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSProfile *serverProfile = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN];
    NSDateFormatter *formatter = [serverProfile.serverInfo serverDateFormatFormatter];
    
    JSResourceReportUnit *expectedObject = [JSResourceReportUnit new];
    expectedObject.label            = [self.jsonObject valueForKey:@"label"];
    expectedObject.uri              = [self.jsonObject valueForKey:@"uri"];
    expectedObject.resourceDescription= [self.jsonObject valueForKey:@"description"];
    expectedObject.resourceType     = [self.jsonObject valueForKey:@"resourceType"];
    expectedObject.version          = [self.jsonObject valueForKey:@"version"];
    expectedObject.permissionMask   = [self.jsonObject valueForKey:@"permissionMask"];
    expectedObject.creationDate     = [formatter dateFromString:[self.jsonObject valueForKey:@"creationDate"]];
    expectedObject.updateDate       = [formatter dateFromString:[self.jsonObject valueForKey:@"updateDate"]];
    expectedObject.alwaysPromptControls = [[self.jsonObject valueForKey:@"alwaysPromptControls"] boolValue];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}
@end
