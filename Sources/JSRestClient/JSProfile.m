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
#import "JSServerInfo.h"

NSString * const kJSSavedProfileAliasKey        = @"JSSavedSessionKey";
NSString * const kJSSavedProfileServerUrlKey    = @"JSSavedProfileServerUrlKey";
NSString * const kJSSavedProfileServerInfoKey   = @"JSSavedProfileServerInfoKey";
NSString * const kJSSavedProfileKeepSessionKey  = @"JSSavedProfileKeepSessionKey";


@implementation JSProfile
- (nonnull instancetype)initWithAlias:(nonnull NSString *)alias serverUrl:(nonnull NSString *)serverUrl {
    if (self = [super init]) {
        _alias = alias;
        _serverUrl = (([serverUrl characterAtIndex:serverUrl.length - 1] == '/') ? [serverUrl substringToIndex:serverUrl.length - 1] : serverUrl).lowercaseString;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSProfile *copiedProfile = [[[self class] allocWithZone:zone] initWithAlias:self.alias
                                                                      serverUrl:self.serverUrl];
    copiedProfile.serverInfo = [self.serverInfo copyWithZone:zone];
    copiedProfile.keepSession = self.keepSession;
    return copiedProfile;
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_alias forKey:kJSSavedProfileAliasKey];
    [aCoder encodeObject:_serverUrl forKey:kJSSavedProfileServerUrlKey];
    [aCoder encodeObject:_serverInfo forKey:kJSSavedProfileServerInfoKey];
    [aCoder encodeBool:_keepSession forKey:kJSSavedProfileKeepSessionKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _alias = [aDecoder decodeObjectForKey:kJSSavedProfileAliasKey];
        _serverUrl = [aDecoder decodeObjectForKey:kJSSavedProfileServerUrlKey];
        _serverInfo = [aDecoder decodeObjectForKey:kJSSavedProfileServerInfoKey];
        _keepSession = [aDecoder decodeBoolForKey:kJSSavedProfileKeepSessionKey];
    }
    return self;
}
@end
