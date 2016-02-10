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
 * MERCHANTABILITY or FITNESS FOR
 A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with Jaspersoft Mobile SDK for iOS. If not, see 
 * <http://www.gnu.org/licenses/lgpl>.
 */

//
//  EKMappingProtocol.h
//  Jaspersoft Corporation
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "JSProfile.h"

/**
 Declares method that a class must implement so that it can provide support of
 representing object as string
 
 @author Alexey Gubarev ogubarie@tibco.com
 @since 1.9
 */

@protocol EKMappingProtocol <NSObject>

@optional
/**
 Returns an array of `RKRequestDescriptor` objects to be added to the manager
 for mapping objects of the class to request.
 @param serverProfile Server Profile for configuring mapping according to server version

 @return An array of `RKRequestDescriptor` objects to be added to the manager.
 */
+ (nonnull NSArray <RKRequestDescriptor *> *)rkRequestDescriptorsForServerProfile:(nonnull JSProfile *)serverProfile;

/**
 Returns an array of `RKResponseDescriptor` objects to be added to the manager
 for mapping objects of the class from response.
 @param serverProfile Server Profile for configuring mapping according to server version

 @return An array of `RKResponseDescriptor` objects to be added to the manager.
 */
+ (nonnull NSArray <RKResponseDescriptor *> *)rkResponseDescriptorsForServerProfile:(nonnull JSProfile *)serverProfile;

/**
 Returns `RKObjectMapping` object for added it as relation referencesß
 for mapping objects from response.
 @param serverProfile Server Profile for configuring mapping according to server version

 @return Returns `RKObjectMapping` object for added it as relation references
 */
+ (nonnull RKObjectMapping *)classMappingForServerProfile:(nonnull JSProfile *)serverProfile;
@end
