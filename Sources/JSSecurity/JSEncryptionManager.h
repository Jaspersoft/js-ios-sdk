/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @since 2.1
 */

@interface JSEncryptionManager : NSObject
- (NSString *)encryptText:(NSString *)text withModulus:(NSString *)modulus exponent:(NSString *)exponent;
- (NSString *)encryptText:(NSString *)text withKey:(NSString *)key;
- (NSString *)decryptText:(NSString *)text withKey:(NSString *)key;
@end
