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
//  JSReportExecutionRequest.m
//  Jaspersoft Corporation
//

#import "JSReportExecutionRequest.h"
#import "JSServerInfo.h"
#import "JSConstants.h"

@implementation JSReportExecutionRequest

#pragma mark - JSSerializationDescriptorHolder

+ (nonnull NSArray <RKRequestDescriptor *> *)rkRequestDescriptorsForServerProfile:(nonnull JSProfile *)serverProfile {
    NSMutableArray *descriptorsArray = [NSMutableArray array];
    [descriptorsArray addObject:[RKRequestDescriptor requestDescriptorWithMapping:[[self classMappingForServerProfile:serverProfile] inverseMapping]
                                                                      objectClass:self
                                                                      rootKeyPath:nil
                                                                           method:RKRequestMethodAny]];
    return descriptorsArray;
}

+ (nonnull RKObjectMapping *)classMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    RKObjectMapping *classMapping = [RKObjectMapping mappingForClass:self];
    [classMapping addAttributeMappingsFromDictionary:@{
                                                       @"reportUnitUri": @"reportUnitUri",
                                                       @"async": @"async",
                                                       @"outputFormat": @"outputFormat",
                                                       @"interactive": @"interactive",
                                                       @"freshData": @"freshData",
                                                       @"saveDataSnapshot": @"saveDataSnapshot",
                                                       @"ignorePagination": @"ignorePagination",
                                                       @"transformerKey": @"transformerKey",
                                                       @"pages": @"pages",
                                                       @"attachmentsPrefix": @"attachmentsPrefix",
                                                       }];
    if (serverProfile && serverProfile.serverInfo.versionAsFloat >= [JSConstants sharedInstance].SERVER_VERSION_CODE_EMERALD_5_6_0) {
        [classMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"baseUrl" toKeyPath:@"baseURL"]];
    }
    
    [classMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"parameters.reportParameter"
                                                                                 toKeyPath:@"parameters"
                                                                               withMapping:[JSReportParameter classMappingForServerProfile:serverProfile]]];

    return classMapping;
}

@end
