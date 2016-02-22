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
//  JSExecutionStatus.m
//  Jaspersoft Corporation
//

#import "JSExecutionStatus.h"

NSString *const kJSExecutionStatusReady = @"ready";
NSString *const kJSExecutionStatusQueued = @"queued";
NSString *const kJSExecutionStatusExecution = @"execution";
NSString *const kJSExecutionStatusCancelled = @"cancelled";
NSString *const kJSExecutionStatusFailed = @"failed";


@implementation JSExecutionStatus

- (kJS_EXECUTION_STATUS)status {
    if ([self.statusAsString isEqualToString:kJSExecutionStatusReady]) {
        return kJS_EXECUTION_STATUS_READY;
    } else if ([self.statusAsString isEqualToString:kJSExecutionStatusQueued]) {
        return kJS_EXECUTION_STATUS_QUEUED;
    } else if ([self.statusAsString isEqualToString:kJSExecutionStatusExecution]) {
        return kJS_EXECUTION_STATUS_EXECUTION;
    } else if ([self.statusAsString isEqualToString:kJSExecutionStatusCancelled]) {
        return kJS_EXECUTION_STATUS_CANCELED;
    } else if ([self.statusAsString isEqualToString:kJSExecutionStatusFailed]) {
        return kJS_EXECUTION_STATUS_FAILED;
    }
    return kJS_EXECUTION_STATUS_UNKNOWN;
}

- (NSString *)description {
    return self.statusAsString;
}

//+ (nonnull RKObjectMapping *)customMapping {
//    RKObjectMapping *classMapping = [RKObjectMapping mappingForClass:self];
//    [classMapping addAttributeMappingsFromDictionary:@{
//                                                       @"description": @"statusAsString",
//                                                       }];
//    return classMapping;
//}

#pragma mark - JSObjectMappingsProtocol

//+ (nonnull NSArray <RKRequestDescriptor *> *)rkRequestDescriptorsForServerProfile:(nonnull JSProfile *)serverProfile {
//    NSMutableArray *descriptorsArray = [NSMutableArray array];
//    [descriptorsArray addObject:[RKRequestDescriptor requestDescriptorWithMapping:[[self classMappingForServerProfile:serverProfile] inverseMapping]
//                                                                      objectClass:self
//                                                                      rootKeyPath:nil
//                                                                           method:JSRequestHTTPMethodAny]];
//    return descriptorsArray;
//}
//
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
//+ (nonnull RKObjectMapping *)classMappingForServerProfile:(nonnull JSProfile *)serverProfile {
//    RKObjectMapping *classMapping = [RKObjectMapping mappingForClass:self];
//    [classMapping addAttributeMappingsFromDictionary:@{
//                                                       @"value": @"statusAsString",
//                                                       }];
//    return classMapping;;
//}
//
//+ (nonnull NSArray *)classMappingPathes {
//    return @[@""];
//}

@end
