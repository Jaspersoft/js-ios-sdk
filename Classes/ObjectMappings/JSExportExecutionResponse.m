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
//  JSExportExecutionResponse.m
//  Jaspersoft Corporation
//

#import "JSExportExecutionResponse.h"
#import "JSReportAttachment.h"

@implementation JSExportExecutionResponse

#pragma mark - JSSerializationDescriptorHolder

+ (NSArray <RKRequestDescriptor *> *)rkRequestDescriptorsForServerProfile:(JSProfile *)serverProfile {
    NSMutableArray *descriptorsArray = [NSMutableArray array];
    [descriptorsArray addObject:[RKRequestDescriptor requestDescriptorWithMapping:[[self classMappingForServerProfile:serverProfile] inverseMapping]
                                                                      objectClass:self
                                                                      rootKeyPath:@"exportExecution"
                                                                           method:RKRequestMethodAny]];
    return descriptorsArray;
}

+ (NSArray <RKResponseDescriptor *> *)rkResponseDescriptorsForServerProfile:(JSProfile *)serverProfile {
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

+ (RKObjectMapping *)classMappingForServerProfile:(JSProfile *)serverProfile {
    RKObjectMapping *classMapping = [RKObjectMapping mappingForClass:self];
    [classMapping addAttributeMappingsFromDictionary:@{
                                                       @"id": @"uuid",
                                                       }];
    [classMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"status"
                                                                            toKeyPath:@"status"
                                                                          withMapping:[JSExecutionStatus customMapping]]];

    [classMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"errorDescriptor"
                                                                                 toKeyPath:@"errorDescriptor"
                                                                               withMapping:[JSErrorDescriptor classMappingForServerProfile:serverProfile]]];
    
    [classMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"outputResource"
                                                                                 toKeyPath:@"outputResource"
                                                                               withMapping:[JSReportOutputResource classMappingForServerProfile:serverProfile]]];

    [classMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"attachments"
                                                                                 toKeyPath:@"attachments"
                                                                               withMapping:[JSReportOutputResource classMappingForServerProfile:serverProfile]]];
    return classMapping;
}

+ (NSArray *)classMappingPathes {
    return @[@""];
}

@end
