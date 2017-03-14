/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSResourceLookup.h"
#import "JSServerInfo.h"
#import "EKMapper.h"


@interface JSResourceLookupTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSResourceLookupTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSResourceLookup class]];
    self.mapping = [JSResourceLookup objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSProfile *serverProfile = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN];
    NSDateFormatter *formatter = [serverProfile.serverInfo serverDateFormatFormatter];
    
    JSResourceLookup *expectedObject = [JSResourceLookup new];
    expectedObject.label            = [self.jsonObject valueForKey:@"label"];
    expectedObject.uri              = [self.jsonObject valueForKey:@"uri"];
    expectedObject.resourceDescription= [self.jsonObject valueForKey:@"description"];
    expectedObject.resourceType     = [self.jsonObject valueForKey:@"resourceType"];
    expectedObject.version          = [self.jsonObject valueForKey:@"version"];
    expectedObject.permissionMask   = [self.jsonObject valueForKey:@"permissionMask"];
    expectedObject.creationDate     = [formatter dateFromString:[self.jsonObject valueForKey:@"creationDate"]];
    expectedObject.updateDate       = [formatter dateFromString:[self.jsonObject valueForKey:@"updateDate"]];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testRequestObjectKeyPath {
    XCTAssertEqual([JSResourceLookup requestObjectKeyPath], @"resourceLookup");
}

- (void)testNSSecureCodingProtocolSupport {
    XCTAssertFalse([JSResourceLookup instancesRespondToSelector:@selector(supportsSecureCoding)], @"NSSecureCoding Protocol not supported");
    XCTAssertTrue([JSResourceLookup supportsSecureCoding], @"NSSecureCoding not used");
}

- (void)testNSCodingProtocolSupport {
    JSResourceLookup *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    NSData *codedData = [NSKeyedArchiver archivedDataWithRootObject:mappedObject];
    JSResourceLookup *encodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:codedData];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:encodedObject];
}

- (void)testNSCopyingProtocolSupport {
    JSResourceLookup *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSResourceLookup *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}

@end
