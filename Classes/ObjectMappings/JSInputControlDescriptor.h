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
//  JSInputControlDescriptor.h
//  Jaspersoft Corporation
//

#import "JSInputControlState.h"
#import <Foundation/Foundation.h>
#import "JSSerializationDescriptorHolder.h"
#import "JSMandatoryValidationRule.h"
#import "JSDateTimeFormatValidationRule.h"


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Alexey Gubarev ogubarie@tibco.com
 @since 1.4
 */
@interface JSInputControlDescriptor : NSObject <JSSerializationDescriptorHolder, NSCopying>

@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *mandatory;
@property (nonatomic, retain) NSString *readOnly;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *uri;
@property (nonatomic, retain) NSString *visible;
@property (nonatomic, retain) NSArray <NSString *> *masterDependencies;
@property (nonatomic, retain) NSArray <NSString *> *slaveDependencies;
@property (nonatomic, retain) JSInputControlState *state;

@property (nonatomic, readonly) JSDateTimeFormatValidationRule *dateTimeFormatValidationRule;
@property (nonatomic, readonly) JSMandatoryValidationRule *mandatoryValidationRule;

- (NSArray *)selectedValues;

/**
 Returns error string for current input control descriptor, according to validation rules and state error.
 
 @return error string for current input control descriptor, according to validation rules and state error
 */
- (NSString *)errorString;

@end
