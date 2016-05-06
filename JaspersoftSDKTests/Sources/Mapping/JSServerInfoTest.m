//
//  JSServerInfoMappingTest.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 4/27/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSServerInfo.h"
#import "EKMapper.h"


@interface JSServerInfoTest : XCTestCase
@property (nonatomic, strong) id jsonObject;
@property (nonatomic, strong) EKObjectMapping *mapping;
@end

@implementation JSServerInfoTest

- (void)setUp {
    [super setUp];
    self.jsonObject = [JSObjectRepresentationProvider JSONObjectForClass:[JSServerInfo class]];
    self.mapping = [JSServerInfo objectMappingForServerProfile:[JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN]];
}

- (void)testObjectMapping {
    JSServerInfo *expectedObject = [JSServerInfo new];
    expectedObject.build            = [self.jsonObject valueForKey:@"build"];
    expectedObject.edition          = [self.jsonObject valueForKey:@"edition"];
    expectedObject.editionName      = [self.jsonObject valueForKey:@"editionName"];
    expectedObject.expiration       = [self.jsonObject valueForKey:@"expiration"];
    expectedObject.features         = [self.jsonObject valueForKey:@"features"];
    expectedObject.licenseType      = [self.jsonObject valueForKey:@"licenseType"];
    expectedObject.version          = [self.jsonObject valueForKey:@"version"];
    expectedObject.dateFormatPattern = [self.jsonObject valueForKey:@"dateFormatPattern"];
    expectedObject.datetimeFormatPattern = [self.jsonObject valueForKey:@"datetimeFormatPattern"];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:expectedObject];
}

- (void)testVersionAsFloat {
    JSServerInfo *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];

    float expectedVersion = [self stringToFloat:[self.jsonObject objectForKey:@"version"]];
    XCTAssertEqual(expectedVersion, [mappedObject versionAsFloat], @"Version incorrect converted to float!");
}

- (void)testSetverDataFormatter {
    JSServerInfo *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    NSDateFormatter *formatter = [mappedObject serverDateFormatFormatter];
    XCTAssertEqual(formatter.dateFormat, [self.jsonObject valueForKey:@"datetimeFormatPattern"], @"Server date formatter incorrect initialized!");
}

- (void)testNSSecureCodingProtocolSupport {
    XCTAssertFalse([JSServerInfo instancesRespondToSelector:@selector(supportsSecureCoding)], @"NSSecureCoding Protocol not supported");
    XCTAssertTrue([JSServerInfo supportsSecureCoding], @"NSSecureCoding not used");
}

- (void)testNSCodingProtocolSupport {
    JSServerInfo *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    NSData *codedData = [NSKeyedArchiver archivedDataWithRootObject:mappedObject];
    JSServerInfo *encodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:codedData];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:encodedObject];
}

- (void)testNSCopyingProtocolSupport {
    JSServerInfo *mappedObject = [EKMapper objectFromExternalRepresentation:self.jsonObject withMapping:self.mapping];
    JSServerInfo *copiedObject = [mappedObject copy];
    
    [self testObjectFromExternalRepresentation:self.jsonObject withMapping:self.mapping expectedObject:copiedObject];
}

#pragma mark - Helper Methods
- (float) stringToFloat:(NSString *)string {
    NSArray *components = [string componentsSeparatedByString:@"."];
    if ([components count] > 2) {
        NSIndexSet *floatStringIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, components.count - 1)];
        NSString *floatString = [[components objectsAtIndexes:floatStringIndexSet] componentsJoinedByString:@""];
        string = [NSString stringWithFormat:@"%@.%@", components[0], floatString];
    }
    return [string floatValue];
}

@end
