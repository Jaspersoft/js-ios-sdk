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
#import "JSConstants.h"
#import "KeychainItemWrapper.h"

NSString * const kJSSavedProfileAliasKey        = @"JSSavedSessionKey";
NSString * const kJSSavedProfileServerUrlKey    = @"JSSavedProfileServerUrlKey";
NSString * const kJSSavedProfileUsernameKey     = @"JSSavedProfileUsernameKey";
NSString * const kJSSavedProfilePasswordKey     = @"JSSavedProfilePasswordKey";
NSString * const kJSSavedProfileOrganisationKey = @"JSSavedProfileOrganisationKey";
NSString * const kJSSavedProfileServerInfoKey   = @"JSSavedProfileServerInfoKey";


@implementation JSProfile


- (id)initWithAlias:(NSString *)alias serverUrl:(NSString *)serverUrl organization:(NSString *)organization
           username:(NSString *)username password:(NSString *)password {
    if (self = [super init]) {
        _alias = alias;
        _organization = organization;
        _serverUrl = (([serverUrl characterAtIndex:serverUrl.length - 1] == '/') ? [serverUrl substringToIndex:serverUrl.length - 1] : serverUrl).lowercaseString;
        _username = username;
        _password = password;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSProfile *copiedProfile = [[JSProfile allocWithZone:zone] initWithAlias:self.alias
                                                                   serverUrl:self.serverUrl
                                                                organization:self.organization
                                                                    username:self.username
                                                                    password:self.password];
    return copiedProfile;
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // Store username and password in Keychain
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[JSConstants keychainIdentifier] accessGroup:nil];
    [wrapper setObject:_username forKey:(__bridge id)kSecAttrAccount];
    [wrapper setObject:_password forKey:(__bridge id)kSecValueData];

    [aCoder encodeObject:_alias forKey:kJSSavedProfileAliasKey];
    [aCoder encodeObject:_serverUrl forKey:kJSSavedProfileServerUrlKey];
    [aCoder encodeObject:_organization forKey:kJSSavedProfileOrganisationKey];
    [aCoder encodeObject:_serverInfo forKey:kJSSavedProfileServerInfoKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        // Restore username and password in Keychain
        KeychainItemWrapper *wrapper;
        @try {
            wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[JSConstants keychainIdentifier] accessGroup:nil];
            _username = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
            _password = [wrapper objectForKey:(__bridge id)kSecValueData];
        }
        @catch (NSException *exception) {
            NSLog(@"\nException name: %@\nException reason: %@", exception.name, exception.reason);
            return nil;
        }
        
        _alias = [aDecoder decodeObjectForKey:kJSSavedProfileAliasKey];
        _serverUrl = [aDecoder decodeObjectForKey:kJSSavedProfileServerUrlKey];
        _password = [aDecoder decodeObjectForKey:kJSSavedProfilePasswordKey];
        _organization = [aDecoder decodeObjectForKey:kJSSavedProfileOrganisationKey];
        _serverInfo = [aDecoder decodeObjectForKey:kJSSavedProfileServerInfoKey];
    }
    return ([self.username length] > 0 && [self.password length] > 0) ? self : nil;
}
@end
