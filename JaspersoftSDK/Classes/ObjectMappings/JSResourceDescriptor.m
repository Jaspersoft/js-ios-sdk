//
//  JSResourceDescriptor.m
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 03.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSConstants.h"
#import "JSResourceDescriptor.h"

@interface JSResourceDescriptor()

@property JSConstants *constants;

@end

@implementation JSResourceDescriptor

@synthesize name = _name;
@synthesize wsType = _wsType;
@synthesize uriString = _uriString;
@synthesize isNew = _isNew;
@synthesize label = _label;
@synthesize resourceDescription = _resourceDescription;
@synthesize creationDate = _creationDate;
@synthesize resourceProperties = _resourceProperties;
@synthesize childResourceDescriptors = _childResourceDescriptors;
@synthesize parameters = _parameters;
@synthesize constants = _constants;

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
            property.name = queryDataRow.value;
            
            NSMutableArray *values = [[NSMutableArray alloc] init];
            for (JSResourceProperty *queryDataCol in queryDataRow.childResourceProperties) {
                if ([self.constants.PROP_QUERY_DATA_ROW_COLUMN isEqualToString:queryDataCol.name]) {
                    [values addObject:queryDataCol.value];
                }
            }
            property.value = [values componentsJoinedByString:@" | "];
            property.childResourceProperties = values;
            [listOfValues addObject:property];
        }
    }
    
    return listOfValues;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Resource Descriptor - Name: %@; WsType: %@; UriString: %@; IsNew: %@; Label: %@; Description: %@; CreationDate: %@; Parameters Count: %@; Resource Properties Count: %i; Child Resource Descriptors Count: %i", 
            self.name, self.wsType, self.uriString, self.isNew, self.label, self.resourceDescription, 
            self.creationDate, self.parameters.count, self.resourceProperties.count, self.childResourceDescriptors.count];
}

@end
