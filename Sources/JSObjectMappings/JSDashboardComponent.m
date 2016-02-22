/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2016 Jaspersoft Corporation. All rights reserved.
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
//  JSDashboardComponent.h
//  Jaspersoft Corporation
//
#import "JSDashboardComponent.h"


@implementation JSDashboardComponent

+ (nonnull NSString *)resourceRootKeyPath
{
    return @"dashboardComponent";
}

#pragma mark - JSObjectMappingsProtocol
//+ (nonnull NSArray <RKResponseDescriptor *> *)rkResponseDescriptorsForServerProfile:(nonnull JSProfile *)serverProfile {
//    NSMutableArray *descriptorsArray = [NSMutableArray array];
//    for (NSString *keyPath in [self classMappingPathes]) {
//        [descriptorsArray addObject:[RKResponseDescriptor responseDescriptorWithMapping:[self classMappingForServerProfile:serverProfile]
//                                                                                 method:JSRequestHTTPMethodAny
//                                                                            pathPattern:nil
//                                                                                keyPath:keyPath
//                                                                            statusCodes:nil]];
//    }
//    return descriptorsArray;
//}
//
//+ (nonnull RKObjectMapping *)classMappingForServerProfile:(nonnull JSProfile *)serverProfile
//{
//    RKObjectMapping *classMapping = [RKObjectMapping mappingForClass:self];
//    [classMapping addAttributeMappingsFromDictionary:@{
//            @"id"                        : @"identifier",
//            @"type"                      : @"type",
//            @"label"                     : @"label",
//            @"name"                      : @"name",
//            @"resourceId"                : @"resourceId",
//            @"resource"                  : @"resourceURI",
//            @"ownerResourceId"           : @"ownerResourceURI",
//            @"ownerResourceParameterName": @"ownerResourceParameterName",
//    }];
//    return classMapping;
//}
//
//+ (nonnull NSArray *)classMappingPathes {
//    return @[[self resourceRootKeyPath], @""];
//}

@end