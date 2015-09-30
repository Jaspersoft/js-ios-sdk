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
//  JSEncryptionManager.h
//  Jaspersoft Corporation
//

/**
 @author Aleksandr Dakhno odahno@tibco.com
 @since 2.1
 */

#import <Foundation/Foundation.h>

@interface JSEncryptionManager : NSObject
- (nonnull instancetype)initWithModulus:(nonnull NSString *)modulus exponent:(nonnull NSString *)exponent;
+ (nonnull instancetype)managerWithModulus:(nonnull NSString *)modulus exponent:(nonnull NSString *)exponent;
- (nonnull NSString *)encryptText:(nonnull NSString *)text;
@end