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
//  JSEncryptionManager.m
//  Jaspersoft Corporation
//

#import <CoreData/CoreData.h>
#import "JSEncryptionManager.h"
#import "BasicEncodingRules.h"

NSString * const kJSAuthenticationTag = @"TIBCO.JasperServer.Authentication";
NSString * const kJSPublicCredentialsTag = @"TIBCO.JasperServer.Public.Credentials";
NSString * const kJSPrivateCredentialsTag = @"TIBCO.JasperServer.Private.Credentials";

@interface JSEncryptionManager()
@property (nonatomic, copy) NSString *modulus;
@property (nonatomic, copy) NSString *exponent;
@end

@implementation JSEncryptionManager

#pragma mark - Public API
- (NSString *)encryptText:(NSString *)text withModulus:(NSString *)modulus exponent:(NSString *)exponent
{
    SecKeyRef publicKeyRef;
    NSData *encryptedData;
    NSString *encryptedString;

    NSData *publicKeyData = [self generatePublicKeyDataFromModulus:modulus exponent:exponent];
    publicKeyRef = [self addSecKeyWithData:publicKeyData tagName:kJSAuthenticationTag];

    // If there isn't public key return plain (unencrypted) text
    if (!publicKeyRef) {
        return text;
    }

    encryptedData = [self encryptData:[text dataUsingEncoding:NSUTF8StringEncoding]
                        withPublicKey:publicKeyRef
                              padding:kSecPaddingNone];
    encryptedString = [self stringFromData:encryptedData];

    return encryptedString;
}

- (NSString *)encryptText:(NSString *)text withKey:(NSString *)key
{
    NSString *publicTagName = [NSString stringWithFormat:@"%@.%@", kJSPublicCredentialsTag, key];
    NSString *privateTagName = [NSString stringWithFormat:@"%@.%@", kJSPrivateCredentialsTag, key];

    [self generateKeysWithCompletion:^(SecKeyRef publicKey, SecKeyRef privateKey) {
        [self addSecKeyWithSecKey:publicKey
                          tagName:publicTagName];
        [self addSecKeyWithSecKey:privateKey
                          tagName:privateTagName];
    }];

    SecKeyRef publicKeyRef = [self secKeyWithTagName:publicTagName];
    NSData *encryptedData = [self encryptData:[text dataUsingEncoding:NSUTF8StringEncoding]
                                withPublicKey:publicKeyRef
                                      padding:kSecPaddingOAEP];
    NSString *encryptedString = [encryptedData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encryptedString;
}

- (NSString *)decryptText:(NSString *)text withKey:(NSString *)key
{
    NSString *privateTagName = [NSString stringWithFormat:@"%@.%@", kJSPrivateCredentialsTag, key];
    SecKeyRef privateKeyRef = [self secKeyWithTagName:privateTagName];
    if (!privateKeyRef) {
        return nil;
    }
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:text
                                                                options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptedData = [self decryptData:encryptedData
                               withPrivateKey:privateKeyRef
                                      padding:kSecPaddingOAEP];
    NSString *decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    return decryptedString;
}

#pragma mark - Private API
- (NSData *)generatePublicKeyDataFromModulus:(NSString *)modulus exponent:(NSString *)exponent
{
    NSData *modulusData = [self dataFromString:modulus];
    // @"10001" -> @"010001"
    if (exponent.length % 2 != 0) {
        exponent = [@"0" stringByAppendingString:exponent];
    }
    NSData *exponentData = [self dataFromString:exponent];

    // Correct modulus data by adding offset 0x00
    const char fixByte = 0;
    NSMutableData * fixedModulusData = [NSMutableData dataWithBytes:&fixByte length:1];
    [fixedModulusData appendData:modulusData];

    NSArray *dataArray = @[
            fixedModulusData,
            exponentData
    ];

    NSData *result = [dataArray berData];
    return result;
}

- (NSDictionary *)paramsWithTagName:(NSString *)tagName
{
    NSData * peerTag = [[NSData alloc] initWithBytes:(const void *)tagName.UTF8String
                                              length:tagName.length];
    NSDictionary *params = @{
            (__bridge id) kSecAttrApplicationTag: peerTag,
            (__bridge id) kSecAttrKeyType: (__bridge id) kSecAttrKeyTypeRSA,
            (__bridge id) kSecClass: (__bridge id) kSecClassKey,
    };
    return params;
}

- (SecKeyRef)secKeyWithTagName:(NSString *)tagName
{
    SecKeyRef peerKeyRef = NULL;
    NSMutableDictionary *params = [[self paramsWithTagName:tagName] mutableCopy];
    params[(__bridge id) kSecReturnRef] = @YES;
    SecItemCopyMatching((__bridge CFDictionaryRef)params, (CFTypeRef *)&peerKeyRef);
    return peerKeyRef;
}

- (SecKeyRef)addSecKeyWithData:(NSData *)secKeyData tagName:(NSString *)tagName
{
    // Remove old key
    [self removeSecKeyWithTagName:tagName];

    NSMutableDictionary *params = [[self paramsWithTagName:tagName] mutableCopy];
    params[(__bridge id) kSecReturnPersistentRef] = @YES;
    params[(__bridge id) kSecValueData] = secKeyData;

    SecKeyRef keyRef = [self addSecKeyWithParams:params];
    return keyRef;
}

- (SecKeyRef)addSecKeyWithSecKey:(SecKeyRef)secKeyRef tagName:(NSString *)tagName
{
    // Remove old key
    [self removeSecKeyWithTagName:tagName];

    NSMutableDictionary *params = [[self paramsWithTagName:tagName] mutableCopy];
    params[(__bridge id) kSecReturnPersistentRef] = @YES;
    params[(__bridge id) kSecValueRef] = (__bridge id)secKeyRef;

    SecKeyRef keyRef = [self addSecKeyWithParams:params];
    return keyRef;
}

- (SecKeyRef)addSecKeyWithParams:(NSDictionary *)params
{
    SecKeyRef keyRef = NULL;

    // Add public data
    CFTypeRef persistRef = NULL;
    SecItemAdd((__bridge CFDictionaryRef)params, &persistRef);

    // Get public key for public data
    if (persistRef) {
        NSDictionary* queryParams = @{
                (__bridge id) kSecValuePersistentRef : (__bridge id)persistRef,
                (__bridge id) kSecReturnRef : @YES
        };
        SecItemCopyMatching((__bridge CFDictionaryRef)queryParams, (CFTypeRef *)&keyRef);
    } else {
        return nil;
    }

    if (persistRef) CFRelease(persistRef);
    return keyRef;
}

- (void)removeSecKeyWithTagName:(NSString *)tagName
{
    NSDictionary *params = [self paramsWithTagName:tagName];
    SecItemDelete((__bridge CFDictionaryRef)params);
}

#pragma mark - Helpers
- (NSString *)stringFromData:(NSData *)data
{
    NSString *result = [data description];
    result = [result stringByReplacingOccurrencesOfString:@"<" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@">" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    return result;
}

- (NSData *)dataFromString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *result = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length]/2; i++) {
        byte_chars[0] = (char) [string characterAtIndex:i*2];
        byte_chars[1] = (char) [string characterAtIndex:i*2+1];
        whole_byte = (unsigned char) strtol(byte_chars, NULL, 16);
        [result appendBytes:&whole_byte length:1];
    }

    return result;
}

