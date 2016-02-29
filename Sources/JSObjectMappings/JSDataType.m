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
//  JSDataType.m
//  Jaspersoft Corporation
//

#import "JSDataType.h"

@implementation JSDataType

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *typesArray = @{ @"text": @(kJS_DT_TYPE_TEXT),
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
            return typesArray[value];
        } reverseBlock:^id(id value) {
            return [typesArray allKeysForObject:value].lastObject;
        }];
    }];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    if ([self isMemberOfClass: [JSDataType class]]) {
        JSDataType *newDatetype         = [[self class] allocWithZone:zone];
        newDatetype->_type                = self.type;
        newDatetype->_strictMax           = self.strictMax;
        newDatetype->_strictMin           = self.strictMin;
        newDatetype->_maxLength           = self.maxLength;
        newDatetype->_pattern             = [self.pattern copyWithZone:zone];
        newDatetype->_maxValue            = [self.maxValue copyWithZone:zone];
        newDatetype->_minValue            = [self.minValue copyWithZone:zone];
        
        return newDatetype;
    } else {
        NSString *messageString = [NSString stringWithFormat:@"You need to implement \"copyWithZone:\" method in \"%@\" subclass",NSStringFromClass([self class])];
        @throw [NSException exceptionWithName:@"Method implementation is missing" reason:messageString userInfo:nil];
    }
}

#pragma mark - Utils
- (NSNumber *)numberFromString:(NSString *)string {
    NSNumber *number = nil;
    if (string && [string isKindOfClass:[NSString class]]) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        number = [formatter numberFromString:string];
    }
    return number;
}
@end
