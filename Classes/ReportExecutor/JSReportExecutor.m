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
//  JSReportExecutor.m
//  Jaspersoft Corporation
//

#import "JSReportExecutor.h"
#import "JSReportExecutionResponse.h"
#import "JSExportExecutionResponse.h"
#import "JSReport.h"
#import "JSReportPagesRange.h"
#import "JSRESTBase+JSRESTReport.h"

//#import "JSConstants.h"

@interface JSReportExecutor()
@property (nonatomic, strong, nonnull) JSRESTBase *restClient;

@property (nonatomic, strong) JSReportExecutorConfiguration *configuration;
@property (nonatomic, strong, readwrite, nonnull) JSReport *report;
@property (nonatomic, strong, readwrite, nonnull) JSReportExecutionResponse *executionResponse;

@property (nonatomic, copy) JSReportExecutionCompletionBlock executeCompletion;
@property (nonatomic, copy) JSExportExecutionCompletionBlock exportCompletion;
@property (nonatomic, strong) NSTimer *executionStatusCheckingTimer;
@property (nonatomic, strong) NSTimer *exportStatusCheckingTimer;
@property (nonatomic, assign) BOOL shouldExecuteWithFreshData;
@property (nonatomic, assign) BOOL shouldIgnorePagination;
//
@property (nonatomic, strong) JSExportExecutionResponse *exportResponse;

@end

@implementation JSReportExecutor

#pragma mark - Life Cycle
- (instancetype)initWithReport:(JSReport *)report configuration:(nonnull JSReportExecutorConfiguration *)configuration {
    self = [super init];
    if (self) {
        _report = report;
        _configuration = configuration;
    }
    return self;
}

+ (instancetype)executorWithReport:(JSReport *)report configuration:(nonnull JSReportExecutorConfiguration *)configuration {
    return [[self alloc] initWithReport:report configuration:configuration];
}

- (nonnull instancetype)initWithExecutionResponce:(nonnull JSReportExecutionResponse *)executionResponse configuration:(nonnull JSReportExecutorConfiguration *)configuration {
    self = [super init];
    if (self) {
        _executionResponse = executionResponse;
        _configuration = configuration;
    }
    return self;
}

+ (nonnull instancetype)executorWithExecutionResponce:(nonnull JSReportExecutionResponse *)executionResponse configuration:(nonnull JSReportExecutorConfiguration *)configuration {
    return [[self alloc] initWithExecutionResponce:executionResponse configuration:configuration];
}


#pragma mark - Pubilc API
- (void)executeWithCompletion:(JSReportExecutionCompletionBlock)completion {
    if (self.executionResponse) {
        if (self.executeCompletion) {
            self.executeCompletion(self.executionResponse, nil);
        }
    } else {
        [self.configuration.restClient runReportExecution:self.report.reportURI
                                                    async:self.configuration.asyncExecution
                                             outputFormat:self.configuration.outputFormat
                                              interactive:self.configuration.interactive
                                                freshData:self.configuration.freshData
                                         saveDataSnapshot:self.configuration.saveDataSnapshot
                                         ignorePagination:self.configuration.ignorePagination
                                           transformerKey:self.configuration.transformerKey
                                                    pages:self.configuration.pagesRange.formattedPagesRange
                                        attachmentsPrefix:self.configuration.attachmentsPrefix
                                               parameters:self.report.reportParameters
                                          completionBlock:^(JSOperationResult *result) {
                                              if (completion) {
                                                  if (result.error) {
                                                      completion(nil, result.error);
                                                  } else {
                                                      completion(result.objects.firstObject, nil);
                                                  }
                                              }
                                          }];
    }
}

#pragma mark - Execution Status Checking
- (void)checkingExecutionStatusWithCompletion:(JSReportExecutionCompletionBlock)completion {
    self.executeCompletion = completion;
    [self startCheckingExecutionStatus];
}

- (void) startCheckingExecutionStatus {
    self.executionStatusCheckingTimer = [NSTimer scheduledTimerWithTimeInterval:kJSExecutionStatusCheckingInterval
                                                                         target:self
                                                                       selector:@selector(executionStatusChecking)
                                                                       userInfo:nil
                                                                        repeats:NO];
}

- (void)executionStatusChecking {
    NSString *executionID = self.executionResponse.requestId;
    [self.configuration.restClient reportExecutionStatusForRequestId:executionID
                                                     completionBlock:^(JSOperationResult *result) {
                                                         if (result.error) {
                                                             [self safelyInvalidateTimer:self.executionStatusCheckingTimer];
                                                             if (self.executeCompletion) {
                                                                 self.executeCompletion(self.executionResponse, result.error);
                                                             }
                                                         } else {
                                                             JSExecutionStatus *executionStatus = result.objects.firstObject;
                                                             if (executionStatus.status == kJS_EXECUTION_STATUS_READY ||
                                                                 executionStatus.status == kJS_EXECUTION_STATUS_CANCELED ||
                                                                 executionStatus.status == kJS_EXECUTION_STATUS_FAILED) {
                                                                 [self safelyInvalidateTimer:self.executionStatusCheckingTimer];
                                                                 
                                                                 if (executionStatus.status == kJS_EXECUTION_STATUS_READY) {
                                                                     [self.configuration.restClient reportExecutionMetadataForRequestId:self.executionResponse.requestId
                                                                                                                        completionBlock:^(JSOperationResult *result) {
                                                                                                                            if (!result.error) {
                                                                                                                                self.executionResponse = result.objects.firstObject;
                                                                                                                            }
                                                                                                                            if (self.executeCompletion) {
                                                                                                                                self.executeCompletion(self.executionResponse, result.error);
                                                                                                                            }
                                                                                                                        }];
                                                                 } else {
                                                                     self.executionResponse.status = executionStatus;
                                                                     if (self.executeCompletion) {
                                                                         self.executeCompletion(self.executionResponse, nil);
                                                                     }
                                                                 }
                                                             } else {
                                                                 [self startCheckingExecutionStatus];
                                                             }
                                                         }
                                                     }];
}

