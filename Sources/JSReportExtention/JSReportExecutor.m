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
#import "JSReportExecutionConfiguration.h"
#import "JSRESTBase+JSRESTReport.h"

@interface JSReportExecutor()
@property (nonatomic, copy, readwrite, nonnull) JSRESTBase *restClient;
@property (nonatomic, strong, readwrite, nonnull) JSReportExecutionConfiguration *configuration;

@property (nonatomic, strong, readwrite, nonnull) JSReport *report;
@property (nonatomic, strong, readwrite, nonnull) JSReportExecutionResponse *executionResponse;
@property (nonatomic, strong, readwrite, nonnull) JSExportExecutionResponse *exportResponse;

@property (nonatomic, copy) JSReportExecutionCompletionBlock executeCompletion;
@property (nonatomic, copy) JSExportExecutionCompletionBlock exportCompletion;


@end

@implementation JSReportExecutor

#pragma mark - Life Cycle
- (instancetype)initWithReport:(JSReport *)report restClient:(nonnull JSRESTBase *)restClient {
    self = [super init];
    if (self) {
        self.report = report;
        self.restClient = restClient;
    }
    return self;
}

+ (instancetype)executorWithReport:(JSReport *)report restClient:(nonnull JSRESTBase *)restClient{
    return [[self alloc] initWithReport:report restClient:restClient];
}

#pragma mark - Pubilc API
- (void)executeWithConfiguration:(JSReportExecutionConfiguration *)configuration completion:(JSReportExecutionCompletionBlock)completion {
    self.executeCompletion = completion;
    self.configuration = configuration;
    if (self.executionResponse) {
        if (self.executeCompletion) {
            self.executeCompletion(self.executionResponse, nil);
        }
    } else {
        // We should run report execution only, without export execution. For old JRS versions we run report execution with fake export.
        NSString *outputFormat;
        NSString *pagesRangeString;
        if (self.restClient.serverInfo.versionAsFloat < kJS_SERVER_VERSION_CODE_EMERALD_5_6_0) {
            outputFormat = kJS_CONTENT_TYPE_PDF;
            pagesRangeString = @"1";
        }
        
        __weak typeof(self) weakSelf = self;
        [self.restClient runReportExecution:self.report.reportURI
                                      async:self.configuration.asyncExecution
                               outputFormat:outputFormat
                                interactive:self.configuration.interactive
                                  freshData:self.configuration.freshData
                           saveDataSnapshot:self.configuration.saveDataSnapshot
                           ignorePagination:self.configuration.ignorePagination
                             transformerKey:self.configuration.transformerKey
                                      pages:pagesRangeString
                          attachmentsPrefix:self.configuration.attachmentsPrefix
                                 parameters:self.report.reportParameters
                            completionBlock:^(JSOperationResult *result) {
                                if (result.error) {
                                    if (completion) {
                                        completion(nil, result.error);
                                    }
                                } else {
                                    __strong typeof(self) strongSelf = weakSelf;
                                    strongSelf.executionResponse = result.objects.firstObject;
                                    if (strongSelf.executionResponse.status.status == kJS_EXECUTION_STATUS_QUEUED ||
                                        strongSelf.executionResponse.status.status == kJS_EXECUTION_STATUS_EXECUTION) {
                                        [strongSelf checkingExecutionStatus];
                                    } else if (strongSelf.executeCompletion) {
                                        strongSelf.executeCompletion(strongSelf.executionResponse, nil);
                                    }
                                }
                            }];
    }
}

#pragma mark - Execution Status Checking
- (void) checkingExecutionStatus {
    [self performSelector:@selector(executionStatusChecking) withObject:nil afterDelay:kJSExecutionStatusCheckingInterval];
}

- (void)executionStatusChecking {
    __weak typeof(self) weakSelf = self;
    [self.restClient reportExecutionStatusForRequestId:self.executionResponse.requestId
                                       completionBlock:^(JSOperationResult *result) {
                                           __strong typeof(self) strongSelf = weakSelf;
                                           if (result.error) {
                                               if (strongSelf.executeCompletion) {
                                                   strongSelf.executeCompletion(strongSelf.executionResponse, result.error);
                                               }
                                           } else {
                                               JSExecutionStatus *executionStatus = result.objects.firstObject;
                                               if (executionStatus.status == kJS_EXECUTION_STATUS_QUEUED ||
                                                   executionStatus.status == kJS_EXECUTION_STATUS_EXECUTION) {
                                                   [strongSelf checkingExecutionStatus];
                                               } else if (executionStatus.status == kJS_EXECUTION_STATUS_READY) {
                                                   __weak typeof(self) weakSelf = strongSelf;
                                                   [strongSelf.restClient reportExecutionMetadataForRequestId:strongSelf.executionResponse.requestId
                                                                                        completionBlock:^(JSOperationResult *result) {
                                                                                            __strong typeof(self) strongSelf = weakSelf;
                                                                                            if (!result.error) {
                                                                                                strongSelf.executionResponse = result.objects.firstObject;
                                                                                            }
                                                                                            if (strongSelf.executeCompletion) {
                                                                                                strongSelf.executeCompletion(strongSelf.executionResponse, result.error);
                                                                                            }
                                                                                        }];
                                               } else {
                                                   strongSelf.executionResponse.status = executionStatus;
                                                   if (strongSelf.executeCompletion) {
                                                       strongSelf.executeCompletion(self.executionResponse, nil);
                                                   }
                                               }
                                           }
                                       }];
}

