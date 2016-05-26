/*
 * TIBCO JasperMobile for iOS
 * Copyright © 2005-2016 TIBCO Software, Inc. All rights reserved.
 * http://community.jaspersoft.com/project/jaspermobile-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/lgpl>.
 */


//
//  NSString(JSURLEncodings).m
//  TIBCO JasperMobile
//

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
