//
// Created by Aleksandr Dakhno on 8/16/15.
// Copyright (c) 2015 Aleksandr Dakhno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSEncryptionManager : NSObject
- (instancetype)initWithModulus:(NSString *)modulus exponent:(NSString *)exponent;
+ (instancetype)managerWithModulus:(NSString *)modulus exponent:(NSString *)exponent;
- (NSString *)encryptText:(NSString *)text;
@end