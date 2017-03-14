/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.3
 */

#import "JSReportLoaderProtocol.h"

typedef NS_ENUM(NSInteger, JSReportLoaderOutputResourceType) {
    JSReportLoaderOutputResourceType_None = 0,
    JSReportLoaderOutputResourceType_LoadingNow,
    JSReportLoaderOutputResourceType_NotFinal,
    JSReportLoaderOutputResourceType_Final,
    JSReportLoaderOutputResourceType_AlreadyLoaded = JSReportLoaderOutputResourceType_NotFinal | JSReportLoaderOutputResourceType_Final
};

@interface JSReportLoader : NSObject <JSReportLoaderProtocol>
@property (nonatomic, assign) BOOL needEmbeddableOutput;
@end
