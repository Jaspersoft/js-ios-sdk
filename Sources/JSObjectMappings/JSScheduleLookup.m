/*
 * TIBCO JasperMobile for iOS
 * Copyright © 2005-2016 TIBCO Software, Inc. All rights reserved.
 * http://community.jaspersoft.com/project/jaspermobile-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/lgpl>.
 */


//
//  JSScheduleLookup.m
//  TIBCO JasperMobile
//

#import "JSScheduleLookup.h"
#import "JSScheduleJobState.h"


@implementation JSScheduleLookup

+ (nonnull NSString *)resourceRootKeyPath
{
    return @"scheduleLookup";
}

#pragma mark - EKMappingProtocol
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
//            @"id"                          : @"jobIdentifier",
//            @"version"                     : @"version",
//            @"reportUnitURI"               : @"reportUnitURI",
//            @"label"                       : @"label",
//            @"description"                 : @"scheduleDescription",
//            @"owner"                       : @"owner",
//            @"reportLabel"                 : @"reportLabel",
//            // trigger
//            @"reportLabel"                 : @"reportLabel",
//            // may be source parameters
//            @"baseOutputFilename"          : @"baseOutputFilename",
//            @"outputLocale"                : @"outputLocale",
//            @"mailNotification"            : @"mailNotification",
//            @"alert"                       : @"alert",
//            @"outputFormats.outputFormat"  : @"outputFormats",
//    }];
//
//    [classMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"state"
//                                                                                 toKeyPath:@"state"
//                                                                               withMapping:[JSScheduleJobState classMappingForServerProfile:serverProfile]]];
//
//    return classMapping;
//}
//
//+ (nonnull NSArray *)classMappingPathes {
//    return @[[self resourceRootKeyPath], @"jobsummary"];
//}


@end