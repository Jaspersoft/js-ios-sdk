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

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                @"id"                        : @"identifier",
                @"type"                      : @"type",
                @"label"                     : @"label",
                @"name"                      : @"name",
                @"resourceId"                : @"resourceId",
                @"resource"                  : @"resourceURI",
                @"ownerResourceId"           : @"ownerResourceURI",
                @"ownerResourceParameterName": @"ownerResourceParameterName",
                @"dashletHyperlinkUrl"       : @"dashletHyperlinkUrl",
        }];

        // Dashlet Hyperlink Target
        NSDictionary *targetTypes = @{
                @"Blank" : @(JSDashletHyperlinksTargetTypeBlank),
                @"Self"  : @(JSDashletHyperlinksTargetTypeSelf),
                @"Parent": @(JSDashletHyperlinksTargetTypeParent),
                @"Top"   : @(JSDashletHyperlinksTargetTypeTop)
        };

        [mapping mapKeyPath:@"dashletHyperlinkTarget" toProperty:@"dashletHyperlinkTarget" withValueBlock:^(NSString *key, id value) {
            return targetTypes[value];
        } reverseBlock:^id(id value) {
            return [targetTypes allKeysForObject:value].lastObject;
        }];

    }];
}

+ (nonnull NSString *)requestObjectKeyPath {
    return @"dashboardComponent";
}

@end