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
//  JSDateFormatterFactory.m
//  TIBCO JasperMobile
//

#import "JSDateFormatterFactory.h"

@interface JSDateFormatterFactory()
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSDateFormatter *> *formatters;
@end

@implementation JSDateFormatterFactory

+ (instancetype)sharedFactory {
    static JSDateFormatterFactory *sharedFactory;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedFactory = [JSDateFormatterFactory new];
    });
    return sharedFactory;
}

- (NSDateFormatter *)formatterWithPattern:(NSString *)pattern
{
    NSDateFormatter *formatter = [self formatterWithPattern:pattern timeZone:nil];
    return formatter;
}

- (NSDateFormatter *)formatterWithPattern:(NSString *)pattern timeZone:(NSTimeZone *)timeZone
{
    NSDateFormatter *formatter = self.formatters[pattern];
    if (!formatter) {
        formatter = [self createFormatterWithPattern:pattern timeZone:timeZone];
        self.formatters[pattern] = formatter;
    }
    return formatter;
}

#pragma mark - Helpers
- (NSDateFormatter *)createFormatterWithPattern:(NSString *)pattern timeZone:(NSTimeZone *)timeZone
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    if (timezone) {
        formatter.timeZone = timeZone;
    }
    formatter.dateFormat = pattern;
    return formatter;
}

@end