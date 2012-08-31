//
//  JSResourceDescriptor.h
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 03.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSResourceProperty.h"
#import <Foundation/Foundation.h>

/**
 Represents a resource descriptor entity for convenient XML serialization process.
 
 @author Vlad Zavadskyi vzavadskii@jaspersoft.com
 @version 1.0
 */
@interface JSResourceDescriptor : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *wsType;
@property (nonatomic, retain) NSString *uriString;
@property (nonatomic, retain) NSString *isNew;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *resourceDescription;
@property (nonatomic, retain) NSNumber *creationDate;
@property (nonatomic, retain) NSArray *resourceProperties;
@property (nonatomic, retain) NSArray *childResourceDescriptors; 
@property (nonatomic, retain) NSArray *parameters;

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

- (NSString *)description;

@end
