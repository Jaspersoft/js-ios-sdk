/*
 * Copyright © 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


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
