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
//  JSProfile.m
//  Jaspersoft Corporation
//

#import "JSProfile.h"

@implementation JSProfile

@synthesize alias = _alias;
@synthesize serverUrl = _serverUrl;
@synthesize username = _username;
@synthesize password = _password;
@synthesize organization = _organization;
@synthesize serverInfo = _serverInfo;

- (id)initWithAlias:(NSString *)alias serverUrl:(NSString *)serverUrl organization:(NSString *)organization {
    if (self = [super init]) {
        _alias = alias;
        _organization = organization;
        _serverUrl = serverUrl;
    }
    return self;
}

- (void)setServerUrl:(NSString *)serverUrl {
    _serverUrl = ([serverUrl characterAtIndex:serverUrl.length - 1] == '/') ? [serverUrl substringToIndex:serverUrl.length - 1] : serverUrl;
}

- (NSString *)getUsernameWithOrganization {
    if ([self.organization length] != 0) {
        return [NSString stringWithFormat:@"%@|%@", self.username, self.organization];
    }
    
    return self.username;
}

- (void)setCredentialsWithUsername:(NSString *)username password:(NSString *)password
{
    _username = username;
    _password = password;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSProfile *copiedProfile = [[JSProfile allocWithZone:zone] initWithAlias:self.alias 
                                                                    serverUrl:self.serverUrl
                                                                organization:self.organization];
    return copiedProfile;
}

@end
