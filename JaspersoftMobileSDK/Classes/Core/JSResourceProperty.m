/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2001 - 2011 Jaspersoft Corporation. All rights reserved.
 * http://community.jaspersoft.com/project/mobile-sdk-ios
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
//  JSResourceProperty.m
//  Jaspersoft Corporation
//

#import "JSResourceProperty.h"

@implementation JSResourceProperty

@synthesize name, value, resourceProperties;

+ (id)resourceProperty {
	return [[[self alloc] init] autorelease];
}


- (id)init {
	if (self = [super init]) {
		resourceProperties = [[NSMutableArray alloc] initWithCapacity:0];
	}
	return self;
}


- (void)dealloc {	
	[resourceProperties release];
	[super dealloc];	
}


- (NSString *)getPropertyValue:(NSString *)pname
{
	JSResourceProperty *r = [self getPropertyByName: pname];
	if (r != nil) return [r value];
	
	return nil;
}


- (JSResourceProperty *)getPropertyByName:(NSString *)pname
{
	if (pname == nil) return nil;
	
	for (int i=0; i< [resourceProperties count]; ++i)
	{
		JSResourceProperty *r = [resourceProperties objectAtIndex:i];
		if ([[r name] compare: pname] == 0)
		{
			return r;
		}
	}
	
	return nil;
}
							   
@end
