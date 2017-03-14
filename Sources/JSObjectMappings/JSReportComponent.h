/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @since 2.5
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
    JSHighchartServiceTypeDualPie,
    JSHighchartServiceTypeTreeMap,
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

@interface JSReportComponentCrosstabStructure: NSObject <JSObjectMappingsProtocol, NSCopying>
@property (nonatomic, copy, nullable) NSString *module;
@property (nonatomic, copy, nullable) NSString *uimodule;
@property (nonatomic, copy, nullable) NSString *fragmentId;
@property (nonatomic, copy, nullable) NSString *crosstabId;
@property (nonatomic, assign) NSInteger startColumnIndex;
@property (nonatomic, assign) BOOL hasFloatingHeaders;
@end

@interface JSReportComponentFusionStructure: NSObject <JSObjectMappingsProtocol, NSCopying>
@property (nonatomic, copy, nullable) NSString *module;
@property (nonatomic, copy, nullable) id instanceData;
@end
