/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.3
 */

#import <Foundation/Foundation.h>
#import "JSReportExecutor.h"
#import "JSReportPagesRange.h"

@class JSReport, JSRESTBase, JSReportExecutionResponse;

typedef void(^JSSaveReportCompletion)(NSURL * _Nullable savedReportFolderURL, NSError * _Nullable error);

@interface JSReportSaver : JSReportExecutor

- (void) saveReportWithName:(nonnull NSString *)name format:(nonnull NSString *)format
                 pagesRange:(nonnull JSReportPagesRange *)pagesRange completion:(nullable JSSaveReportCompletion)completionBlock;

- (void) cancel;

@end
