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

#import "JSInputControlOption.h"
#import "JSInputControlDescriptor.h"

@interface JSInputControlDescriptor()
@property (nonatomic, retain) NSArray *validationRules;

@end

@implementation JSInputControlDescriptor
@dynamic mandatoryValidationRule;
@dynamic dateTimeFormatValidationRule;

- (JSMandatoryValidationRule *)mandatoryValidationRule {
    return [self validationRuleForClass:[JSMandatoryValidationRule class]];
}

- (JSDateTimeFormatValidationRule *)dateTimeFormatValidationRule {
    return [self validationRuleForClass:[JSDateTimeFormatValidationRule class]];
}

- (NSString *)errorString{
    if (self.mandatoryValidationRule && [self.selectedValues count] == 0) {
        return self.mandatoryValidationRule.errorMessage;
    } else if ([self.state.error length]) {
        return self.state.error;
    }
    if (self.dataType && [self isSingleValueInputControl] && self.state.value) {
        id valueObject, minValue, maxValue;
        switch (self.dataType.type) {
            case kJS_DT_TYPE_DATE:
            case kJS_DT_TYPE_DATE_TIME:
            case kJS_DT_TYPE_TIME: {
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                dateFormatter.dateFormat = self.dateTimeFormatValidationRule.format;
                valueObject = [dateFormatter dateFromString:self.state.value];
                minValue = [dateFormatter dateFromString:self.dataType.minValue];
                maxValue = [dateFormatter dateFromString:self.dataType.maxValue];
                break;
            }
            case kJS_DT_TYPE_NUMBER: {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                valueObject = [formatter numberFromString:self.state.value];
                minValue = [formatter numberFromString:self.dataType.minValue];
                maxValue = [formatter numberFromString:self.dataType.maxValue];
                break;
            }
            case kJS_DT_TYPE_TEXT: {
                valueObject = self.state.value;
                if (self.dataType.maxLength > 0 && [valueObject length] > self.dataType.maxLength) {
                    return JSCustomLocalizedString(@"inputcontrol.datatype.validation.very.long", nil);
                }
                if (valueObject && self.dataType.pattern) {
                    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.dataType.pattern];
                    if (![predicate evaluateWithObject:self.state.value]) {
                        return JSCustomLocalizedString(@"inputcontrol.datatype.validation.doesn't.match.pattern", nil);
                    }
                }
                break;
            }
            default:
                break;
        }
        if (valueObject) {
            if ([valueObject respondsToSelector:@selector(compare:)]) {
                if (minValue) {
                    NSComparisonResult minValueResult = [valueObject compare:minValue];
                    if (minValueResult == NSOrderedAscending) {
                        return JSCustomLocalizedString(@"inputcontrol.datatype.validation.less.than", nil);
                    } else if (minValueResult == NSOrderedSame && self.dataType.strictMin){
                        return JSCustomLocalizedString(@"inputcontrol.datatype.validation.less.than.or.equal", nil);
                    }
                }
                if (maxValue) {
                    NSComparisonResult maxValueResult = [valueObject compare:maxValue];
                    if (maxValueResult == NSOrderedDescending) {
                        return JSCustomLocalizedString(@"inputcontrol.datatype.validation.greater.than", nil);
                    } else if (maxValueResult == NSOrderedSame && self.dataType.strictMax){
                        return JSCustomLocalizedString(@"inputcontrol.datatype.validation.greater.than.or.equal", nil);
                    }
                }
            }
        }
    }
    return nil;
}

- (NSArray *)selectedValues {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSString *type = self.type;
    
    if ([self isSingleValueInputControl]) {
        if ([kJS_ICD_TYPE_BOOL isEqualToString:self.type] && [self.state.error length]) {
            self.state.value = [JSUtils stringFromBOOL:NO];
            self.state.error = nil;
        }
        if (self.state.value) {
            [values addObject:self.state.value];
        }
    } else if ([kJS_ICD_TYPE_SINGLE_SELECT isEqualToString:type] ||
               [kJS_ICD_TYPE_SINGLE_SELECT_RADIO isEqualToString:type]) {
        for (JSInputControlOption *option in self.state.options) {
            if (option.selected.boolValue) {
                [values addObject:option.value];
                break;
            }
        }
    } else if ([kJS_ICD_TYPE_MULTI_SELECT isEqualToString:type] ||
               [kJS_ICD_TYPE_MULTI_SELECT_CHECKBOX isEqualToString:type]) {
        for (JSInputControlOption *option in self.state.options) {
            if (option.selected.boolValue) {
                [values addObject:option.value];
            }
        }
    }
    
    return values;
}

