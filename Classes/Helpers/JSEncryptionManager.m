//
// Created by Aleksandr Dakhno on 8/16/15.
// Copyright (c) 2015 Aleksandr Dakhno. All rights reserved.
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
    SecKeyRef peerKeyRef = NULL;
    CFTypeRef persistPeer = NULL;

    NSData * peerTag = [[NSData alloc] initWithBytes:(const void *)[tagName UTF8String] length:[tagName length]];
    NSMutableDictionary * peerPublicKeyAttr = [[NSMutableDictionary alloc] init];

    peerPublicKeyAttr[(__bridge id) kSecClass] = (__bridge id) kSecClassKey;
    peerPublicKeyAttr[(__bridge id) kSecAttrKeyType] = (__bridge id) kSecAttrKeyTypeRSA;
    peerPublicKeyAttr[(__bridge id) kSecAttrKeyClass] = (__bridge id)kSecAttrKeyClassPublic;
    peerPublicKeyAttr[(__bridge id) kSecAttrApplicationTag] = peerTag;
    peerPublicKeyAttr[(__bridge id) kSecReturnPersistentRef] = @(YES);

    SecItemDelete((__bridge CFDictionaryRef)peerPublicKeyAttr);

    peerPublicKeyAttr[(__bridge id) kSecValueData] = publicKey;

    SecItemAdd((__bridge CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&persistPeer);

    if (persistPeer) {
        NSMutableDictionary* query = [
                @{
                        (__bridge id) kSecValuePersistentRef : (__bridge id) persistPeer,
                        (__bridge id) kSecReturnRef : @YES
                } mutableCopy];

        SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef*)&peerKeyRef);
    } else {
        [peerPublicKeyAttr removeObjectForKey:(__bridge id)kSecValueData];
        peerPublicKeyAttr[(__bridge id) kSecReturnRef] = @YES;
        // Let's retry a different way.
        SecItemCopyMatching((__bridge CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&peerKeyRef);
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
    free(cipherBuffer);
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

    return result;
}

@end