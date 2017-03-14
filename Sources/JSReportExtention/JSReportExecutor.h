/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.3
 */

#import "JSReportExecutionResponse.h"
#import "JSExportExecutionResponse.h"
#import "JSFileSaver.h"

@class JSRESTBase, JSReport, JSReportExecutionConfiguration, JSReportPagesRange;

typedef void(^JSReportExecutionCompletionBlock)(JSReportExecutionResponse * __nullable executionResponse, NSError * __nullable error);
typedef void(^JSExportExecutionCompletionBlock)(JSExportExecutionResponse * __nullable exportResponse, NSError * __nullable error);


@interface JSReportExecutor : JSFileSaver
@property (nonatomic, copy, readonly, nonnull) JSRESTBase *restClient;
@property (nonatomic, strong, readonly, nonnull) JSReportExecutionConfiguration *configuration;

@property (nonatomic, copy, readonly, nonnull) JSReport *report;
@property (nonatomic, strong, readonly, nonnull) JSReportExecutionResponse *executionResponse;
@property (nonatomic, strong, readonly, nonnull) JSExportExecutionResponse *exportResponse;


- (nonnull instancetype)initWithReport:(nonnull JSReport *)report restClient:(nonnull JSRESTBase *)restClient;
+ (nonnull instancetype)executorWithReport:(nonnull JSReport *)report restClient:(nonnull JSRESTBase *)restClient;

// Execute report
- (void)executeWithConfiguration:(nonnull JSReportExecutionConfiguration *)configuration completion:(nullable JSReportExecutionCompletionBlock)completion;

- (void)exportWithCompletion:(nullable JSExportExecutionCompletionBlock)completion;

- (void)cancelReportExecution;

@end
