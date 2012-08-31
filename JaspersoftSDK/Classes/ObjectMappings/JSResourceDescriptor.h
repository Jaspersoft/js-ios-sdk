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
 
 @author Vlad Zavadskyi
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

- (BOOL)isDataSource;
- (JSResourceDescriptor *)resourceDescriptorDataSource;
- (NSString *)resourceDescriptorDataSourceURI:(JSResourceDescriptor *)dataSource;
- (JSResourceProperty *)propertyByName:(NSString *)name;
- (NSArray *)inputControlQueryData;
- (NSString *)description;

@end
