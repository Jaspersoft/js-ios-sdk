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
@property (nonatomic, strong) JSRESTBase *restClient;
@property (nonatomic, strong, readwrite, nonnull) JSReport *report;

@property (nonatomic, copy) JSReportExecutionCompletionBlock executeCompletion;
@property (nonatomic, copy) JSExportExecutionCompletionBlock exportCompletion;
@property (nonatomic, strong) NSTimer *executionStatusCheckingTimer;
@property (nonatomic, strong) NSTimer *exportStatusCheckingTimer;
@property (nonatomic, assign) BOOL shouldExecuteWithFreshData;
@property (nonatomic, assign) BOOL shouldIgnorePagination;
//
@property (nonatomic, strong) JSReportExecutionResponse *executionResponse;
@property (nonatomic, strong) JSExportExecutionResponse *exportResponse;

@end

@implementation JSReportExecutor

#pragma mark - Life Cycle
- (instancetype)initWithReport:(JSReport *)report forRestClient:(nonnull JSRESTBase *)restClient {
    self = [super init];
    if (self) {
        _report = report;
        _restClient = restClient;
    }
    return self;
}

+ (instancetype)executorWithReport:(JSReport *)report forRestClient:(nonnull JSRESTBase *)restClient {
    return [[self alloc] initWithReport:report forRestClient:restClient];
}

#pragma mark - Pubilc API
- (void)executeWithCompletion:(JSReportExecutionCompletionBlock)completion {
    self.executeCompletion = completion;

    if (self.executionResponse) {
        if (self.executeCompletion) {
            self.executeCompletion(self.executionResponse, nil);
        }
    } else {
        [self.restClient runReportExecution:self.report.reportURI
                                      async:self.asyncExecution
                               outputFormat:self.format
                                interactive:self.interactive
                                  freshData:self.shouldExecuteWithFreshData
                           saveDataSnapshot:YES // TODO: what does this parameter mean
                           ignorePagination:self.shouldIgnorePagination
                             transformerKey:nil // TODO: what does this parameter mean
                                      pages:nil
                          attachmentsPrefix:self.attachmentsPrefix
                                 parameters:self.report.reportParameters
                            completionBlock:^(JSOperationResult *result) {
                                if (result.error) {
                                    if (self.executeCompletion) {
                                        self.executeCompletion(nil, result.error);
                                    }
                                } else {
                                    self.executionResponse = result.objects.firstObject;
                                    
                                    if (self.executionResponse.status.status == kJS_EXECUTION_STATUS_QUEUED || self.executionResponse.status.status == kJS_EXECUTION_STATUS_EXECUTION) {
                                        [self startCheckingExecutionStatus];
                                    } else if (self.executeCompletion) {
                                        self.executeCompletion(self.executionResponse, nil);
                                    }
                                }
                            }];
    }
}

- (void)exportForRange:(nonnull JSReportPagesRange *)pagesRange withCompletion:(nullable JSExportExecutionCompletionBlock)completion {
    if (self.executionResponse && self.executionResponse.status.status == kJS_EXECUTION_STATUS_READY) {
        self.exportCompletion = completion;
        NSArray *exports = self.executionResponse.exports;

        if ([pagesRange isAllPagesRange] && [exports count]) {
            self.exportResponse = exports.firstObject;
            if (self.exportResponse.status.status == kJS_EXECUTION_STATUS_READY) {
                if (self.exportCompletion) {
                    self.exportCompletion(self.exportResponse, nil);
                }
            } else {
                [self startCheckingExportStatus];
            }
        } else {
            [self.restClient runExportExecution:self.executionResponse.requestId
                                   outputFormat:self.format
                                          pages:pagesRange.formattedPagesRange
                              attachmentsPrefix:self.attachmentsPrefix
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
        }
    } else {
        if (completion) {
#warning HERE NEED TO ADD CORECT ERROR INITIALIZATION!!!
            completion(nil, [NSError new]);
        }
    }
}

- (void)cancel {
#warning HERE NEED CANCEL ONLY OWN REQUESTS!
    [self.restClient cancelAllRequests];
    [self.executionStatusCheckingTimer invalidate];
    [self.exportStatusCheckingTimer invalidate];
}

#pragma mark - Private API

- (void)setExecutionResponse:(JSReportExecutionResponse *)executionResponse {
    if (_executionResponse != executionResponse) {
        _executionResponse = executionResponse;
        [self.report updateRequestId:_executionResponse.requestId];
    }
}

#pragma mark - Execution Status Checking
- (void)startCheckingExecutionStatus {
    self.executionStatusCheckingTimer = [NSTimer scheduledTimerWithTimeInterval:kJSExecutionStatusCheckingInterval
                                                                         target:self
                                                                       selector:@selector(executionStatusChecking)
                                                                       userInfo:nil
                                                                        repeats:YES];
}

- (void)executionStatusChecking {
    NSString *executionID = self.executionResponse.requestId;
    [self.restClient reportExecutionStatusForRequestId:executionID
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
                                                           [self.restClient reportExecutionMetadataForRequestId:self.executionResponse.requestId
                                                                                                completionBlock:^(JSOperationResult *result) {
                                                                                                    if (!result.error) {
                                                                                                        self.executionResponse = result.objects.firstObject;
                                                                                                    }
                                                                                                    if (self.executeCompletion) {
                                                                                                        self.executeCompletion(self.executionResponse, result.error);
                                                                                                    }
                                                                                                }];
                                                           
                                                           
                                                       } else if (self.executeCompletion) {
                                                           self.executeCompletion(self.executionResponse, nil);
                                                       }
                                                   }
                                               }
                                           }];

}

#pragma mark - Export Status Checking
- (void)startCheckingExportStatus {
    self.exportStatusCheckingTimer = [NSTimer scheduledTimerWithTimeInterval:kJSExecutionStatusCheckingInterval
                                                                      target:self
                                                                    selector:@selector(exportStatusChecking)
                                                                    userInfo:nil
                                                                     repeats:YES];
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
                                                       }
                                                   }
                                               }];
}

#pragma mark - Helpers
- (void)safelyInvalidateTimer:(NSTimer *)timer {
    if (timer && timer.valid) {
        [timer invalidate];
    }
}

@end