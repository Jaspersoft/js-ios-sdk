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
//  ResourceDescriptor.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 4/10/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSResourceDescriptor.h"
#import "JSConstants.h"

@implementation JSListItem

@synthesize name, value;

-(id)initWithName: (NSString *)aName andValue: (NSString *)aValue
{
	if (self = [self init])
	{
		self.name = aName;
		self.value = aValue;
	}
	
	return self;
}

-(void)dealloc
{
	[value autorelease];
	[name autorelease];
	[super dealloc];
}

@end

@implementation JSResourceDescriptor

@synthesize  name;
@synthesize  label;
@synthesize  description;
@synthesize  wsType;
@synthesize  uri;
@synthesize  isNew;
@synthesize  resourceDescriptors;
@synthesize  resourceProperties;
@synthesize  resourceParameters;

+(id)resourceDescriptor {

	return [[[self alloc] init] autorelease];
}


-(id) init {

	self = [super init];
    
    resourceProperties = [[NSMutableArray alloc] initWithCapacity:0];
	resourceDescriptors = [[NSMutableArray alloc] initWithCapacity:0];
    resourceParameters = [[NSMutableArray alloc] initWithCapacity:0];
    isNew = FALSE;
	
	return self;	
}

-(void)dealloc
{
	
	[resourceProperties release];
	[resourceDescriptors release];
    [resourceParameters release];
	[super dealloc];
}


// Return the property with the specified name
// If the property is not found, it returns nil
- (JSResourceProperty *)resourcePropertyWithName:(NSString *)propName
{
	for (int i=0; i< self.resourceProperties.count; ++i)
	{
		JSResourceProperty *property = [self.resourceProperties objectAtIndex:i];
		if ([[property name] compare: propName] == 0) return property;
	}
	
	return nil;
}

// Return the value of the provided property name
// If the property is not found, it returns nil
- (NSString *)resourcePropertyValue:(NSString *)propName
{
	return [self resourcePropertyValue:propName withDefault:nil];
}

// Return the value of the provided property name
// If the property is not found, it returns the provided default value
- (NSString *)resourcePropertyValue:(NSString *)propName withDefault:(NSString *)def
{
	JSResourceProperty *property = [self resourcePropertyWithName:propName];
	if (property == nil) return def;
	return [property value];	
}


- (NSArray *)listOfItems
{
	JSResourceProperty *rp = [self resourcePropertyWithName:JS_PROP_LOV];
	NSMutableArray *listOfItems = [NSMutableArray array];
	
	if (rp != nil)
	{
		for (int i=0; i < rp.resourceProperties.count; ++i) {
			
			JSResourceProperty *rpChild = [rp.resourceProperties objectAtIndex:i];
			JSListItem *listItem = [[[JSListItem alloc] initWithName:  rpChild.value == nil ? rpChild.name : rpChild.value andValue: rpChild.name] autorelease];
			[listOfItems addObject:listItem];
		}
	}
	return listOfItems;
}


- (NSArray *)queryData
{
	JSResourceProperty *rp = [self resourcePropertyWithName:JS_PROP_QUERY_DATA];
	
	NSMutableArray *queryDataItems = [NSMutableArray array];
	
	if (rp != nil)
	{
		for (int i=0; i < rp.resourceProperties.count; ++i) {
			
			JSResourceProperty *rpChild = [rp.resourceProperties objectAtIndex:i];
			if ( [[rpChild name] isEqualToString: JS_PROP_QUERY_DATA_ROW])
			{
				NSString *value = [rpChild value];
				NSMutableArray *labels = [NSMutableArray array];
				
				for (int j=0; j < rpChild.resourceProperties.count; ++j) {
					
					JSResourceProperty *rpRow = [rpChild.resourceProperties objectAtIndex:j];
					if ([[rpRow name] isEqualToString: JS_PROP_QUERY_DATA_ROW_COLUMN])
					{
						[labels addObject: [rpRow value]];
					}	
				}
				
				JSInputControlQueryDataRow *qdr = [[[JSInputControlQueryDataRow alloc] initWithValue:value labels:labels] autorelease];
				[queryDataItems addObject:qdr];
				
			}
		}
	}
	return queryDataItems;
}

@end



