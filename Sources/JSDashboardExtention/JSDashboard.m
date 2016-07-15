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
//  JSDashboard.m
//  Jaspersoft Corporation
//

#import "JSDashboard.h"

@implementation JSDashboard
#pragma mark - LifyCycle
- (instancetype)initWithResourceLookup:(JSResourceLookup *)resource
{
    self = [super init];
    if (self) {
        _resourceLookup = resource;
        _resourceURI = resource.uri;
    }
    return self;
}

+ (instancetype)dashboardWithResourceLookup:(JSResourceLookup *)resource
{
    return [[self alloc] initWithResourceLookup:resource];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    JSDashboard *newDashboard     = [[self class] allocWithZone:zone];
    newDashboard->_resourceLookup = [self.resourceLookup copyWithZone:zone];
    newDashboard->_resourceURI = [self.resourceURI copyWithZone:zone];
    if ([self.inputControls count]) {
        newDashboard.inputControls = [[NSArray alloc] initWithArray:self.inputControls copyItems:YES];
    }
    return newDashboard;
}

@end