- (void)exportWithRange:(nonnull JSReportPagesRange *)pagesRange outputFormat:(nonnull NSString *)format completion:(nullable JSExportExecutionCompletionBlock)completion {
    if (self.executionResponse && self.executionResponse.status.status == kJS_EXECUTION_STATUS_READY) {
        self.exportCompletion = completion;
        NSArray *exports = self.executionResponse.exports;
        
        if ([pagesRange isEqual:self.configuration.pagesRange] && [format isEqualToString:self.configuration.outputFormat] && [exports count]) {
            self.exportResponse = exports.firstObject;
            if (self.exportResponse.status.status == kJS_EXECUTION_STATUS_READY) {
                if (self.exportCompletion) {
                    self.exportCompletion(self.exportResponse, nil);
                }
            } else {
                [self checkingExportStatus];
            }
        } else {
            __weak typeof(self) weakSelf = self;
            [self.restClient runExportExecution:self.executionResponse.requestId
                                   outputFormat:self.configuration.outputFormat
                                          pages:self.configuration.pagesRange.formattedPagesRange
                              attachmentsPrefix:self.configuration.attachmentsPrefix
                                completionBlock:^(JSOperationResult *result) {
                                    __strong typeof(self) strongSelf = weakSelf;
                                    if (result.error) {
                                        if (strongSelf.exportCompletion) {
                                            strongSelf.exportCompletion(nil, result.error);
                                        }
                                    } else {
                                        strongSelf.exportResponse = result.objects.firstObject;
                                        if (strongSelf.exportResponse.status.status == kJS_EXECUTION_STATUS_QUEUED ||
                                            strongSelf.exportResponse.status.status == kJS_EXECUTION_STATUS_EXECUTION ||
                                            strongSelf.exportResponse.status.status == kJS_EXECUTION_STATUS_CANCELED) { // It's a bag on server-side, so if we didn't cancel it - it's valid!!!
                                            [strongSelf checkingExportStatus];
                                        } else if (strongSelf.exportCompletion) {
                                            strongSelf.exportCompletion(self.exportResponse, nil);
                                        }
                                    }
                                }];
        }
    }else {
        if (completion) {
            NSError *error = [JSErrorBuilder errorWithCode:JSDataMappingErrorCode];
            completion(nil, error);
        }
    }
}

#pragma mark - Export Status Checking
- (void)checkingExportStatus {
    [self performSelector:@selector(exportStatusChecking) withObject:nil afterDelay:kJSExecutionStatusCheckingInterval];
}

- (void)exportStatusChecking {
    __weak typeof(self) weakSelf = self;
    [self.restClient exportExecutionStatusWithExecutionID:self.executionResponse.requestId
                                             exportOutput:self.exportResponse.uuid
                                               completion:^(JSOperationResult *result) {
                                                   __strong typeof(self) strongSelf = weakSelf;
                                                   if (result.error) {
                                                       if (strongSelf.exportCompletion) {
                                                           strongSelf.exportCompletion(nil, result.error);
                                                       }
                                                   } else {
                                                       JSExecutionStatus *exportStatus = result.objects.firstObject;
                                                       if (exportStatus.status == kJS_EXECUTION_STATUS_QUEUED ||
                                                           exportStatus.status == kJS_EXECUTION_STATUS_EXECUTION ||
                                                           exportStatus.status == kJS_EXECUTION_STATUS_CANCELED) { // It's a bag on server-side, so if we didn't cancel it - it's valid!!!
                                                           [strongSelf checkingExportStatus];
                                                       } else if (exportStatus.status == kJS_EXECUTION_STATUS_READY) {
                                                           __weak typeof(self) weakSelf = strongSelf;
                                                           [strongSelf.restClient reportExecutionMetadataForRequestId:strongSelf.executionResponse.requestId
                                                                                                      completionBlock:^(JSOperationResult *result) {
                                                                                                          __strong typeof(self) strongSelf = weakSelf;
                                                                                                          if (!result.error && [result.objects count]) {
                                                                                                              strongSelf.executionResponse = result.objects.firstObject;
                                                                                                              for (JSExportExecutionResponse *export in strongSelf.executionResponse.exports) {
                                                                                                                  if ([export.uuid isEqualToString:self.exportResponse.uuid]) {
                                                                                                                      self.exportResponse = export;
                                                                                                                      break;
                                                                                                                  }
                                                                                                              }
                                                                                                          }
                                                                                                          if (strongSelf.exportCompletion) {
                                                                                                              strongSelf.exportCompletion(strongSelf.exportResponse, result.error);
                                                                                                          }
                                                                                                      }];
                                                       } else if (strongSelf.exportCompletion) {
                                                           strongSelf.exportCompletion(strongSelf.exportResponse, nil);
                                                       }
                                                   }
                                               }];
}

- (void)cancelReportExecution {
    self.executeCompletion = nil;
    self.exportCompletion = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(executionStatusChecking) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(exportStatusChecking) object:nil];
    
    [self.restClient cancelAllRequests];
}

@end