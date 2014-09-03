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
//  JSInputControlWrapper.h
//  Jaspersoft Corporation
//

#import <Foundation/Foundation.h>
#import "JSResourceDescriptor.h"

extern NSString * const JS_IC_NULL_SUBSTITUTE;
extern NSString * const JS_IC_NULL_SUBSTITUTE_LABEL;
extern NSString * const JS_IC_NOTHING_SUBSTITUTE;
extern NSString * const JS_IC_NOTHING_SUBSTITUTE_LABEL;

/**
 This is a helper class for working with input control entities, independent of type and UI appearance.

 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.6
 */

__attribute__((deprecated("Use 'JSInputControlDescriptor' class")))
@interface JSInputControlWrapper : NSObject 

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *uri;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger dataType;
@property (nonatomic, retain) NSString *dataTypeUri;

@property (nonatomic, assign) BOOL isMandatory;
@property (nonatomic, assign) BOOL isReadOnly;
@property (nonatomic, assign) BOOL isVisible;

@property (nonatomic, retain) NSString *query;
@property (nonatomic, retain) NSString *dataSourceUri;
@property (nonatomic, retain) NSMutableArray /*<NSString>*/ *parameterDependencies;

@property (nonatomic, retain) NSMutableArray /*<JSInputControlWrapper>*/ *masterDependencies;
@property (nonatomic, retain) NSMutableArray /*<JSInputControlWrapper>*/ *slaveDependencies;

@property (nonatomic, retain) NSMutableArray /*<JSResourceProperty>*/ *listOfValues;

/**
 Adds an Input Control as a slave dependency. This method uses CFMutableArray (without
 retaining) instead of NSMutableArray to avoid memory leaks because of circular references
 
 @param inputControl An instance of JSInputControlWrapper
 */
- (void)addSlaveDependency:(JSInputControlWrapper *)inputControl;

/**
 Gets slave dependencies from CFMutableArray
 
 @return An array of slave dependencies
 */
- (NSArray *)getSlaveDependencies;

/**
 Removes an Input Control from slave dependencies (uses CFMutableArray)
 
 @param inputControl An instance of JSInputControlWrapper
 */
- (void)removeSlaveDependency:(JSInputControlWrapper *)inputControl;

/**
 Adds an Input Control as master dependency. This method uses CFMutableArray (without
 retaining) instead of NSMutableArray to avoid memory leaks because of circular references
 
 @param inputControl An instance of JSInputControlWrapper
 */
- (void)addMasterDependency:(JSInputControlWrapper *)inputControl;

/**
 Gets master dependencies from CFMutableArray
 
 @return An array of master dependencies
 */
- (NSArray *)getMasterDependencies;

/**
 Removes Input Control from master dependencies (uses CFMutableArray)
 
 @param inputControl An instance of JSInputControlWrapper
 */
- (void)removeMasterDependency:(JSInputControlWrapper *)inputControl;

- (id)initWithResourceDescriptor:(JSResourceDescriptor *)resourceDescriptor;

@end
