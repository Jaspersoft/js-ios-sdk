/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2013 Jaspersoft Corporation. All rights reserved.
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
//  JSServerInfo.m
//  Jaspersoft Corporation
//

#import "JSServerInfo.h"

@implementation JSServerInfo

@synthesize build = _build;
@synthesize edition = _edition;
@synthesize editionName = _editionName;
@synthesize expiration = _expiration;
@synthesize features = _features;
@synthesize licenseType = _licenseType;
@synthesize version = _version;

- (NSInteger)versionAsInteger {
    NSInteger intVersion = 0;
    
    if (self.version) {
        NSArray *numbers = [self.version componentsSeparatedByString:@"."];
        for (NSInteger i = 0; i < numbers.count; i++) {
            NSInteger exp = (numbers.count - 1 - i) * 2;
            intVersion += [[numbers objectAtIndex:i] integerValue] * pow(10, exp);
        }
    }
    
    return intVersion;
}

@end
