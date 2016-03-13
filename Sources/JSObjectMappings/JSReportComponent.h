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


/**
@author Aleksandr Dakhno odahno@tibco.com
@since 2.4
*/

#import "JSObjectMappingsProtocol.h"

typedef NS_ENUM(NSInteger, JSReportComponentType) {
    JSReportComponentTypeUndefined,
    JSReportComponentTypeChart,
    JSReportComponentTypeTable,
    JSReportComponentTypeColumn,
    JSReportComponentTypeFusion,
    JSReportComponentTypeCrosstab,
    JSReportComponentTypeHyperlinks,
    JSReportComponentTypeBookmarks,
};

typedef NS_ENUM(NSInteger, JSHighchartServiceType) {
    JSHighchartServiceTypeUndefined,
    JSHighchartServiceTypeAdhoc,
    JSHighchartServiceTypeData,
    JSHighchartServiceTypeDefault,
    JSHighchartServiceTypeXAxis,
    JSHighchartServiceTypeYAxis,
    JSHighchartServiceTypeItemHyperlink,
};

@interface JSReportComponent: NSObject <JSObjectMappingsProtocol, NSCopying>
@property (nonatomic, copy, nonnull) NSString *identifier;
@property (nonatomic, assign) JSReportComponentType type;
@property (nonatomic, strong, nullable) NSObject <NSCopying>* structure;
@end

@interface JSReportComponentChartStructure: NSObject <JSObjectMappingsProtocol, NSCopying>
@property (nonatomic, copy, nonnull) NSString *module;
@property (nonatomic, copy, nonnull) NSString *uimodule;
@property (nonatomic, copy, nonnull) NSString *charttype;
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, assign) BOOL datetimeSupported;
@property (nonatomic, assign) BOOL treemapSupported;
@property (nonatomic, copy, nullable) NSDictionary *globalOptions;
@property (nonatomic, copy, nullable) NSDictionary *hcinstancedata;
@property (nonatomic, copy, nonnull) NSArray *services;
@end

@interface JSReportComponentTableStructure: NSObject <JSObjectMappingsProtocol, NSCopying>
@property (nonatomic, copy, nonnull) NSString *module;
@property (nonatomic, copy, nonnull) NSString *uimodule;
@end

@interface JSReportComponentColumnStructure: NSObject <JSObjectMappingsProtocol, NSCopying>
@property (nonatomic, copy, nonnull) NSString *name;
@property (nonatomic, copy, nonnull) NSString *parentId;
@property (nonatomic, copy, nonnull) NSString *selector;
@property (nonatomic, copy, nonnull) NSString *proxySelector;
@property (nonatomic, assign) NSInteger columnIndex;
@property (nonatomic, copy, nonnull) NSString *columnLabel;
@property (nonatomic, copy, nonnull) NSString *dataType;
@property (nonatomic, assign) BOOL canSort;
@property (nonatomic, assign) BOOL canFilter;
@property (nonatomic, assign) BOOL canFormatConditionally;
@end

@interface JSReportComponentBookmarksStructure: NSObject <JSObjectMappingsProtocol, NSCopying>
@property (nonatomic, copy, nullable) NSArray *bookmarks;
@end

@interface JSReportComponentCrosstabStructure: NSObject <JSObjectMappingsProtocol, NSCopying>
@property (nonatomic, copy, nullable) NSString *module;
@property (nonatomic, copy, nullable) NSString *uimodule;
@property (nonatomic, copy, nullable) NSString *fragmentId;
@property (nonatomic, copy, nullable) NSString *crosstabId;
@property (nonatomic, assign) NSInteger startColumnIndex;
@property (nonatomic, assign) BOOL hasFloatingHeaders;
@end

@interface JSReportComponentHyperlinksStructure: NSObject <JSObjectMappingsProtocol, NSCopying>
@property (nonatomic, copy, nullable) NSArray *hyperlinks;
@end

@interface JSReportComponentFusionStructure: NSObject <JSObjectMappingsProtocol, NSCopying>
@property (nonatomic, copy, nullable) NSString *module;
@property (nonatomic, copy, nullable) id instanceData;
@end