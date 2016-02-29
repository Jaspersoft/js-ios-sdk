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
//  JSInputControlState.m
//  Jaspersoft Corporation
//

#import "JSInputControlState.h"

@implementation JSInputControlState

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"id": @"uuid",
                                               @"uri": @"uri",
                                               @"value": @"value",
                                               @"error": @"error",
                                               }];
        [mapping hasMany:[JSInputControlOption class] forKeyPath:@"options" forProperty:@"options" withObjectMapping:[JSInputControlOption objectMappingForServerProfile:serverProfile]];
        
    }];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    if ([self isMemberOfClass: [JSInputControlState class]]) {
        JSInputControlState *newInputControlState = [[self class] allocWithZone:zone];
        newInputControlState.uuid       = [self.uuid copyWithZone:zone];
        newInputControlState.uri        = [self.uri copyWithZone:zone];
        newInputControlState.value      = [self.value copyWithZone:zone];
        newInputControlState.error      = [self.error copyWithZone:zone];
        if (self.options) {
            newInputControlState.options    = [[NSArray alloc] initWithArray:self.options copyItems:YES];
        }
        return newInputControlState;
    } else {
        NSString *messageString = [NSString stringWithFormat:@"You need to implement \"copyWithZone:\" method in %@",NSStringFromClass([self class])];
        @throw [NSException exceptionWithName:@"Method implementation is missing" reason:messageString userInfo:nil];
    }
}
@end
