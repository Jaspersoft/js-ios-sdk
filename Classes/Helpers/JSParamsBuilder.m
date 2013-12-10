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
//  JSParamsBuilder.m
//  Jaspersoft Corporation
//

#import "JSParamsBuilder.h"

@interface JSParamsBuilder()
@property (nonatomic, retain) NSMutableDictionary *parameters;
@end

@implementation JSParamsBuilder

@synthesize parameters = _parameters;

- (id)init {
    if (self = [super init]) {
        self.parameters = [NSMutableDictionary dictionary];
    }
    return self;
}

- (JSParamsBuilder *)addParameter:(NSString *)parameter withStringValue:(NSString *)value {
    if (value && value.length) {
        [self.parameters setObject:value forKey:parameter];
    }
    return self;
}

- (JSParamsBuilder *)addParameter:(NSString *)parameter withIntegerValue:(NSInteger)value {
    if (value > 0) {
        [self.parameters setObject:[NSNumber numberWithInteger:value] forKey:parameter];
    }
    return self;
}

- (JSParamsBuilder *)addParameter:(NSString *)parameter withArrayValue:(NSArray *)value {
    if (value && value.count) {
        [self.parameters setObject:value forKey:parameter];
    }
    return self;
}

- (NSDictionary *)params {
    return self.parameters;
}

@end
