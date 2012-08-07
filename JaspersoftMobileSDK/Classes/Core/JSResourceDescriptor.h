/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2001 - 2011 Jaspersoft Corporation. All rights reserved.
 * http://www.jasperforge.org/projects/mobile
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is part of Jaspersoft Mobile SDK.
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
 * along with Jaspersoft Mobile SDK. If not, see <http://www.gnu.org/licenses/>.
 */

//
//  ResourceDescriptor.h
//  Jaspersoft
//
//  Created by Giulio Toffoli on 4/10/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSResourceProperty.h"
#import "JSInputControlQueryDataRow.h"


@interface JSListItem : NSObject {
	
}
@property(retain, nonatomic) NSString *name;
@property(retain, nonatomic) NSString *value;

-(id)initWithName: (NSString *)aName andValue: (NSString *)aValue;

@end


@interface JSResourceDescriptor : NSObject {
}


@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *label;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *wsType;
@property(nonatomic, retain) NSString *uri;
@property(nonatomic) bool isNew;
@property(nonatomic, retain) NSMutableArray *resourceDescriptors;
@property(nonatomic, retain) NSMutableArray *resourceProperties;
@property(nonatomic, retain) NSMutableArray *resourceParameters;

+(id)resourceDescriptor;


// Return the value of the provided property name
// If the property is not found, it returns nil
- (NSString *)resourcePropertyValue:(NSString *)name;

// Return the value of the provided property name
// If the property is not found, it returns the provided default value
- (NSString *)resourcePropertyValue:(NSString *)name withDefault:(NSString *)def;

// Return the property with the specified name
// If the property is not found, it returns nil
- (JSResourceProperty *)resourcePropertyWithName:(NSString *)name;


// Return the list of items of this ResourceDescriptor.
// The List Of Items is set of pairs (name/value) stored in the JS_PROP_LOV resource property.
- (NSArray *)listOfItems;

// Return the list of queryDataRow of this ResourceDescriptor.
// The List of query data row is stored in the JS_PROP_QUERY_DATA -> JS_PROP_QUERY_DATA_ROW(s) resource properties.
- (NSArray *)queryData;


@end




