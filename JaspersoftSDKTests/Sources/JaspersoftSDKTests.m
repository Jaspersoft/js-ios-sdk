//
//  JaspersoftSDKTests.m
//  JaspersoftSDKTests
//
//  Created by Oleksii Gubariev on 4/26/16.
//
//

#import <XCTest/XCTest.h>
#import "JSRESTBase+JSRESTSession.h"
#import "JSPAProfile.h"

#import "JSContentResource.h"

@interface JaspersoftSDKTests : XCTestCase

@end

@implementation JaspersoftSDKTests

- (void)testAFNetworkingInstalled {
    XCTAssertNotNil(NSClassFromString(@"AFHTTPSessionManager"), @"AFNetworking not installed");
}

- (void)testEasyMappingInstalled {
    XCTAssertNotNil(NSClassFromString(@"EKMapper"), @"EasyMapping not installed");
}

- (void)testCorrectPAauthorization {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Pre- authentication"];
    
    NSString *ppToken = @"u=Steve|r=Ext_User|o=organization_1";
    
    JSPAProfile *serverProfile = [[JSPAProfile alloc] initWithAlias:kJSTestProfileName serverUrl:kJSTestProfileUrl ppToken:ppToken];
    
    JSRESTBase *restClient = [[JSRESTBase alloc] initWithServerProfile:serverProfile];
    [restClient verifyIsSessionAuthorizedWithCompletion:^(JSOperationResult * _Nullable result) {
        XCTAssertNil(result.error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:120.0 handler:nil];
}

- (void)testInCorrectPAauthorization {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Pre- authentication"];
    
    NSString *ppToken = @"un=Steve|r=Ext_User";
    
    JSPAProfile *serverProfile = [[JSPAProfile alloc] initWithAlias:kJSTestProfileName serverUrl:kJSTestProfileUrl ppToken:ppToken];
    
    JSRESTBase *restClient = [[JSRESTBase alloc] initWithServerProfile:serverProfile];
    [restClient verifyIsSessionAuthorizedWithCompletion:^(JSOperationResult * _Nullable result) {
        XCTAssertNotNil(result.error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:120 handler:nil];
}

@end
