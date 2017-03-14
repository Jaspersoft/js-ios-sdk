/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "NSString+JSURLEncodings.h"

@implementation NSString(JSURLEncodings)

- (nonnull NSString *)hostEncodedString {
    NSArray *components = [self componentsSeparatedByString:@"/"];
    NSMutableArray *encodedComponentsArray = [NSMutableArray array];
    for (NSString *component in components) {
        [encodedComponentsArray addObject:[component encodedStringWithCharSet:[NSCharacterSet URLHostAllowedCharacterSet]]];
    }
    return [encodedComponentsArray componentsJoinedByString:@"/"];
}

- (nonnull NSString *)queryEncodedString {
    return [self encodedStringWithCharSet:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)encodedStringWithCharSet:(NSCharacterSet *)characterSet {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
}

@end
