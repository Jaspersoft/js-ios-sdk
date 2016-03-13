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
//  JSReportComponent.h
//  TIBCO JasperMobile
//


#import <EasyMapping/EKMapper.h>
#import "JSReportComponent.h"

@implementation JSReportComponent

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                @"id": @"identifier"
        }];

        NSDictionary *componentTypes = @{
                @"undefined"    : @(JSReportComponentTypeUndefined),
                @"chart"        : @(JSReportComponentTypeChart),
                @"table"        : @(JSReportComponentTypeTable),
                @"column"       : @(JSReportComponentTypeColumn),
                @"fusionWidget" : @(JSReportComponentTypeFusion),
                @"crosstab"     : @(JSReportComponentTypeCrosstab),
                @"hyperlinks"   : @(JSReportComponentTypeHyperlinks),
                @"bookmarks"    : @(JSReportComponentTypeBookmarks),
        };

        [mapping mapKeyPath:@"type" toProperty:@"type" withValueBlock:^(NSString *key, id value) {
            return componentTypes[value];
        } reverseBlock:^id(id value) {
            return [componentTypes allKeysForObject:value].lastObject;
        }];
    }];
}

@end

@implementation JSReportComponentChartStructure

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[
                @"module",
                @"uimodule",
                @"charttype",
                @"interactive",
                @"datetimeSupported",
                @"treemapSupported",
                @"globalOptions",
                @"hcinstancedata",
        ]];

        NSDictionary *serviceTypes = @{
                @"undefined"                     : @(JSHighchartServiceTypeUndefined),
                @"adhocHighchartsSettingService" : @(JSHighchartServiceTypeAdhoc),
                @"dataSettingService"            : @(JSHighchartServiceTypeData),
                @"defaultSettingService"         : @(JSHighchartServiceTypeDefault),
                @"xAxisSettingService"           : @(JSHighchartServiceTypeXAxis),
                @"yAxisSettingService"           : @(JSHighchartServiceTypeYAxis),
                @"itemHyperlinkSettingService"   : @(JSHighchartServiceTypeItemHyperlink),
        };

        [mapping mapKeyPath:@"hcinstancedata.services" toProperty:@"services" withValueBlock:^id(NSString *key, NSArray *services) {
            NSMutableArray *serviceNames = [NSMutableArray array];
            for (NSDictionary *service in services) {
                NSString *serviceName = service[@"service"];
                if (serviceName) {
                    [serviceNames addObject:serviceTypes[serviceName]];
                }
            }
            return serviceNames;
        }];
    }];
}

@end

@implementation JSReportComponentTableStructure

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[
                @"module",
                @"uimodule",
        ]];
    }];
}

@end

@implementation JSReportComponentColumnStructure

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[
                @"name",
                @"parentId",
                @"selector",
                @"proxySelector",
                @"columnIndex",
                @"columnLabel",
                @"dataType",
                @"canSort",
                @"canFilter",
                @"canFormatConditionally",
        ]];
    }];
}

@end

@implementation JSReportComponentBookmarksStructure

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {

    }];
}

@end

@implementation JSReportComponentCrosstabStructure

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[
                @"module",
                @"uimodule",
                @"fragmentId",
                @"crosstabId",
                @"startColumnIndex",
                @"hasFloatingHeaders"
        ]];
    }];
}

@end

@implementation JSReportComponentHyperlinksStructure

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {

    }];
}

@end

@implementation JSReportComponentFusionStructure

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[
            @"module",
            @"instanceData",
        ]];
    }];
}

@end