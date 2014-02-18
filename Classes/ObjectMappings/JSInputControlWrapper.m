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
//  JSInputControlWrapper.m
//  Jaspersoft Corporation
//

#import "JSInputControlWrapper.h"
#import "JSConstants.h"

NSString * const JS_IC_NULL_SUBSTITUTE = @"~NULL~";
NSString * const JS_IC_NULL_SUBSTITUTE_LABEL = @"[Null]";
NSString * const JS_IC_NOTHING_SUBSTITUTE = @"~NOTHING~";
NSString * const JS_IC_NOTHING_SUBSTITUTE_LABEL = @"---";

static JSConstants *constants;

@interface JSInputControlWrapper() {
@private
    CFMutableArrayRef _slaveDependenciesRef;
    CFMutableArrayRef _masterDependenciesRef;
}
@end

@implementation JSInputControlWrapper

+ (void)initialize {
    constants = [JSConstants sharedInstance];
}

#pragma mark - Initialization

- (id)initWithResourceDescriptor:(JSResourceDescriptor *)resourceDescriptor {
    if (self = [self init]) {
        self.parameterDependencies = [NSMutableArray array];
        self.slaveDependencies = [NSMutableArray array];
        self.masterDependencies = [NSMutableArray array];
        self.listOfValues = [NSMutableArray array];

        _slaveDependenciesRef = CFArrayCreateMutable(NULL, 0, NULL);
        _masterDependenciesRef = CFArrayCreateMutable(NULL, 0, NULL);

        [self configure:resourceDescriptor];
    }

    return self;
}

- (void)dealloc {
    CFRelease(_slaveDependenciesRef);
    CFRelease(_masterDependenciesRef);

    [self.masterDependencies removeAllObjects];
    [self.slaveDependencies removeAllObjects];
    [self.parameterDependencies removeAllObjects];
    [self.listOfValues removeAllObjects];
}


#pragma mark - JSInputControlWrapper

- (void)configure:(JSResourceDescriptor *)resourceDescriptor {
    self.name = resourceDescriptor.name;
    self.label = resourceDescriptor.label;
    self.uri = resourceDescriptor.uriString;

    // Set properties
    for (JSResourceProperty *property in resourceDescriptor.resourceProperties) {
        NSString *name = property.name;
        if ([constants.PROP_INPUTCONTROL_TYPE isEqualToString:name]) {
            self.type = property.value.integerValue;
        } else if ([constants.PROP_INPUTCONTROL_IS_MANDATORY isEqualToString:name]) {
            self.isMandatory = property.value.boolValue;
        } else if ([constants.PROP_INPUTCONTROL_IS_READONLY isEqualToString:name]) {
            self.isReadOnly= property.value.boolValue;
        } else if ([constants.PROP_INPUTCONTROL_IS_VISIBLE isEqualToString:name]) {
            self.isVisible = property.value.boolValue;
        }
    }

    // Get query and datasource URI
    for (JSResourceDescriptor *childResourceDescriptor in resourceDescriptor.childResourceDescriptors) {
        if ([childResourceDescriptor.wsType isEqualToString:constants.WS_TYPE_QUERY]) {
            JSResourceProperty *resourceProperty = [childResourceDescriptor propertyByName:constants.PROP_QUERY];
            self.query = resourceProperty.value;
            self.dataSourceUri = [childResourceDescriptor resourceDescriptorDataSourceURI:childResourceDescriptor.resourceDescriptorDataSource];
            break;
        }
    }

    // Data type for single value input control
    if (self.type == constants.IC_TYPE_SINGLE_VALUE) {
        for (JSResourceDescriptor *childResourceDescriptor in resourceDescriptor.childResourceDescriptors) {
            if ([childResourceDescriptor.wsType isEqualToString:constants.WS_TYPE_DATATYPE]) {
                JSResourceProperty *dataTypeProperty = [childResourceDescriptor propertyByName:constants.PROP_DATATYPE_TYPE];
                self.dataType = dataTypeProperty.value.integerValue;
                break;
            } else if ([childResourceDescriptor.wsType isEqualToString:constants.WS_TYPE_REFERENCE]) {
                JSResourceProperty *referenceURI = [childResourceDescriptor propertyByName:constants.PROP_FILERESOURCE_REFERENCE_URI];
                self.dataTypeUri = referenceURI.value;
                break;
            }
        }
    }

    // Get parameters that input control depends on
    if (self.query.length > 0) {
        [self resolveICDependenciesByRegex:@"\\$P\\{\\s*([\\w]*)\\s*\\}"];
        [self resolveICDependenciesByRegex:@"\\$P!\\{\\s*([\\w]*)\\s*\\}"];
        [self resolveICDependenciesByRegex:@"\\$X\\{[^{}]*,\\s*([\\w]*)\\s*\\}"];
    }

    if (self.type == constants.IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES ||
            self.type == constants.IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES_RADIO ||
            self.type == constants.IC_TYPE_MULTI_SELECT_LIST_OF_VALUES ||
            self.type == constants.IC_TYPE_MULTI_SELECT_LIST_OF_VALUES_CHECKBOX) {

        for (JSResourceDescriptor *childResourceDescriptor in resourceDescriptor.childResourceDescriptors) {
            if ([childResourceDescriptor.wsType isEqualToString:constants.WS_TYPE_LOV]) {
                JSResourceProperty *resourceProperty = [childResourceDescriptor propertyByName:constants.PROP_LOV];
                self.listOfValues = [resourceProperty.childResourceProperties mutableCopy];
                break;
            }
        }

    } else if (self.type == constants.IC_TYPE_SINGLE_SELECT_QUERY ||
            self.type == constants.IC_TYPE_SINGLE_SELECT_QUERY_RADIO ||
            self.type == constants.IC_TYPE_MULTI_SELECT_QUERY ||
            self.type == constants.IC_TYPE_MULTI_SELECT_QUERY_CHECKBOX) {

        JSResourceProperty *queryDataProperty = [resourceDescriptor propertyByName:constants.PROP_QUERY_DATA];
        if (queryDataProperty) {
            NSArray *queryData = queryDataProperty.childResourceProperties;
            // Rows
            for (JSResourceProperty *queryDataRow in queryData) {
                JSResourceProperty *property = [[JSResourceProperty alloc] init];
                property.name = queryDataRow.value;

                NSMutableString *value = [NSMutableString string];
                // Cols
                for (JSResourceProperty *queryDataCol in queryDataRow.childResourceProperties) {
                    if ([constants.PROP_QUERY_DATA_ROW_COLUMN isEqualToString:queryDataCol.name]) {
                        if (value.length > 0) [value appendString:@" | "];
                        [value appendString:queryDataCol.value];
                    }
                }

                property.value = value;
                [self.listOfValues addObject:property];
            }
        }
    }
}

