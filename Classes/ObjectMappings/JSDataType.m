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

@interface JSDataType ()
@property (nonatomic, strong) NSString *typeAsString;
@property (nonatomic, strong) NSString *strictMaxAsString;
@property (nonatomic, strong) NSString *strictMinAsString;
@property (nonatomic, strong) NSString *maxLengthAsString;
@end

@implementation JSDataType

#pragma mark - CustomAccessories

- (kJS_DT_TYPE)type {
    if ([self.typeAsString isEqualToString:@"text"]) {
        return kJS_DT_TYPE_TEXT;
    } else if ([self.typeAsString isEqualToString:@"number"]) {
        return kJS_DT_TYPE_NUMBER;
    } else if ([self.typeAsString isEqualToString:@"date"]) {
        return kJS_DT_TYPE_DATE;
    } else if ([self.typeAsString isEqualToString:@"time"]) {
        return kJS_DT_TYPE_TIME;
    } else if ([self.typeAsString isEqualToString:@"datetime"]) {
        return kJS_DT_TYPE_DATE_TIME;
    }
    
    return kJS_DT_TYPE_UNKNOWN;
}

- (NSInteger)maxLength {
    return [[self numberFromString:self.maxLengthAsString] integerValue];
}

- (BOOL)strictMax {
    return [JSUtils BOOLFromString:self.strictMaxAsString];
}

- (BOOL)strictMin {
    return [JSUtils BOOLFromString:self.strictMinAsString];
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
    return descriptorsArray;
}

+ (nonnull RKObjectMapping *)classMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    RKObjectMapping *classMapping = [RKObjectMapping mappingForClass:self];
    [classMapping addAttributeMappingsFromDictionary:@{
                                                       @"type"      : @"typeAsString",
                                                       @"strictMax" : @"strictMaxAsString",
                                                       @"strictMin" : @"strictMinAsString",
                                                       @"maxLength" : @"maxLengthAsString",
                                                       @"maxValue"  : @"maxValue",
                                                       @"minValue"  : @"minValue",
                                                       @"pattern"   :  @"pattern",
                                                       }];
    return classMapping;
}

+ (NSArray *)classMappingPathes {
    return @[@"dataType"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    if ([self isMemberOfClass: [JSDataType class]]) {
        JSDataType *newDatetype         = [[self class] allocWithZone:zone];
        newDatetype.typeAsString        = [self.typeAsString copyWithZone:zone];
        newDatetype.strictMaxAsString   = [self.strictMaxAsString copyWithZone:zone];
        newDatetype.strictMinAsString   = [self.strictMinAsString copyWithZone:zone];
        newDatetype.maxLengthAsString   = [self.maxLengthAsString copyWithZone:zone];
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
