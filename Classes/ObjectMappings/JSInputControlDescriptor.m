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
//  JSInputControlDescriptor.m
//  Jaspersoft Corporation
//

#import "JSConstants.h"
#import "JSInputControlOption.h"
#import "JSInputControlDescriptor.h"

@implementation JSInputControlDescriptor

@synthesize uuid = _uuid;
@synthesize label = _label;
@synthesize mandatory = _mandatory;
@synthesize readOnly = _readOnly;
@synthesize type = _type;
@synthesize uri = _uri;
@synthesize visible = _visible;
@synthesize masterDependencies = _masterDependencies;
@synthesize slaveDependencies = _slaveDependencies;
@synthesize state = _state;
@synthesize validationRules = _validationRules;
@synthesize masterSingleInputControlID = _masterSingleInputControlID;
@synthesize slaveSingleInputControlID = _slaveSingleInputControlID;

- (NSArray *)masterDependencies {
    if (!_masterDependencies.count && _masterSingleInputControlID.length) {
        _masterDependencies = [[NSArray alloc] initWithObjects:_masterSingleInputControlID, nil];
    }
    
    return _masterDependencies;
}

- (NSArray *)slaveDependencies {
    if (!_slaveDependencies.count && _slaveSingleInputControlID.length) {
        _slaveDependencies = [[NSArray alloc] initWithObjects:_slaveSingleInputControlID, nil];
    }
    
    return _slaveDependencies;
}

- (NSString *)errorString{
    if (self.validationRules.mandatoryValidationRule && self.state.value == nil) {
        return self.validationRules.mandatoryValidationRule.errorMessage;
    } else if ([self.state.error length]) {
        return self.state.error;
    }
    return nil;
}

- (NSArray *)selectedValues {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    JSConstants *constants = [JSConstants sharedInstance];
    NSString *type = self.type;
    
    if ([constants.ICD_TYPE_BOOL isEqualToString:type] ||
        [constants.ICD_TYPE_SINGLE_VALUE_TEXT isEqualToString:type] ||
        [constants.ICD_TYPE_SINGLE_VALUE_NUMBER isEqualToString:type] ||
        [constants.ICD_TYPE_SINGLE_VALUE_DATE isEqualToString:type] ||
        [constants.ICD_TYPE_SINGLE_VALUE_TIME isEqualToString:type] ||
        [constants.ICD_TYPE_SINGLE_VALUE_DATETIME isEqualToString:type]) {
        if (self.state.value) {
            [values addObject:self.state.value];
        }
    } else if ([constants.ICD_TYPE_SINGLE_SELECT isEqualToString:type] ||
               [constants.ICD_TYPE_SINGLE_SELECT_RADIO isEqualToString:type]) {
        for (JSInputControlOption *option in self.state.options) {
            if (option.selected.boolValue) {
                [values addObject:option.value];
                break;
            }
        }
    } else if ([constants.ICD_TYPE_MULTI_SELECT isEqualToString:type] ||
               [constants.ICD_TYPE_MULTI_SELECT_CHECKBOX isEqualToString:type]) {
        for (JSInputControlOption *option in self.state.options) {
            if (option.selected.boolValue) {
                [values addObject:option.value];
            }
        }
    }
    
    return values;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    if ([self isMemberOfClass: [JSInputControlDescriptor class]]) {
        JSInputControlDescriptor *newInputControlDescriptor = [[self class] allocWithZone:zone];
        newInputControlDescriptor.uuid                  = [self.uuid copyWithZone:zone];
        newInputControlDescriptor.label                 = [self.label copyWithZone:zone];
        newInputControlDescriptor.mandatory             = [self.mandatory copyWithZone:zone];
        newInputControlDescriptor.readOnly              = [self.readOnly copyWithZone:zone];
        newInputControlDescriptor.type                  = [self.type copyWithZone:zone];
        newInputControlDescriptor.uri                   = [self.uri copyWithZone:zone];
        newInputControlDescriptor.visible               = [self.visible copyWithZone:zone];
        newInputControlDescriptor.state                 = [self.state copyWithZone:zone];
        newInputControlDescriptor.validationRules       = [self.validationRules copyWithZone:zone];
        newInputControlDescriptor.masterSingleInputControlID = [self.masterSingleInputControlID copyWithZone:zone];
        newInputControlDescriptor.slaveSingleInputControlID = [self.slaveSingleInputControlID copyWithZone:zone];
        if (self.masterDependencies) {
            newInputControlDescriptor.masterDependencies    = [[NSArray alloc] initWithArray:self.masterDependencies copyItems:YES];
        }
        if (self.slaveDependencies) {
            newInputControlDescriptor.slaveDependencies     = [[NSArray alloc] initWithArray:self.slaveDependencies copyItems:YES];
        }
        return newInputControlDescriptor;
    } else {
        NSString *messageString = [NSString stringWithFormat:@"You need to implement \"copyWithZone:\" method in %@",NSStringFromClass([self class])];
        @throw [NSException exceptionWithName:@"Method implementation is missing" reason:messageString userInfo:nil];
    }
}
@end