- (void)addSlaveDependency:(JSInputControlWrapper *)inputControl {
    [self addInputControl:inputControl toArray:_slaveDependenciesRef];
}

- (void)removeSlaveDependency:(JSInputControlWrapper *)inputControl {
    [self removeInputControl:inputControl fromArray:_slaveDependenciesRef];
}

- (NSArray *)getSlaveDependencies {
    return (__bridge NSArray*) _slaveDependenciesRef;
}

- (void)addMasterDependency:(JSInputControlWrapper *)inputControl {
    [self addInputControl:inputControl toArray:_masterDependenciesRef];
}

- (void)removeMasterDependency:(JSInputControlWrapper *)inputControl {
    [self removeInputControl:inputControl fromArray:_masterDependenciesRef];
}

- (NSArray *)getMasterDependencies {
    return (__bridge NSArray*) _masterDependenciesRef;
}

#pragma mark - Private

- (void)addInputControl:(JSInputControlWrapper *)inputControl toArray:(CFMutableArrayRef)array {
    const void *value = (__bridge const void *) (inputControl);
    CFIndex index = [self indexOfValue:value inArray:array];
    if (index == -1) {
        CFArrayAppendValue(array, value);
    }
}

- (void)removeInputControl:(JSInputControlWrapper *)inputControl fromArray:(CFMutableArrayRef)array {
    CFIndex index = [self indexOfValue:(__bridge const void *) (inputControl) inArray:array];
    if (index != -1) {
        CFArrayRemoveValueAtIndex(array, index);
    }
}

- (CFIndex)indexOfValue:(const void *)value inArray:(CFMutableArrayRef)array {
    CFIndex count = CFArrayGetCount(array);
    CFRange range = CFRangeMake(0, count);
    return CFArrayGetFirstIndexOfValue(array, range, value);
}

- (void)resolveICDependenciesByRegex:(NSString *)pattern {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSArray *matches = [regex matchesInString:self.query options:0 range:NSMakeRange(0, self.query.length)];

    NSString *dependency;
    for (NSTextCheckingResult *result in matches) {
        dependency = [self.query substringWithRange:[result rangeAtIndex:1]];
        [self.parameterDependencies addObject:dependency];
    }
}

@end