#pragma mark - JSSerializationDescriptorHolder
+ (nonnull NSArray <RKResponseDescriptor *> *)rkResponseDescriptorsForServerProfile:(nonnull JSProfile *)serverProfile {
    NSMutableArray *descriptorsArray = [NSMutableArray array];
    for (NSString *keyPath in [self classMappingPathes]) {
        [descriptorsArray addObject:[RKResponseDescriptor responseDescriptorWithMapping:[self classMappingForServerProfile:serverProfile]
                                                                                 method:RKRequestMethodAny
                                                                            pathPattern:nil
                                                                                keyPath:keyPath
                                                                            statusCodes:nil]];
    }
    [descriptorsArray addObjectsFromArray:[JSInputControlOption rkResponseDescriptorsForServerProfile:serverProfile]];
    
    return descriptorsArray;
}

+ (nonnull RKObjectMapping *)classMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    RKObjectMapping *classMapping = [RKObjectMapping mappingForClass:self];
    [classMapping addAttributeMappingsFromDictionary:@{
                                                       @"id": @"uuid",
                                                       @"uri": @"uri",
                                                       @"label": @"label",
                                                       @"mandatory": @"mandatory",
                                                       @"readOnly": @"readOnly",
                                                       @"type": @"type",
                                                       @"visible": @"visible",
                                                       @"masterDependencies": @"masterDependencies",
                                                       @"slaveDependencies": @"slaveDependencies",
                                                       @"masterSingleInputControlID": @"masterSingleInputControlID",
                                                       @"slaveSingleInputControlID": @"slaveSingleInputControlID",
                                                       }];
    [classMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"state"
                                                                                 toKeyPath:@"state"
                                                                               withMapping:[JSInputControlState classMappingForServerProfile:serverProfile]]];

    [classMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dataType"
                                                                                 toKeyPath:@"dataType"
                                                                               withMapping:[JSDataType classMappingForServerProfile:serverProfile]]];

    RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
    [dynamicMapping setObjectMappingForRepresentationBlock:^RKObjectMapping *(id representation) {
        id key = [[representation allKeys] lastObject];
        if ([key isKindOfClass:[NSString class]] && [key isEqualToString:@"mandatoryValidationRule"]) {
            return [JSMandatoryValidationRule classMappingForServerProfile:serverProfile];
        } else if ([key isKindOfClass:[NSString class]] && [key isEqualToString:@"dateTimeFormatValidationRule"]) {
            return [JSDateTimeFormatValidationRule classMappingForServerProfile:serverProfile];
        }
        return nil;
    }];
    [classMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"validationRules"
                                                                                 toKeyPath:@"validationRules"
                                                                               withMapping:dynamicMapping]];
    
    return classMapping;
}

+ (NSArray *)classMappingPathes {
    return @[@"inputControl"];
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
        newInputControlDescriptor.dataType              = [self.dataType copyWithZone:zone];
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

#pragma mark - Private API
- (id) validationRuleForClass:(Class)class {
    for (id rule in self.validationRules) {
        if ([rule isKindOfClass:class]) {
            return rule;
        }
    }
    return nil;
}

- (BOOL) isSingleValueInputControl {
    return ([kJS_ICD_TYPE_BOOL isEqualToString:self.type] ||
            [kJS_ICD_TYPE_SINGLE_VALUE_TEXT isEqualToString:self.type] ||
            [kJS_ICD_TYPE_SINGLE_VALUE_NUMBER isEqualToString:self.type] ||
            [kJS_ICD_TYPE_SINGLE_VALUE_DATE isEqualToString:self.type] ||
            [kJS_ICD_TYPE_SINGLE_VALUE_TIME isEqualToString:self.type] ||
            [kJS_ICD_TYPE_SINGLE_VALUE_DATETIME isEqualToString:self.type]);
}

@end
