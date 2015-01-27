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
//  JSResourceDescriptor.m
//  Jaspersoft Corporation
//

#import "JSConstants.h"
#import "JSResourceDescriptor.h"
#import "JSResourceProperty.h"
#import "JSResourceParameter.h"

@interface JSResourceDescriptor()

@property JSConstants *constants;

@end

@implementation JSResourceDescriptor

- (id)init {
    if (self = [super init]) {
        self.constants = [JSConstants sharedInstance];
    }
    
    return self;
}

- (BOOL)isDataSource {
    NSArray *wsTypeDatasources = [NSArray arrayWithObjects:self.constants.WS_TYPE_DATASOURCE, 
                                  self.constants.WS_TYPE_JDBC, self.constants.WS_TYPE_JNDI, 
                                  self.constants.WS_TYPE_BEAN, self.constants.WS_TYPE_CUSTOM, nil];
    return [wsTypeDatasources containsObject:self.wsType];
}

- (JSResourceDescriptor *)resourceDescriptorDataSource {
    for (JSResourceDescriptor *childResourceDescriptor in self.childResourceDescriptors) {
        if ([childResourceDescriptor isDataSource]) {
            return childResourceDescriptor;
        }
    }
    
    return nil;
}

- (NSString *)resourceDescriptorDataSourceURI:(JSResourceDescriptor *)dataSource {
    if ([dataSource.wsType isEqualToString:self.constants.WS_TYPE_DATASOURCE]) {
        return [[dataSource propertyByName:self.constants.PROP_FILERESOURCE_REFERENCE_URI] value];
    }
    return dataSource.uriString;
}

- (JSResourceProperty *)propertyByName:(NSString *)name {
    for (JSResourceProperty *resourceProperty in self.resourceProperties) {
        if ([resourceProperty.name isEqualToString:name]) {
            return resourceProperty;
        }
    }
    
    return  nil;
}

- (NSArray *)inputControlQueryData {
    JSResourceProperty *queryDataProperties = [self propertyByName:self.constants.PROP_QUERY_DATA];
    NSMutableArray *listOfValues = [[NSMutableArray alloc] init];
    
    if (queryDataProperties) {
        for (JSResourceProperty *queryDataRow in queryDataProperties.childResourceProperties) {
            JSResourceProperty *property = [[JSResourceProperty alloc] init];
            property.value = queryDataRow.value;
            
            NSMutableArray *values = [[NSMutableArray alloc] init];
            for (JSResourceProperty *queryDataCol in queryDataRow.childResourceProperties) {
                if ([self.constants.PROP_QUERY_DATA_ROW_COLUMN isEqualToString:queryDataCol.name] && queryDataCol.value.length) {
                    [values addObject:queryDataCol.value];
                }
            }
            property.name = [values componentsJoinedByString:@" | "];
            property.childResourceProperties = values;
            [listOfValues addObject:property];
        }
    }
    
    return listOfValues;
}

#pragma mark - JSSerializationDescriptorHolder
+ (NSArray *)rkRequestDescriptors {
    NSMutableArray *descriptorsArray = [NSMutableArray array];
    [descriptorsArray addObject:[RKResponseDescriptor responseDescriptorWithMapping:[[self classMapping] inverseMapping]
                                                                             method:RKRequestMethodAny
                                                                        pathPattern:nil
                                                                            keyPath:@"resourceDescriptor"
                                                                        statusCodes:nil]];
    return descriptorsArray;
}

+ (NSArray *)rkResponseDescriptors {
    NSMutableArray *descriptorsArray = [NSMutableArray array];
    for (NSString *keyPath in [self classMappingPathes]) {
        [descriptorsArray addObject:[RKResponseDescriptor responseDescriptorWithMapping:[self classMapping]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:nil
                                                                                keyPath:keyPath
                                                                            statusCodes:nil]];
    }

    [descriptorsArray addObjectsFromArray:[JSResourceProperty rkResponseDescriptors]];
    [descriptorsArray addObjectsFromArray:[JSResourceParameter rkResponseDescriptors]];

    return descriptorsArray;
}

+ (RKObjectMapping *)classMapping {
    RKObjectMapping *classMapping = [RKObjectMapping mappingForClass:self];
    [classMapping addAttributeMappingsFromDictionary:@{
                                                       @"name": @"name",
                                                       @"wsType": @"wsType",
                                                       @"uriString": @"uriString",
                                                       @"isNew": @"isNew",
                                                       @"label": @"label",
                                                       @"description": @"resourceDescription",
                                                       @"creationDate": @"creationDate",
                                                       @"resourceProperty": @"resourceProperties",
                                                       @"resourceDescriptor": @"childResourceDescriptors",
                                                       @"parameter": @"parameters",
                                                       }];
    return classMapping;
}

+ (NSArray *)classMappingPathes {
    return @[@"resourceDescriptor"];
}

@end
