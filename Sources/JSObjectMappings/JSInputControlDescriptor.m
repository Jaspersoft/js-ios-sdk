/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSInputControlOption.h"
#import "JSInputControlDescriptor.h"
#import "EKMapper.h"

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
    if (self.dataType && self.state.value) {
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
                    return JSCustomLocalizedString(@"inputcontrol_datatype_validation_very_long", nil);
                }
                if (valueObject && self.dataType.pattern) {
                    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.dataType.pattern];
                    if (![predicate evaluateWithObject:self.state.value]) {
                        return JSCustomLocalizedString(@"inputcontrol_datatype_validation_doesn't_match_pattern", nil);
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
                        return JSCustomLocalizedString(@"inputcontrol_datatype_validation_less_than", nil);
                    } else if (minValueResult == NSOrderedSame && self.dataType.strictMin){
                        return JSCustomLocalizedString(@"inputcontrol_datatype_validation_less_than_or_equal", nil);
                    }
                }
                if (maxValue) {
                    NSComparisonResult maxValueResult = [valueObject compare:maxValue];
                    if (maxValueResult == NSOrderedDescending) {
                        return JSCustomLocalizedString(@"inputcontrol_datatype_validation_greater_than", nil);
                    } else if (maxValueResult == NSOrderedSame && self.dataType.strictMax){
                        return JSCustomLocalizedString(@"inputcontrol_datatype_validation_greater_than_or_equal", nil);
                    }
                }
            }
        }
    }
    return nil;
}

- (NSArray *)selectedValues {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    switch (self.type) {
        case kJS_ICD_TYPE_BOOL:
            if ([self.state.error length]) {
                self.state.value = [JSUtils stringFromBOOL:NO];
                self.state.error = nil;
            }
        case kJS_ICD_TYPE_SINGLE_VALUE_TEXT:
        case kJS_ICD_TYPE_SINGLE_VALUE_NUMBER:
        case kJS_ICD_TYPE_SINGLE_VALUE_DATE:
        case kJS_ICD_TYPE_SINGLE_VALUE_TIME:
        case kJS_ICD_TYPE_SINGLE_VALUE_DATETIME: {
            if (self.state.value) {
                [values addObject:self.state.value];
            }
            break;
        }
        case kJS_ICD_TYPE_SINGLE_SELECT:
        case kJS_ICD_TYPE_SINGLE_SELECT_RADIO:{
            for (JSInputControlOption *option in self.state.options) {
                if (option.selected) {
                    [values addObject:option.value];
                    break;
                }
            }
            break;
        }
        case kJS_ICD_TYPE_MULTI_SELECT:
        case kJS_ICD_TYPE_MULTI_SELECT_CHECKBOX:{
            for (JSInputControlOption *option in self.state.options) {
                if (option.selected) {
                    [values addObject:option.value];
                }
            }
            break;
        }
    }
    return values;
}

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"id": @"uuid",
                                               @"uri": @"uri",
                                               @"label": @"label",
                                               @"mandatory": @"mandatory",
                                               @"readOnly": @"readOnly",
                                               @"type": @"type",
                                               @"visible": @"visible",
                                               @"masterDependencies": @"masterDependencies",
                                               @"slaveDependencies": @"slaveDependencies"
                                               }];
        
        [mapping hasOne:[JSInputControlState class] forKeyPath:@"state" forProperty:@"state" withObjectMapping:[JSInputControlState objectMappingForServerProfile:serverProfile]];
        [mapping hasOne:[JSDataType class] forKeyPath:@"dataType" forProperty:@"dataType" withObjectMapping:[JSDataType objectMappingForServerProfile:serverProfile]];

        NSDictionary *typesArray = @{ @"bool":                  @(kJS_ICD_TYPE_BOOL),
                                      @"singleValueText":       @(kJS_ICD_TYPE_SINGLE_VALUE_TEXT),
                                      @"singleValueNumber":     @(kJS_ICD_TYPE_SINGLE_VALUE_NUMBER),
                                      @"singleValueDate":       @(kJS_ICD_TYPE_SINGLE_VALUE_DATE),
                                      @"singleValueTime":       @(kJS_ICD_TYPE_SINGLE_VALUE_TIME),
                                      @"singleValueDatetime":   @(kJS_ICD_TYPE_SINGLE_VALUE_DATETIME),
                                      @"singleSelect":          @(kJS_ICD_TYPE_SINGLE_SELECT),
                                      @"singleSelectRadio":     @(kJS_ICD_TYPE_SINGLE_SELECT_RADIO),
                                      @"multiSelect":           @(kJS_ICD_TYPE_MULTI_SELECT),
                                      @"multiSelectCheckbox":   @(kJS_ICD_TYPE_MULTI_SELECT_CHECKBOX)};
        
        [mapping mapKeyPath:@"type" toProperty:@"type" withValueBlock:^(NSString *key, id value) {
            return typesArray[value];
        } reverseBlock:^id(id value) {
            return [typesArray allKeysForObject:value].lastObject;
        }];

        
        [mapping mapKeyPath:@"validationRules" toProperty:@"validationRules" withValueBlock:^id(NSString *key, id value) {
            NSArray *validationRulesArray = value;
            NSMutableArray *validationRules = [NSMutableArray array];
            for (NSDictionary *rule in validationRulesArray) {
                EKObjectMapping *mapping = nil;
                NSString *rootKey = [[rule allKeys] lastObject];
                if ([rootKey isEqualToString:@"mandatoryValidationRule"]) {
                    mapping = [JSMandatoryValidationRule objectMappingForServerProfile:serverProfile];
                } else if ([rootKey isEqualToString:@"dateTimeFormatValidationRule"]){
                    mapping = [JSDateTimeFormatValidationRule objectMappingForServerProfile:serverProfile];
                }
                if (mapping) {
                    [validationRules addObject:[EKMapper objectFromExternalRepresentation:[rule objectForKey:rootKey] withMapping:mapping]];
                }
            }
            return validationRules;
        }];
    }];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSInputControlDescriptor *newInputControlDescriptor = [[self class] allocWithZone:zone];
    newInputControlDescriptor.uuid                  = [self.uuid copyWithZone:zone];
    newInputControlDescriptor.label                 = [self.label copyWithZone:zone];
    newInputControlDescriptor.mandatory             = [self.mandatory copyWithZone:zone];
    newInputControlDescriptor.readOnly              = [self.readOnly copyWithZone:zone];
    newInputControlDescriptor.uri                   = [self.uri copyWithZone:zone];
    newInputControlDescriptor.visible               = [self.visible copyWithZone:zone];
    newInputControlDescriptor.state                 = [self.state copyWithZone:zone];
    newInputControlDescriptor.validationRules       = [self.validationRules copyWithZone:zone];
    newInputControlDescriptor.dataType              = [self.dataType copyWithZone:zone];
    newInputControlDescriptor.type                  = self.type;
    if (self.masterDependencies) {
        newInputControlDescriptor.masterDependencies    = [[NSArray alloc] initWithArray:self.masterDependencies copyItems:YES];
    }
    if (self.slaveDependencies) {
        newInputControlDescriptor.slaveDependencies     = [[NSArray alloc] initWithArray:self.slaveDependencies copyItems:YES];
    }
    return newInputControlDescriptor;
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

@end