- (void)exportForRange:(nonnull JSReportPagesRange *)pagesRange outputFormat:(nonnull NSString *)outputFormat
      attachmentsPrefix:(nonnull NSString *)attachmentsPrefix withCompletion:(nullable JSExportExecutionCompletionBlock)completion {
    if (self.executionResponse) {
        self.exportCompletion = completion;
        [self.configuration.restClient runExportExecution:self.executionResponse.requestId
                                             outputFormat:outputFormat
                                                    pages:pagesRange.formattedPagesRange
                                        attachmentsPrefix:attachmentsPrefix
                                          completionBlock:^(JSOperationResult *result) {
                                              if (result.error) {
                                                  if (self.exportCompletion) {
                                                      self.exportCompletion(nil, result.error);
                                                  }
                                              } else {
                                                  self.exportResponse = result.objects.firstObject;
                                                  if (self.exportResponse.status.status == kJS_EXECUTION_STATUS_QUEUED || self.exportResponse.status.status == kJS_EXECUTION_STATUS_EXECUTION) {
                                                      [self startCheckingExportStatus];
                                                  } else {
                                                      if (self.exportCompletion) {
                                                          self.exportCompletion(self.exportResponse, nil);
                                                      }
                                                  }
                                              }
                                          }];
    } else {
        if (completion) {
#warning HERE NEED TO ADD CORECT ERROR INITIALIZATION!!!
            completion(nil, [NSError new]);
        }
    }
}

#pragma mark - Export Status Checking
- (void)startCheckingExportStatus {
    self.exportStatusCheckingTimer = [NSTimer scheduledTimerWithTimeInterval:kJSExecutionStatusCheckingInterval
                                                                      target:self
                                                                    selector:@selector(exportStatusChecking)
                                                                    userInfo:nil
                                                                     repeats:NO];
}

- (void)exportStatusChecking {
    [self.restClient exportExecutionStatusWithExecutionID:self.executionResponse.requestId
                                             exportOutput:self.exportResponse.uuid
                                               completion:^(JSOperationResult *result) {
                                                   if (result.error) {
                                                       [self safelyInvalidateTimer:self.exportStatusCheckingTimer];
                                                       if (self.exportCompletion) {
                                                           self.exportCompletion(nil, result.error);
                                                       }
                                                   } else {
                                                       JSExecutionStatus *exportStatus = result.objects.firstObject;
                                                       if (exportStatus.status == kJS_EXECUTION_STATUS_READY ||
                                                           exportStatus.status == kJS_EXECUTION_STATUS_CANCELED ||
                                                           exportStatus.status == kJS_EXECUTION_STATUS_FAILED) {
                                                           [self safelyInvalidateTimer:self.exportStatusCheckingTimer];
                                                           
                                                           if (exportStatus.status == kJS_EXECUTION_STATUS_READY) {
#warning HERE NEED CHECK - maybe we can load attachments only
                                                               [self.restClient reportExecutionMetadataForRequestId:self.executionResponse.requestId
                                                                                                    completionBlock:^(JSOperationResult *result) {
                                                                                                        if (!result.error) {
                                                                                                            JSReportExecutionResponse *executionResponse = result.objects.firstObject;
                                                                                                            for (JSExportExecutionResponse *export in executionResponse.exports) {
                                                                                                                if ([export.uuid isEqualToString:self.exportResponse.uuid]) {
                                                                                                                    self.exportResponse = export;
                                                                                                                    break;
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                        if (self.exportCompletion) {
                                                                                                            self.exportCompletion(self.exportResponse, result.error);
                                                                                                        }
                                                                                                    }];
                                                           } else if (self.exportCompletion) {
                                                               self.exportCompletion(nil, result.error);
                                                           }
                                                       } else {
                                                           [self startCheckingExportStatus];
                                                       }
                                                   }
                                               }];
}


- (void)cancelReportExecution {
#warning HERE NEED CANCEL ONLY OWN REQUESTS!
    [self.configuration.restClient cancelAllRequests];
    [self safelyInvalidateTimer:self.executionStatusCheckingTimer];
    [self safelyInvalidateTimer:self.exportStatusCheckingTimer];
}

#pragma mark - Helpers
- (void)safelyInvalidateTimer:(NSTimer *)timer {
    if (timer && timer.valid) {
        [timer invalidate];
    }
}

#pragma mark - Private API

- (void)setExecutionResponse:(JSReportExecutionResponse *)executionResponse {
    if (_executionResponse != executionResponse) {
        _executionResponse = executionResponse;
        [self.report updateRequestId:_executionResponse.requestId];
        if (executionResponse.totalPages.integerValue) {
            [self.report updateCountOfPages:executionResponse.totalPages.integerValue];
        }
    }
}

@end