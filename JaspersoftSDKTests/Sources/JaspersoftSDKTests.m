//
//  JaspersoftSDKTests.m
//  JaspersoftSDKTests
//
//  Created by Oleksii Gubariev on 4/26/16.
//
//

#import <XCTest/XCTest.h>

@interface JaspersoftSDKTests : XCTestCase

@end

@implementation JaspersoftSDKTests

- (void)testAFNetworkingInstalled {
    XCTAssertNotNil(NSClassFromString(@"AFHTTPSessionManager"), @"AFNetworking not installed");
}

- (void)testEasyMappingInstalled {
    XCTAssertNotNil(NSClassFromString(@"EKMapper"), @"EasyMapping not installed");
}

@end
