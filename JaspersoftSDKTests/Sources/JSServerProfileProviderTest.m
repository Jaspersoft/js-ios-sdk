//
//  JSServerProfileProviderTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/6/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSServerInfo.h"
@interface JSServerProfileProviderTest : XCTestCase

@end

@implementation JSServerProfileProviderTest

- (void)testUserServerProfileWithVersion {
    float serverVersion = kJS_SERVER_VERSION_CODE_JADE_6_2_0;
    
    JSUserProfile *serverProfile = [JSServerProfileProvider serverProfileWithVersion:serverVersion];
    XCTAssertNotNil(serverProfile.alias);
    XCTAssertNotNil(serverProfile.username);
    XCTAssertNotNil(serverProfile.password);
    XCTAssertNotNil(serverProfile.organization);
    XCTAssertNotNil(serverProfile.serverUrl);

    XCTAssertNotNil(serverProfile.serverInfo.build);
    XCTAssertNotNil(serverProfile.serverInfo.edition);
    XCTAssertNotNil(serverProfile.serverInfo.editionName);
    XCTAssertNotNil(serverProfile.serverInfo.expiration);
    XCTAssertNotNil(serverProfile.serverInfo.features);
    XCTAssertNotNil(serverProfile.serverInfo.licenseType);
    XCTAssertNotNil(serverProfile.serverInfo.version);
    XCTAssertNotNil(serverProfile.serverInfo.dateFormatPattern);
    XCTAssertNotNil(serverProfile.serverInfo.datetimeFormatPattern);
    
    XCTAssertEqual(serverProfile.serverInfo.versionAsFloat, serverVersion);
}

@end
