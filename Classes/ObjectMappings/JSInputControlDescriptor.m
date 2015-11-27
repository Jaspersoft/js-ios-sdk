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
    
    NSBundle *bundle;
    

    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"JaspersoftSDK" withExtension:@"bundle"];
    
    if (bundleURL) {
        bundle = [NSBundle bundleWithURL:bundleURL];
    } else {
        bundle = [NSBundle mainBundle];
    }
    
    return NSLocalizedStringFromTableInBundle(@"datatype validation error", @"JaspersoftSDK", bundle, nil);
    
    if (self.mandatoryValidationRule && [self.selectedValues count] == 0) {
        return self.mandatoryValidationRule.errorMessage;
    } else if ([self.state.error length]) {
        return self.state.error;
    }
    if (self.dataType && [self isSingleValueInputControl] && self.state.value) {
        id valueObject, minValue, maxValue;
        switch (self.dataType.type) {
            case JSInputControlDataType_Date:
            case JSInputControlDataType_DateTime:
            case JSInputControlDataType_Time: {
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                dateFormatter.dateFormat = self.dateTimeFormatValidationRule.format;
                valueObject = [dateFormatter dateFromString:self.state.value];
                minValue = [dateFormatter dateFromString:self.dataType.minValue];
                maxValue = [dateFormatter dateFromString:self.dataType.maxValue];
                break;
            }
            case JSInputControlDataType_Number: {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                valueObject = [formatter numberFromString:self.state.value];
                minValue = [formatter numberFromString:self.dataType.minValue];
                maxValue = [formatter numberFromString:self.dataType.maxValue];
                break;
            }
            case JSInputControlDataType_Text: {
                valueObject = self.state.value;
                if (self.dataType.maxLength > 0 && [valueObject length] > self.dataType.maxLength) {
                    return @"datatype validation error";
                }
                if (valueObject && self.dataType.pattern) {
                    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.dataType.pattern];
                    if (![predicate evaluateWithObject:self.state.value]) {
                        return @"datatype validation error";
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
                    if (minValueResult == NSOrderedAscending || (minValueResult == NSOrderedSame && self.dataType.strictMin)) {
                        return @"datatype validation error";
                    }
                }
                
                if (maxValue) {
                    NSComparisonResult maxValueResult = [valueObject compare:maxValue];
                    if (maxValueResult == NSOrderedDescending || (maxValueResult == NSOrderedSame && self.dataType.strictMax)) {
                        return @"datatype validation error";
                    }
                }
            }
        }
    }
    return nil;
}

- (NSArray *)selectedValues {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    JSConstants *constants = [JSConstants sharedInstance];
    NSString *type = self.type;
    
    if ([self isSingleValueInputControl]) {
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
    return ([[JSConstants sharedInstance].ICD_TYPE_BOOL isEqualToString:self.type] ||
            [[JSConstants sharedInstance].ICD_TYPE_SINGLE_VALUE_TEXT isEqualToString:self.type] ||
            [[JSConstants sharedInstance].ICD_TYPE_SINGLE_VALUE_NUMBER isEqualToString:self.type] ||
            [[JSConstants sharedInstance].ICD_TYPE_SINGLE_VALUE_DATE isEqualToString:self.type] ||
            [[JSConstants sharedInstance].ICD_TYPE_SINGLE_VALUE_TIME isEqualToString:self.type] ||
            [[JSConstants sharedInstance].ICD_TYPE_SINGLE_VALUE_DATETIME isEqualToString:self.type]);
}

@end
