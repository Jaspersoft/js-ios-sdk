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

NSString * const kJSAuthenticationTag = @"TIBCO.JasperServer.Password";

@interface JSEncryptionManager()
@property (nonatomic, copy) NSString *modulus;
@property (nonatomic, copy) NSString *exponent;
@end

@implementation JSEncryptionManager

#pragma mark - Initialize
- (instancetype)initWithModulus:(NSString *)modulus exponent:(NSString *)exponent
{
    self = [super init];
    if (self) {
        _modulus = modulus;
        _exponent = exponent;
    }
    return self;
}

+ (instancetype)managerWithModulus:(NSString *)modulus exponent:(NSString *)exponent {
    return [[self alloc] initWithModulus:modulus exponent:exponent];
}


#pragma mark - Public API
- (NSString *)encryptText:(NSString *)text
{
    NSData *publicKeyData = [self generatePublicKeyDataFromModulus:self.modulus exponent:self.exponent];
    SecKeyRef publicKeyRef = [self addPublicKeyWithTagName:kJSAuthenticationTag keyBits:publicKeyData];
    // There is issue with iOS9 when SecItemCopyMatching() - works wrong.
    if (!publicKeyRef) {
        return text;
    }
    NSData *encryptedData = [self encryptText:text withKey:publicKeyRef];
    NSString *encryptedString = [self stringFromData:encryptedData];
    return encryptedString;
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

    NSArray *dataArray = @[
            modulusData,
            exponentData
    ];

    NSData *result = [dataArray berData];
    return result;
}

- (SecKeyRef)addPublicKeyWithTagName:(NSString *)tagName keyBits:(NSData *)publicKey
{
    OSStatus sanityCheck = 0;
    SecKeyRef peerKeyRef = NULL;
    CFTypeRef persistPeer = NULL;

    NSData * peerTag = [[NSData alloc] initWithBytes:(const void *)[tagName UTF8String] length:[tagName length]];
    NSMutableDictionary * peerPublicKeyAttr = [[NSMutableDictionary alloc] init];

    peerPublicKeyAttr[(__bridge id) kSecClass] = (__bridge id) kSecClassKey;
    peerPublicKeyAttr[(__bridge id) kSecAttrKeyType] = (__bridge id) kSecAttrKeyTypeRSA;
    peerPublicKeyAttr[(__bridge id) kSecAttrKeyClass] = (__bridge id)kSecAttrKeyClassPublic;
    peerPublicKeyAttr[(__bridge id) kSecAttrApplicationTag] = peerTag;
    peerPublicKeyAttr[(__bridge id) kSecReturnPersistentRef] = @(YES);

    sanityCheck = SecItemDelete((__bridge_retained CFDictionaryRef)peerPublicKeyAttr);
//    NSLog(@"delete item status: %ld", sanityCheck);

    peerPublicKeyAttr[(__bridge id) kSecValueData] = publicKey;

    sanityCheck = SecItemAdd((__bridge_retained CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&persistPeer);
//    NSLog(@"add item status: %ld", sanityCheck);

    if (persistPeer) {
        NSMutableDictionary* query = [
                @{
                        (__bridge id) kSecValuePersistentRef : (__bridge id) persistPeer,
                        (__bridge id) kSecReturnRef : @YES
                } mutableCopy];

        sanityCheck = SecItemCopyMatching((__bridge_retained CFDictionaryRef)query, (CFTypeRef*)&peerKeyRef);
//        NSLog(@"copy matching from persistent ref status: %ld", sanityCheck);
    } else {
        [peerPublicKeyAttr removeObjectForKey:(__bridge id)kSecValueData];
        peerPublicKeyAttr[(__bridge id) kSecReturnRef] = @YES;
        // Let's retry a different way.
        sanityCheck = SecItemCopyMatching((__bridge_retained CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&peerKeyRef);
//        NSLog(@"copy matching from tag status: %ld", sanityCheck);
    }

    if (persistPeer) CFRelease(persistPeer);
    return peerKeyRef;
}

- (NSData *)encryptText:(NSString *)plainTextString withKey:(SecKeyRef)publicKey
{
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = malloc(cipherBufferSize);
    uint8_t *nonce = (uint8_t *)[plainTextString UTF8String];
    SecKeyEncrypt(publicKey,
            kSecPaddingNone,
            nonce,
            strlen( (char*)nonce ),
            &cipherBuffer[0],
            &cipherBufferSize);
    NSData *encryptedData = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
    return encryptedData;
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
    NSLog(@"%@", result);

    return result;
}

@end