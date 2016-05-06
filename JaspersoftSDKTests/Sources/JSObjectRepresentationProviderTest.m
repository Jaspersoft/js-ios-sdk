//
//  JSObjectRepresentationProviderTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 5/6/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

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
