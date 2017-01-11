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
//  JSPAProfile.m
//  Jaspersoft Corporation
//

#import "JSPAProfile.h"
#import "KeychainItemWrapper.h"

NSString * const kJSProfilePPTokenKeyDefaultValue  = @"pp";
NSString * const kJSSavedProfilePPTokenFieldKey    = @"JSSavedProfilePPTokenFieldKey";


@interface JSPAProfile ()
@property (nonatomic, readwrite, nullable) NSString *ppToken;
@end

@implementation JSPAProfile
- (nonnull instancetype)initWithAlias:(nonnull NSString *)alias serverUrl:(nonnull NSString *)serverUrl ppToken:(nullable NSString *)ppToken {
    if (self = [super initWithAlias:alias serverUrl:serverUrl]) {
        _ppToken = ppToken;
        _ppTokenField = kJSProfilePPTokenKeyDefaultValue;
    }
    return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    JSPAProfile *copiedProfile = [super copyWithZone:zone];
    copiedProfile.ppToken = [self.ppToken copyWithZone:zone];
    copiedProfile.ppTokenField = [self.ppTokenField copyWithZone:zone];
    return copiedProfile;
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    // Store ssoToken in Keychain
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[JSUtils keychainIdentifier] accessGroup:nil];
    [wrapper setObject:self.ppToken forKey:(__bridge id)kSecAttrAccount];
    
    [aCoder encodeObject:self.ppTokenField forKey:kJSSavedProfilePPTokenFieldKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Restore ssoToken from Keychain
        KeychainItemWrapper *wrapper;
        @try {
            wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[JSUtils keychainIdentifier] accessGroup:nil];
            _ppToken = (NSString *)[wrapper objectForKey:(__bridge id)kSecAttrAccount];
        }
        @catch (NSException *exception) {
            NSLog(@"\nException name: %@\nException reason: %@", exception.name, exception.reason);
            return nil;
        }
        _ppTokenField = [aDecoder decodeObjectForKey:kJSSavedProfilePPTokenFieldKey];
    }
    return ([self.ppToken length] > 0 && [self.ppToken length] > 0) ? self : nil;
}
@end
