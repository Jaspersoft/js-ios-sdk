/*
 * Copyright © 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSUserProfile.h"
#import "KeychainItemWrapper.h"

#if __has_include("JSSecurity.h")
#import "JSSecurity.h"
#endif


NSString * const kJSSavedProfileUsernameKey     = @"JSSavedProfileUsernameKey";
NSString * const kJSSavedProfilePasswordKey     = @"JSSavedProfilePasswordKey";
NSString * const kJSSavedProfileOrganisationKey = @"JSSavedProfileOrganisationKey";

@interface JSUserProfile ()
@property (nonatomic, readwrite, nullable) NSString *username;
@property (nonatomic, readwrite, nullable) NSString *password;
@property (nonatomic, readwrite, nullable) NSString *organization;

@end

@implementation JSUserProfile
- (nonnull instancetype)initWithAlias:(nonnull NSString *)alias serverUrl:(nonnull NSString *)serverUrl organization:(nullable NSString *)organization
                             username:(nullable nullable NSString *)username password:(nullable NSString *)password {
    if (self = [super initWithAlias:alias serverUrl:serverUrl]) {
        _organization = organization;
        _username = username;
        _password = password;
    }
    return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    JSUserProfile *copiedProfile = [super copyWithZone:zone];
    copiedProfile.username = [self.username copyWithZone:zone];
    copiedProfile.organization = [self.organization copyWithZone:zone];
    copiedProfile.password = [self.password copyWithZone:zone];
    return copiedProfile;
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    NSString *encryptedUsername = _username;
    NSString *encryptedPassword = _password;
    
    
#if __has_include("JSSecurity.h")
    JSEncryptionManager *encryptionManager = [JSEncryptionManager new];
    encryptedUsername = [encryptionManager encryptText:_username withKey:[NSString stringWithFormat:@"%@.%@", kJSSavedProfileUsernameKey, self.alias]];
    encryptedPassword = [encryptionManager encryptText:_password withKey:[NSString stringWithFormat:@"%@.%@", kJSSavedProfilePasswordKey, self.alias]];
#endif
    
    // Store username and password in Keychain
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[JSUtils keychainIdentifier] accessGroup:nil];
    [wrapper setObject:encryptedUsername forKey:(__bridge id)kSecAttrAccount];
    [wrapper setObject:encryptedPassword forKey:(__bridge id)kSecValueData];
    
    [aCoder encodeObject:_organization forKey:kJSSavedProfileOrganisationKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _organization = [aDecoder decodeObjectForKey:kJSSavedProfileOrganisationKey];
        
        // Restore username and password from Keychain
        KeychainItemWrapper *wrapper;
        @try {
            wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[JSUtils keychainIdentifier] accessGroup:nil];
#if __has_include("JSSecurity.h")
            JSEncryptionManager *encryptionManager = [JSEncryptionManager new];
            _username = [encryptionManager decryptText:[wrapper objectForKey:(__bridge id)kSecAttrAccount]
                                               withKey:[NSString stringWithFormat:@"%@.%@", kJSSavedProfileUsernameKey, self.alias]];
            _password = [encryptionManager decryptText:[wrapper objectForKey:(__bridge id)kSecValueData]
                                               withKey:[NSString stringWithFormat:@"%@.%@", kJSSavedProfilePasswordKey, self.alias]];
#else
            _username = (NSString *)[wrapper objectForKey:(__bridge id)kSecAttrAccount];
            _password = (NSString *)[wrapper objectForKey:(__bridge id)kSecValueData];
#endif
        }
        @catch (NSException *exception) {
            NSLog(@"\nException name: %@\nException reason: %@", exception.name, exception.reason);
            return nil;
        }
    }
    return ([self.username length] > 0 && [self.password length] > 0) ? self : nil;
}

@end
