/*
 * Copyright ©  2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSDataType.h"

@implementation JSDataType

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *typesDictionary = @{ @"text": @(kJS_DT_TYPE_TEXT),
                                      @"number": @(kJS_DT_TYPE_NUMBER),
                                      @"date": @(kJS_DT_TYPE_DATE),
                                      @"time": @(kJS_DT_TYPE_TIME),
                                      @"datetime": @(kJS_DT_TYPE_DATE_TIME)};

        [mapping mapPropertiesFromDictionary:@{
                                               @"strictMax" : @"strictMax",
                                               @"strictMin" : @"strictMin",
                                               @"maxLength" : @"maxLength",
                                               @"maxValue"  : @"maxValue",
                                               @"minValue"  : @"minValue",
                                               @"pattern"   : @"pattern",
                                               }];
        
        [mapping mapKeyPath:@"type" toProperty:@"type" withValueBlock:^(NSString *key, id value) {
            return typesDictionary[value];
        } reverseBlock:^id(id value) {
            return [typesDictionary allKeysForObject:value].lastObject;
        }];
    }];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSDataType *newDatetype         = [[self class] allocWithZone:zone];
    newDatetype->_type                = self.type;
    newDatetype->_strictMax           = self.strictMax;
    newDatetype->_strictMin           = self.strictMin;
    newDatetype->_maxLength           = self.maxLength;
    newDatetype->_pattern             = [self.pattern copyWithZone:zone];
    newDatetype->_maxValue            = [self.maxValue copyWithZone:zone];
    newDatetype->_minValue            = [self.minValue copyWithZone:zone];
    
    return newDatetype;
}

@end
