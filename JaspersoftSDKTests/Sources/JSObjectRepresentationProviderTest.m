/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSServerInfo.h"
#import "JSRESTBase.h"

@interface JSObjectRepresentationProviderTest : XCTestCase

@end

@implementation JSObjectRepresentationProviderTest

- (void)testJSONObjectForSupportedClass{
    id jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSServerInfo class]];
    XCTAssertNotNil(jsonObject);
}

//- (void)testJSONObjectForNotSupportedClass{
//    id jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSRESTBase class]];
//    XCTAssertNotNil(jsonObject);
//}

@end
