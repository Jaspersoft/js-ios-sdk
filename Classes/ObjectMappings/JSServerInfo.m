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
//  JSServerInfo.m
//  Jaspersoft Corporation
//

#import "JSServerInfo.h"

@implementation JSServerInfo

- (float)versionAsFloat {
    NSString *simplyVersionString = self.version;
    NSRange firstDotRange = [self.version rangeOfString:@"."];
    if (firstDotRange.location != NSNotFound) {
        NSRange minorVersionRange = NSMakeRange(firstDotRange.location + firstDotRange.length, self.version.length - (firstDotRange.location + firstDotRange.length));
        simplyVersionString = [self.version stringByReplacingOccurrencesOfString:@"." withString:@"" options:NSCaseInsensitiveSearch range:minorVersionRange];
    }
    return [simplyVersionString floatValue];
}

#pragma mark - JSSerializationDescriptorHolder

+ (NSArray *)rkResponseDescriptorsForServerProfile:(JSProfile *)serverProfile {
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:self];
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                          @"build": @"build",
                                                          @"edition": @"edition",
                                                          @"editionName": @"editionName",
                                                          @"expiration": @"expiration",
                                                          @"features": @"features",
                                                          @"licenseType": @"licenseType",
                                                          @"version": @"version",
                                                          @"dateFormatPattern": @"dateFormatPattern",
                                                          @"datetimeFormatPattern": @"datetimeFormatPattern",
                                                          }];
    NSMutableArray *descriptorsArray = [NSMutableArray array];
    [descriptorsArray addObject:[RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                             method:RKRequestMethodAny
                                                                        pathPattern:nil
                                                                            keyPath:nil
                                                                        statusCodes:nil]];
    return descriptorsArray;
}

@end
