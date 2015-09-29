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
//  JSRequest.m
//  Jaspersoft Corporation
//

#import "JSRequest.h"

@interface JSRequest()
@property (nonatomic, retain) NSMutableDictionary *parameters;
@end

@implementation JSRequest

- (nonnull instancetype)initWithUri:(nonnull NSString *)uri {
    if (self = [super init]) {
        self.uri = uri;
        self.method = RKRequestMethodGET;
        self.responseAsObjects = YES;
        self.asynchronous = YES;
        self.restVersion = JSRESTVersion_1;
        self.parameters = [NSMutableDictionary dictionary];
        self.redirectAllowed = YES;
    }
    
    return self;
}

- (void)addParameter:(nonnull NSString *)parameter withStringValue:(nonnull NSString *)value {
    if (value.length) {
        [self.parameters setObject:value forKey:parameter];
    }
}

- (void)addParameter:(nonnull NSString *)parameter withIntegerValue:(NSInteger)value {
    [self.parameters setObject:[NSNumber numberWithInteger:value] forKey:parameter];
}

- (void)addParameter:(nonnull NSString *)parameter withArrayValue:(nonnull NSArray *)value {
    if (value) {
        [self.parameters setObject:value forKey:parameter];
    }
}

- (NSDictionary *)params {
    if (self.method == RKRequestMethodGET || self.method == RKRequestMethodHEAD || self.method == RKRequestMethodDELETE) {
        NSMutableDictionary *paramsDictionary = [NSMutableDictionary dictionary];
        for (NSString *key in self.parameters) {
            id value = [self.parameters objectForKey:key];
            if ([value isKindOfClass:[NSArray class]]) {
                value = [NSSet setWithArray:value];
            }
            [paramsDictionary setObject:value forKey:key];
        }
        return [NSDictionary dictionaryWithDictionary:paramsDictionary];
    }
    return [NSDictionary dictionaryWithDictionary:self.parameters];
}

@end
