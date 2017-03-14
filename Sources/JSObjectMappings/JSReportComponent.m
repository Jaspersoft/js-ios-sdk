/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


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

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {

    JSReportComponent *copiedComponent = [[[self class] allocWithZone:zone] init];
    if (copiedComponent) {
        copiedComponent.identifier = [self.identifier copyWithZone:zone];
        copiedComponent.type = self.type;
        if ([self.structure conformsToProtocol:@protocol(NSCopying)]) {
            copiedComponent.structure = [self.structure copyWithZone:zone];
        }
    }
    return copiedComponent;
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
                @"dualPieSettingService"         : @(JSHighchartServiceTypeDualPie),
                @"treemapSettingService"         : @(JSHighchartServiceTypeTreeMap),
        };

        [mapping mapKeyPath:@"hcinstancedata.services" toProperty:@"services" withValueBlock:^id(NSString *key, NSArray *services) {
            NSMutableArray *serviceNames = [NSMutableArray array];
            for (NSDictionary *service in services) {
                NSString *serviceName = service[@"service"];
                if (serviceName && serviceTypes[serviceName]) {
                    [serviceNames addObject:serviceTypes[serviceName]];
                }
            }
            return serviceNames;
        }];
    }];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {

    JSReportComponentChartStructure *copiedStructure = [[[self class] allocWithZone:zone] init];
    if (copiedStructure) {
        copiedStructure.module = [self.module copyWithZone:zone];
        copiedStructure.uimodule = [self.uimodule copyWithZone:zone];
        copiedStructure.charttype = [self.charttype copyWithZone:zone];
        copiedStructure.interactive = self.interactive;
        copiedStructure.datetimeSupported = self.datetimeSupported;
        copiedStructure.treemapSupported = self.treemapSupported;
        copiedStructure.globalOptions = [self.globalOptions copyWithZone:zone];
        copiedStructure.hcinstancedata = [self.hcinstancedata copyWithZone:zone];
        copiedStructure.services = [self.services copyWithZone:zone];

    }
    return copiedStructure;
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

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {

    JSReportComponentTableStructure *copiedStructure = [[[self class] allocWithZone:zone] init];
    if (copiedStructure) {
        copiedStructure.module = [self.module copyWithZone:zone];
        copiedStructure.uimodule = [self.uimodule copyWithZone:zone];
    }
    return copiedStructure;
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

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {

    JSReportComponentColumnStructure *copiedStructure = [[[self class] allocWithZone:zone] init];
    if (copiedStructure) {
        copiedStructure.name = [self.name copyWithZone:zone];
        copiedStructure.parentId = [self.parentId copyWithZone:zone];
        copiedStructure.selector = [self.selector copyWithZone:zone];
        copiedStructure.proxySelector = [self.proxySelector copyWithZone:zone];
        copiedStructure.columnIndex = self.columnIndex;
        copiedStructure.columnLabel = [self.columnLabel copyWithZone:zone];
        copiedStructure.dataType = [self.dataType copyWithZone:zone];
        copiedStructure.canSort = self.canSort;
        copiedStructure.canFilter = self.canFilter;
        copiedStructure.canFormatConditionally = self.canFormatConditionally;
    }
    return copiedStructure;
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

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {

    JSReportComponentCrosstabStructure *copiedStructure = [[[self class] allocWithZone:zone] init];
    if (copiedStructure) {
        copiedStructure.module = [self.module copyWithZone:zone];
        copiedStructure.uimodule = [self.uimodule copyWithZone:zone];
        copiedStructure.fragmentId = [self.fragmentId copyWithZone:zone];
        copiedStructure.crosstabId = [self.crosstabId copyWithZone:zone];
        copiedStructure.startColumnIndex = self.startColumnIndex;
        copiedStructure.hasFloatingHeaders = self.hasFloatingHeaders;
    }
    return copiedStructure;
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

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {

    JSReportComponentFusionStructure *copiedStructure = [[[self class] allocWithZone:zone] init];
    if (copiedStructure) {
        copiedStructure.module = [self.module copyWithZone:zone];
        copiedStructure.instanceData = self.instanceData; // TODO: investigate to copy this.
    }
    return copiedStructure;
}

@end
