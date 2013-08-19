/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2013 Jaspersoft Corporation. All rights reserved.
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
//  JSInputControlWrapper.h
//  Jaspersoft Corporation
//

#import <Foundation/Foundation.h>
#import "JSResourceDescriptor.h"

/**
 This is a helper class for working with input control entities, independent of type and UI appearance.

 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.6
 */
@interface JSInputControlWrapper : NSObject

// Constants
@property (nonatomic, readonly) NSString *NULL_SUBSTITUTE;
@property (nonatomic, readonly) NSString *NULL_SUBSTITUTE_LABEL;
@property (nonatomic, readonly) NSString *NOTHING_SUBSTITUTE;
@property (nonatomic, readonly) NSString *NOTHING_SUBSTITUTE_LABEL;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *uri;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger dataType;
@property (nonatomic, strong) NSString *dataTypeUri;

@property (nonatomic, assign) BOOL isMandatory;
@property (nonatomic, assign) BOOL isReadOnly;
@property (nonatomic, assign) BOOL isVisible;

@property (nonatomic, strong) NSString *query;
@property (nonatomic, strong) NSString *dataSourceUri;
@property (nonatomic, strong) NSMutableArray /*<NSString>*/ *parameterDependencies;

@property (nonatomic, strong) NSMutableArray /*<JSInputControlWrapper>*/ *masterDependencies;
@property (nonatomic, strong) NSMutableArray /*<JSInputControlWrapper>*/ *slaveDependencies;

@property (nonatomic, strong) NSMutableArray /*<JSResourceProperty>*/ *listOfValues;
@property (nonatomic, strong) NSMutableArray /*<JSResourceParameter>*/ *listOfSelectedValues;

- (id)initWithResourceDescriptor:(JSResourceDescriptor *)resourceDescriptor;

@end
