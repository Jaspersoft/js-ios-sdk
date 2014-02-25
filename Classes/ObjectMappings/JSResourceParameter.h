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
//  JSResourceParameter.h
//  Jaspersoft Corporation
//

#import <Foundation/Foundation.h>

/**
 Represents a resource parameter entity for convenient XML serialization process.
 
 @author Giulio Toffoli giulio@jaspersoft.com
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.0
 */
@interface JSResourceParameter : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *isListItem;
@property (nonatomic, retain) NSString *value;

/**
 Returns a configured resource parameter. Used by class implemented 
 <code>JSSerializer</code> protocol
 
 @param name The parameter name
 @param isListItem Indicates if parameter is part (item) of list
 @param value The parameter value
 @return A configured JSResourceParameter instance
 */
- (id)initWithName:(NSString *)name isListItem:(NSString *)isListItem value:(NSString *)value;

@end
