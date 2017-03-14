/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSContentResource.h"
#import "JSServerInfo.h"
#import "EKMapper.h"

@interface JSContentResourceTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSContentResourceTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSContentResource class]];
    self.mapping = [JSContentResource objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSProfile *serverProfile = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN];
    NSDateFormatter *formatter = [serverProfile.serverInfo serverDateFormatFormatter];
    
    JSContentResource *expectedObject = [JSContentResource new];
    expectedObject.label            = [self.jsonObject valueForKey:@"label"];
    expectedObject.uri              = [self.jsonObject valueForKey:@"uri"];
    expectedObject.resourceDescription= [self.jsonObject valueForKey:@"description"];
    expectedObject.resourceType     = [self.jsonObject valueForKey:@"resourceType"];
    expectedObject.version          = [self.jsonObject valueForKey:@"version"];
    expectedObject.permissionMask   = [self.jsonObject valueForKey:@"permissionMask"];
    expectedObject.creationDate     = [formatter dateFromString:[self.jsonObject valueForKey:@"creationDate"]];
    expectedObject.updateDate       = [formatter dateFromString:[self.jsonObject valueForKey:@"updateDate"]];

    expectedObject.fileFormat       = [self.jsonObject valueForKey:@"type"];
    expectedObject.content          = [self.jsonObject valueForKey:@"content"];

    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testRequestObjectKeyPath {
    XCTAssertEqual([JSContentResource requestObjectKeyPath], @"contentResource");
}

- (void)testNSSecureCodingProtocolSupport {
    XCTAssertFalse([JSContentResource instancesRespondToSelector:@selector(supportsSecureCoding)], @"NSSecureCoding Protocol not supported");
    XCTAssertTrue([JSContentResource supportsSecureCoding], @"NSSecureCoding not used");
}

- (void)testNSCodingProtocolSupport {
    JSContentResource *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    NSData *codedData = [NSKeyedArchiver archivedDataWithRootObject:mappedObject];
    JSContentResource *encodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:codedData];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:encodedObject];
}

- (void)testNSCopyingProtocolSupport {
    JSContentResource *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSContentResource *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}

@end
