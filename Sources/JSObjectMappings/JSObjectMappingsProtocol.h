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
 * <http://www.gnu.org/licenses/lgpl".
 */

//
//  JSObjectMappingsProtocol.h
//  Jaspersoft Corporation
//

#import <Foundation/Foundation.h>
#import "EKObjectMapping.h"
#import "JSProfile.h"

/**
 Declares method that a class must implement so that it can provide support of
 representing object as string
 
 @author Alexey Gubarev ogubarie@tibco.com
 @since 2.4
 */

@protocol JSObjectMappingsProtocol <NSObject>

@required
/**
 Returns a `EKObjectMapping` object for serialize/deserialize objects of the class.
 @param serverProfile Server Profile for configuring mapping according to server version
 @return A `EKObjectMapping` object for serialize/deserialize objects of the class.
 */
+ (nonnull EKObjectMapping *)ekObjectMappingForServerProfile:(nonnull JSProfile *)serverProfile;

@optional

/**
 Returns a keyPath of `NSString` type for serializing objects of the class to request.
 @return a keyPath of `NSString` type for serializing objects of the class to request.
 */
+ (nonnull NSString *)requestObjectKeyPath;

/**
 Returns an keyPathes array of `NSString` type for mapping objects from response.
 @return an keyPathes array of `NSString` type for mapping objects from response.
 */
+ (nonnull NSArray <NSString *> *)customMappingPathes;

@end