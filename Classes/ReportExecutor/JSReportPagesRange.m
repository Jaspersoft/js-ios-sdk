/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2014 Jaspersoft Corporation. All rights reserved.
 * http://community.jaspersoft.com/project/mobile-sdk-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is part of Jaspersoft Mobile SDK for iOS.
 *
 * Jaspersoft Mobile SDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Jaspersoft Mobile SDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Jaspersoft Mobile SDK for iOS. If not, see
 * <http://www.gnu.org/licenses/lgpl>.
 */

//
//  JSReportPagesRange.m
//  Jaspersoft Corporation
//

#import "JSReportPagesRange.h"

@implementation JSReportPagesRange

#pragma mark - Initializers

+ (instancetype)rangeWithStartPage:(NSUInteger)startPage endPage:(NSUInteger)endPage {
    return [[self alloc] initWithStartPage:startPage endPage:endPage];
}

- (instancetype)initWithStartPage:(NSUInteger)startPage endPage:(NSUInteger)endPage {
    self = [super init];
    if (self) {
        _startPage = startPage;
        _endPage = endPage;
    }
    return self;
}

+ (instancetype)allPagesRange {
    return [self rangeWithStartPage:0 endPage:NSNotFound];
}

- (BOOL) isAllPagesRange {
    return (self.startPage == 0 && self.endPage == NSNotFound);
}

#pragma mark - Custom Getters
- (NSString *)formattedPagesRange {
    if(self.startPage == 0) {
        return @"";
    } else if (self.startPage == self.endPage) {
        return [NSString stringWithFormat:@"%@", @(self.startPage)];
    }

    return [NSString stringWithFormat:@"%@-%@", @(self.startPage), @(self.endPage)];
}

#pragma mark - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"PagesRange from: %@, to: %@", @(self.startPage), @(self.endPage)];
}

@end