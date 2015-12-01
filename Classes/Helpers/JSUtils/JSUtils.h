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
//  JSUtils.h
//  Jaspersoft Corporation
//

#import <Foundation/Foundation.h>

/**
 @author Alexey Gubarev ogubarie@tibco.com
 @since 2.3
 */

@interface JSUtils : NSObject

/**
 Get string representation for Boolean value
 
 @param aBOOL A Boolean value
 @return A new string @"true" or @"false" depends on provided Boolean value
 */
+ (nonnull NSString *)stringFromBOOL:(BOOL)aBOOL;

/**
 Get Bolean representation for string value
 
 @param aString A String value @"true" or @"false"
 @return A BOOL depends on provided string value
 */
+ (BOOL)BOOLFromString:(nonnull NSString *)aString;

/**
 Get string identifier for Keychain
 
 @return A string identifier for Keychain in format <YOUR_APP_BUNDLE_ID.GenericKeychainSuite>
 */
+ (nonnull NSString *)keychainIdentifier;

/**
 Get localized string if it's available or english string if it doesn't found
 
 @param key A key for localisation
 @return A localized string if it's available or english string if it doesn't found
 */
+ (nonnull NSString *)localizedStringForKey:(nonnull NSString *)key comment:(nullable NSString *)comment;

/**
 @name REST API Preferences
 */
+ (nonnull NSString *)usedMimeType;

+ (NSTimeInterval) checkServerConnectionTimeout;

+ (nonnull NSDictionary *)supportedLocales;

@end

/**
 Get localized string if it's available or english string if it doesn't found
 
 @param key A key for localisation
 @return A localized string if it's available or english string if it doesn't found
 */
NSString *__nonnull JSCustomLocalizedString(NSString *__nonnull key, NSString *__nullable comment);