#pragma mark - Wrappers
- (NSData *)encryptData:(NSData *)data withPublicKey:(SecKeyRef)publicKey padding:(SecPadding)padding
{
    // init buffer for encrypted data
    size_t encryptedDataBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *encryptedDataBuffer = malloc(encryptedDataBufferSize);

    SecKeyEncrypt(publicKey,
            padding,
            data.bytes,
            data.length,
            encryptedDataBuffer,
            &encryptedDataBufferSize);

    NSData *encryptedData = [NSData dataWithBytes:encryptedDataBuffer
                                           length:encryptedDataBufferSize];
    free(encryptedDataBuffer);
    return encryptedData;
}

- (NSData *)decryptData:(NSData *)encryptedData withPrivateKey:(SecKeyRef)privateKey padding:(SecPadding)padding
{
    // init buffer for encrypted data
    size_t decryptedDataBufferSize = SecKeyGetBlockSize(privateKey);
    uint8_t *decryptedDataBuffer = malloc(decryptedDataBufferSize);

    SecKeyDecrypt(privateKey,
            padding,
            encryptedData.bytes,
            encryptedData.length,
            decryptedDataBuffer,
            &decryptedDataBufferSize);

    NSData *decryptedData = [NSData dataWithBytes:decryptedDataBuffer
                                           length:decryptedDataBufferSize];
    free(decryptedDataBuffer);
    return decryptedData;
}

- (void)generateKeysWithCompletion:(void(^)(SecKeyRef publicKey, SecKeyRef privateKey))completion
{
    if (!completion) {
        return;
    }

    NSMutableDictionary *params = [@{} mutableCopy];
    SInt32 iKeySize = 1024;
    CFNumberRef keySize = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &iKeySize);
    params[(__bridge id) kSecAttrKeyType] = (__bridge id) kSecAttrKeyTypeRSA;
    params[(__bridge id) kSecAttrKeySizeInBits] = (__bridge id) keySize;
    SecKeyRef publicKey;
    SecKeyRef privateKey;
    SecKeyGeneratePair((__bridge CFDictionaryRef)params, &publicKey, &privateKey);
    completion(publicKey, privateKey);
}

@end