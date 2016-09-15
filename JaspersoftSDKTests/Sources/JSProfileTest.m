//
//  JSProfileTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 4/29/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSProfile.h"
#import "JSServerInfo.h"

@interface JSProfileTest : XCTestCase

@end

@implementation JSProfileTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testInit {
    JSProfile *serverProfile = [[JSProfile alloc] initWithAlias:kJSTestProfileName serverUrl:kJSTestProfileUrl organization:kJSTestProfileOrganization username:kJSTestProfileUsername password:kJSTestProfilePassword];
    XCTAssertEqualObjects(serverProfile.alias, kJSTestProfileName);
    XCTAssertEqualObjects(serverProfile.serverUrl, kJSTestProfileUrl);
    XCTAssertEqualObjects(serverProfile.username, kJSTestProfileUsername);
    XCTAssertEqualObjects(serverProfile.password, kJSTestProfilePassword);
    XCTAssertEqualObjects(serverProfile.organization, kJSTestProfileOrganization);
}

- (void)testNSSecureCodingProtocolSupport {
    XCTAssertFalse([JSProfile instancesRespondToSelector:@selector(supportsSecureCoding)], @"NSSecureCoding Protocol not supported");
    XCTAssertTrue([JSProfile supportsSecureCoding], @"NSSecureCoding not used");
}

- (void)testNSCodingProtocolSupport {
    NSInteger currentSystemVersion = [UIDevice currentDevice].systemVersion.integerValue;
    
    // Here we need check system version and run this code for old system versions only, because in iOS 10 keychain is available only after adding such capability in target settings
    if (currentSystemVersion < 10) {
        JSProfile *profile = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN];
        NSData *codedData = [NSKeyedArchiver archivedDataWithRootObject:profile];
        JSProfile *encodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:codedData];
        
        [self isEqualProfile:profile toProfile:encodedObject];
    }
}

- (void)testNSCopyingProtocolSupport {
    JSProfile *profile = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN];
    JSProfile *copiedObject = [profile copy];
    
    [self isEqualProfile:profile toProfile:copiedObject];
}

- (void)testIsEqualProfileToProfile {
    JSProfile *profile = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN];
    JSProfile *copiedObject = [profile copy];
    
    [self isEqualProfile:profile toProfile:profile];
    [self isEqualProfile:profile toProfile:copiedObject];
}

#pragma mark - Helper
- (void)isEqualProfile:(JSProfile *)profile toProfile:(JSProfile *)otherProfile {
    XCTAssertTrue([profile isKindOfClass:[otherProfile class]]);

    if (profile == otherProfile) {
        return;
    }
    
    XCTAssertEqualObjects(profile.alias, otherProfile.alias);
    XCTAssertEqualObjects(profile.serverUrl, otherProfile.serverUrl);
    XCTAssertEqualObjects(profile.username, otherProfile.username);
    XCTAssertEqualObjects(profile.password, otherProfile.password);
    XCTAssertEqualObjects(profile.organization, otherProfile.organization);
    
    XCTAssertEqualObjects(profile.serverInfo.build, otherProfile.serverInfo.build);
    XCTAssertEqualObjects(profile.serverInfo.edition, otherProfile.serverInfo.edition);
    XCTAssertEqualObjects(profile.serverInfo.editionName, otherProfile.serverInfo.editionName);
    XCTAssertEqualObjects(profile.serverInfo.expiration, otherProfile.serverInfo.expiration);
    XCTAssertEqualObjects(profile.serverInfo.features, otherProfile.serverInfo.features);
    XCTAssertEqualObjects(profile.serverInfo.licenseType, otherProfile.serverInfo.licenseType);
    XCTAssertEqualObjects(profile.serverInfo.version, otherProfile.serverInfo.version);
    XCTAssertEqualObjects(profile.serverInfo.dateFormatPattern, otherProfile.serverInfo.dateFormatPattern);
    XCTAssertEqualObjects(profile.serverInfo.datetimeFormatPattern, otherProfile.serverInfo.datetimeFormatPattern);
}

@end
