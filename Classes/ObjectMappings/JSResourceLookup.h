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
//  JSResourceLookup.h
//  Jaspersoft Corporation
//

#import <Foundation/Foundation.h>
#import "JSSerializationDescriptorHolder.h"

typedef NS_ENUM (NSInteger, JSPermissionMask) {
    JSPermissionMask_Administration = 1 << 0,
    JSPermissionMask_Read = 1 << 1,
    JSPermissionMask_Write = 1 << 2,
    JSPermissionMask_Create = 1 << 3,
    JSPermissionMask_Delete = 1 << 4,
    JSPermissionMask_Execute = 1 << 5
};

/**
 Represents a resource lookup entity for convenient XML serialization process.
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Alexey Gubarev ogubarie@tibco.com
 @since 1.7
 */
@interface JSResourceLookup : NSObject <JSSerializationDescriptorHolder>

@property (nonatomic, retain, nonnull) NSString *label;
@property (nonatomic, retain, nonnull) NSString *uri;
@property (nonatomic, retain, nullable) NSString *resourceDescription;
@property (nonatomic, retain, nonnull) NSString *resourceType;
@property (nonatomic, retain, nonnull) NSNumber *version;
@property (nonatomic, retain, nonnull) NSNumber *permissionMask;
@property (nonatomic, retain, nonnull) NSDate *creationDate;
@property (nonatomic, retain, nonnull) NSDate *updateDate;

@end
