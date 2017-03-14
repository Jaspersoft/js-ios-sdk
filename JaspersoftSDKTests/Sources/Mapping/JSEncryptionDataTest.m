/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSEncryptionData.h"

@interface JSEncryptionDataTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;

@end

@implementation JSEncryptionDataTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSEncryptionData class]];
    self.mapping = [JSEncryptionData objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping
{
    JSEncryptionData *expectedObject = [JSEncryptionData new];
    expectedObject.modulus      = [self.jsonObject valueForKey:@"n"];
    expectedObject.exponent     = [self.jsonObject valueForKey:@"e"];
    expectedObject.maxdigits    = [self.jsonObject valueForKey:@"maxdigits"];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}
@end
