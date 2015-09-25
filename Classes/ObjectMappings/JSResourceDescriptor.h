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
//  JSResourceDescriptor.h
//  Jaspersoft Corporation
//

#import "JSResourceProperty.h"
#import <Foundation/Foundation.h>
#import "JSSerializationDescriptorHolder.h"
#import "JSResourceProperty.h"
#import "JSResourceParameter.h"

/**
 Represents a resource descriptor entity for convenient XML serialization process.
 
 @author Giulio Toffoli giulio@jaspersoft.com
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Alexey Gubarev ogubarie@tibco.com

 @since 1.0
 */

DEPRECATED_MSG_ATTRIBUTE("Use JSResourceLookup instead.")
@interface JSResourceDescriptor : NSObject <JSSerializationDescriptorHolder>

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *wsType;
@property (nonatomic, retain) NSString *uriString;
@property (nonatomic, retain) NSString *isNew;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *resourceDescription;
@property (nonatomic, retain) NSDate   *creationDate;
@property (nonatomic, retain) NSArray <JSResourceProperty *> *resourceProperties;
@property (nonatomic, retain) NSArray <JSResourceDescriptor *> *childResourceDescriptors;
@property (nonatomic, retain) NSArray <JSResourceParameter *> *parameters;

/**
 Looks the wsType of the resource descriptor and return YES
 if it is one of the following: datasource, jdbc, jndi, bean, custom.
 
 @return <code>YES</code> if it is data source, <code>NO</code> otherwise.
 */
- (BOOL)isDataSource;

/**
 Gets a valid data source resource from a resource descriptor
 
 @return The data source resource, or <code>nil</code> if no data source is found.
 */
- (JSResourceDescriptor *)resourceDescriptorDataSource;

/**
 Gets a valid data source uri from a resource descriptor
 
 @param dataSource Data source resource
 @return The data source uri, or <code>nil</code> if no data source is found.
 */
- (NSString *)resourceDescriptorDataSourceURI:(JSResourceDescriptor *)dataSource;

/**
 Gets the property with the specified name
 
 @param name The property name
 @return Property with the specified name, or <code>nil</code> if the property is not found
 */
- (JSResourceProperty *)propertyByName:(NSString *)name;

/**
 Gets the query data of a query-based input control
 
 @return The query data as list of JSResourceProperty objects
 */
- (NSArray *)inputControlQueryData;

@end