/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <XCTest/XCTest.h>
#import "JSDateFormatterFactory.h"
#import "JSServerInfo.h"

@interface JSDateFormatterFactoryTest : XCTestCase

@end

@implementation JSDateFormatterFactoryTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testDateFormatterFactory {
    XCTAssertNotNil([JSDateFormatterFactory sharedFactory]);
    XCTAssertEqual([JSDateFormatterFactory sharedFactory], [JSDateFormatterFactory sharedFactory]);
    
    JSServerInfo *serverInfo = [JSServerProfileProvider serverProfileWithVersion:kJS_SERVER_VERSION_CODE_UNKNOWN].serverInfo;
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    
    NSDateFormatter *formatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:serverInfo.datetimeFormatPattern];
    XCTAssertNotNil(formatter);
    XCTAssertEqual(formatter, [[JSDateFormatterFactory sharedFactory] formatterWithPattern:serverInfo.datetimeFormatPattern]);

    NSDateFormatter *timeZoneFormatter = [[JSDateFormatterFactory sharedFactory] formatterWithPattern:serverInfo.datetimeFormatPattern timeZone:currentTimeZone];
    XCTAssertNotNil(timeZoneFormatter);
    XCTAssertEqual(timeZoneFormatter, [[JSDateFormatterFactory sharedFactory] formatterWithPattern:serverInfo.datetimeFormatPattern timeZone:currentTimeZone]);

    NSDate *currentDate = [NSDate date];
    NSString *dateString = [formatter stringFromDate:currentDate];
    XCTAssertNotNil(dateString);
    NSDate *currentDateFromString = [formatter dateFromString:dateString];
    XCTAssertNotNil(currentDateFromString);

    BOOL comparisionResult = floor([currentDate timeIntervalSince1970]) == floor([currentDateFromString timeIntervalSince1970]);
    XCTAssertTrue(comparisionResult);
}

@end
