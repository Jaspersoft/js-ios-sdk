/*
 * Copyright © 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSSSOProfile.h"
#import "KeychainItemWrapper.h"

NSString * const kJSProfileSSOTokenKeyDefaultValue  = @"ticket";
NSString * const kJSSavedProfileSSOTokenFieldKey    = @"kJSSavedProfileSSOTokenFieldKey";


@interface JSSSOProfile ()
@property (nonatomic, readwrite, nullable) NSString *ssoToken;
@end

@implementation JSSSOProfile
- (nonnull instancetype)initWithAlias:(nonnull NSString *)alias serverUrl:(nonnull NSString *)serverUrl ssoToken:(nullable NSString *)ssoToken {
    if (self = [super initWithAlias:alias serverUrl:serverUrl]) {
        _ssoToken = ssoToken;
        _ssoTokenField = kJSProfileSSOTokenKeyDefaultValue;
    }
    return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    JSSSOProfile *copiedProfile = [super copyWithZone:zone];
    copiedProfile.ssoToken = [self.ssoToken copyWithZone:zone];
    copiedProfile.ssoTokenField = [self.ssoTokenField copyWithZone:zone];
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
    [wrapper setObject:self.ssoToken forKey:(__bridge id)kSecAttrAccount];
    
    [aCoder encodeObject:self.ssoTokenField forKey:kJSSavedProfileSSOTokenFieldKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Restore ssoToken from Keychain
        KeychainItemWrapper *wrapper;
        @try {
            wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[JSUtils keychainIdentifier] accessGroup:nil];
            _ssoToken = (NSString *)[wrapper objectForKey:(__bridge id)kSecAttrAccount];
        }
        @catch (NSException *exception) {
            NSLog(@"\nException name: %@\nException reason: %@", exception.name, exception.reason);
            return nil;
        }
        _ssoTokenField = [aDecoder decodeObjectForKey:kJSSavedProfileSSOTokenFieldKey];
    }
    return ([self.ssoToken length] > 0 && [self.ssoToken length] > 0) ? self : nil;
}
@end
