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
//  JSReportSaver.m
//  Jaspersoft Corporation
//

#import "JSReportSaver.h"
#import "JSReportPagesRange.h"

typedef void(^JMReportSaverCompletion)(NSError *error);
typedef void(^JMReportSaverDownloadCompletion)(BOOL sholdAddToDB);

NSString * const kJSAttachmentPrefix = @"_";

@interface JSReportSaver()
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) JSReportExecutor *reportExecutor;
@property (nonatomic, strong) JSReportPagesRange *pagesRange;
@property (nonatomic, copy) JMReportSaverDownloadCompletion downloadCompletion;
@end

@implementation JSReportSaver

#pragma mark - Lifecycle

- (instancetype)initWithReport:(JSReport *)report forRestClient:(JSRESTBase *)restClient {
    self = [super initWithReport:report forRestClient:restClient];
    if (self) {
        <#statements#>
    }
}


- (instancetype)initWithReport:(JSReport *)report
{
    self = [super init];
    if (self) {
        _report = report;
#warning NEED TRY TO USE REPORTEXECUTOR FROM REPORT VIEWER - maybe we shouldn't create new one
        _reportExecutor = [JSReportExecutor executorWithReport:_report forRestClient:self.restClient];
        
        __weak typeof(self)weakSelf = self;
        self.downloadCompletion = ^(BOOL shouldAddToDB) {
            __strong typeof(self)strongSelf = weakSelf;
            
            NSString *originalDirectory = [JMSavedResources pathToFolderForSavedReport:strongSelf.savedReport];
            NSString *temporaryDirectory = [JMSavedResources pathToTempFolderForSavedReport:strongSelf.savedReport];
            
            // move saved report from temp location to origin
            if ([strongSelf isExistSavedReport:strongSelf.savedReport]) {
                [strongSelf removeReportAtPath:originalDirectory];
            }
            
            [strongSelf moveContentFromPath:temporaryDirectory
                                     toPath:originalDirectory];
            [strongSelf removeTempDirectory];
            
            // save to DB
            if (shouldAddToDB) {
                // Save thumbnail image
                NSString *thumbnailURLString = [strongSelf.restClient generateThumbnailImageUrl:strongSelf.report.resourceLookup.uri];
                [strongSelf downloadThumbnailForSavedReport:strongSelf.savedReport
                                          resourceURLString:thumbnailURLString
                                                 completion:nil];
            }
        };
    }
    return self;
}

#pragma mark - Public API
- (void)saveReportWithName:(NSString *)name
                    format:(NSString *)format
                pagesRange:(JSReportPagesRange *)pagesRange
                   addToDB:(BOOL)addToDB
                completion:(SaveReportCompletion)completionBlock
{
    self.pagesRange = pagesRange;
    [self createNewSavedReportWithReport:self.report
                                    name:name
                                  format:format];
    
    BOOL isPrepeared = [self preparePathsForSavedReport:self.savedReport];
    if (!isPrepeared) {
        if (completionBlock) {
            // TODO: add error of creating the paths
            NSError *error = [NSError errorWithDomain:kJMReportSaverErrorDomain
                                                 code:JSReportSavingErrorCode
                                             userInfo:nil];
            completionBlock(nil, error);
        }
    } else {
        __weak typeof(self)weakSelf = self;
        [self fetchOutputResourceURLForReportWithFileExtension:format
                                                    completion:^(BOOL success, NSError *error) {
                                                        __strong typeof(self)strongSelf = weakSelf;
                                                        if (success) {
                                                            __weak typeof(self)weakSelf = strongSelf;
                                                            [strongSelf downloadSavedReport:strongSelf.savedReport
                                                                                 completion:^(NSError *downloadError) {
                                                                                     __strong typeof(self)strongSelf = weakSelf;
                                                                                     if (downloadError) {
                                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                                             if (completionBlock) {
                                                                                                 completionBlock(nil, downloadError);
                                                                                             }
                                                                                         });
                                                                                     } else {
                                                                                         strongSelf.downloadCompletion(addToDB);
                                                                                         
                                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                                             if (completionBlock) {
                                                                                                 completionBlock(strongSelf.savedReport, nil);
                                                                                             }
                                                                                         });
                                                                                     }
                                                                                 }];
                                                        } else {
                                                            [strongSelf cancelSavingReport];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                if (completionBlock) {
                                                                    completionBlock(nil, error);
                                                                }
                                                            });
                                                        }
                                                    }];
    }
}

- (void)downloadResourceFromURL:(NSURL *)url completion:(void(^)(NSString *resourcePath, NSError *error))completion {

    if (!completion) {
        return;
    }

    [JMUtils showNetworkActivityIndicator];

    __weak typeof(self) weakSelf = self;
    [self downloadResourceFromURLString:url.absoluteString
                             completion:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                 [JMUtils hideNetworkActivityIndicator];

                                 __strong typeof(self) strongSelf = weakSelf;

                                 if (!error) {
                                     NSString *tempDirectory = [JMSavedResources pathToTempReportsFolder];
                                     NSString *resourceName = url.lastPathComponent;
                                     NSString *tempReportPath = [NSString stringWithFormat:@"%@/%@", tempDirectory, resourceName];
                                     NSError *moveError = [strongSelf moveResourceFromPath:location.path toPath:tempReportPath];
                                     if (moveError) {
                                         completion(nil, moveError);
                                     } else {
                                         completion(tempReportPath, nil);
                                     }
                                 } else {
                                     completion(nil, error);
                                 }

                             }];
}

- (void)cancelSavingReport
{
    [self.reportExecutor cancel];
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData){
    }];
    
    [self removeTempDirectory];
}

#pragma mark - Private API
- (void)createNewSavedReportWithReport:(JMReport *)report name:(NSString *)name format:(NSString *)format
{
    self.savedReport = [JMSavedResources addReport:report.resourceLookup withName:name format:format];
}

- (BOOL)preparePathsForSavedReport:(JMSavedResources *)savedReport
{
    NSString *originalDirectory = [JMSavedResources pathToFolderForSavedReport:self.savedReport];
    NSString *temporaryDirectory = [JMSavedResources pathToTempFolderForSavedReport:self.savedReport];
    
    NSError *errorOfCreationLocation = [self createLocationAtPath:originalDirectory];
    NSError *errorOfCreationTempLocation = [self createLocationAtPath:temporaryDirectory];
    BOOL isPrepared = NO;
    if ( !(errorOfCreationLocation || errorOfCreationTempLocation) ) {
        isPrepared = YES;
    }
    return isPrepared;
}

- (void)downloadSavedReport:(JMSavedResources *)savedReport completion:(JMReportSaverCompletion)completion
{
    [self downloadSavedReport:savedReport
  withOutputResourceURLString:[self outputResourceURL]
                   completion:completion];
}

- (void)downloadSavedReport:(JMSavedResources *)savedReport
withOutputResourceURLString:(NSString *)outputResourceURLString
                 completion:(JMReportSaverCompletion)completion
{
    [JMUtils showNetworkActivityIndicator];
    
    __weak typeof(self)weakSelf = self;
    [self downloadResourceFromURLString:outputResourceURLString
                             completion:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                 __strong typeof(self)strongSelf = weakSelf;

                                 [JMUtils hideNetworkActivityIndicator];
                                 
                                 if (!error) {
                                     // save report to disk
                                     NSString *tempReportPath = [JMSavedResources absoluteTempPathToSavedReport:strongSelf.savedReport];
                                     NSError *moveError = [strongSelf moveResourceFromPath:location.path toPath:tempReportPath];
                                     if (moveError) {
                                         if (completion) {
                                             completion(moveError);
                                         }
                                     } else {
                                         // save attachments or exit
                                         if ([savedReport.format isEqualToString:kJS_CONTENT_TYPE_PDF]) {
                                             if (completion) {
                                                 completion(nil);
                                             }
                                         } else {
                                             [strongSelf downloadAttachmentsForSavedReport:strongSelf.savedReport
                                                                          completion:completion];
                                         }
                                     }
                                 }else {
                                     if (completion) {
                                         completion(error);
                                     }
                                 }
                             }];
}

- (void)downloadAttachmentsForSavedReport:(JMSavedResources *)savedReport completion:(JMReportSaverCompletion)completion
{
    NSMutableArray *attachmentNames = [NSMutableArray array];
    for (JSReportOutputResource *attachment in self.exportExecution.attachments) {
        [attachmentNames addObject:attachment.fileName];
    }
    
    __block NSInteger attachmentCount = attachmentNames.count;
    if (attachmentCount) {
        for (NSString *attachmentName in attachmentNames) {
            NSString *attachmentURLString = [self attachmentURLWithName:attachmentName];
            
            [JMUtils showNetworkActivityIndicator];
            __weak typeof(self)weakSelf = self;
            [self downloadResourceFromURLString:attachmentURLString
                                     completion:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                         __strong typeof(self)strongSelf = weakSelf;

                                         [JMUtils hideNetworkActivityIndicator];
                                         
                                         if (error) {
                                             if (completion) {
                                                 completion(error);
                                             }
                                         } else {
                                             NSString *attachmentPath = [strongSelf attachmentPathWithName:attachmentName];
                                             NSError *moveError = [strongSelf moveResourceFromPath:location.path toPath:attachmentPath];
                                             if (moveError) {
                                                 if (completion) {
                                                     completion(moveError);
                                                 }
                                             } else if (--attachmentCount == 0) {
                                                 if (completion) {
                                                     completion(nil);
                                                 }
                                             }
                                         }
                                     }];
        }
    } else {
        if (completion) {
            completion(nil);
        }
    }
}

#pragma mark - Network calls
- (void)downloadResourceFromURLString:(NSString *)resourceURLString
                           completion:(void(^)(NSURL *location, NSURLResponse *response, NSError *error))completion
{
    NSURL *URL = [NSURL URLWithString:resourceURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    self.downloadTask = [session downloadTaskWithRequest:request
                                       completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                           if (completion) {
                                               completion(location, response, error);
                                           }
                                       }];
    [self.downloadTask resume];
}

- (void)downloadThumbnailForSavedReport:(JMSavedResources *)savedReport
                      resourceURLString:(NSString *)resourceURLString
                             completion:(JMReportSaverCompletion)completion
{
    __weak typeof(self)weakSelf = self;
    [self downloadResourceFromURLString:resourceURLString
                             completion:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                 __strong typeof(self)strongSelf = weakSelf;
                                 if (!error) {
                                     NSString *thumbnailPath = [strongSelf thumbnailPath];
                                     [strongSelf moveResourceFromPath:location.path toPath:thumbnailPath];
                                 }
                             }];
}

#pragma mark - URI helpers
- (NSString *)exportURL
{
    return [self exportURLWithExportID:self.exportExecution.uuid];
}

- (NSString *)exportURLWithExportID:(NSString *)exportID
{
    // TODO: improve logic of making server URL
    NSString *serverURL = [self.restClient.serverProfile.serverUrl stringByAppendingString:@"/rest_v2"];
    return [serverURL stringByAppendingFormat:@"%@/%@/exports/%@/", kJS_REST_REPORT_EXECUTION_URI,self.requestExecution.requestId, exportID];
}

- (NSString *)outputResourceURL
{
    NSString *exportID = self.exportExecution.uuid;
    // Fix for JRS version smaller 5.6.0
    if (self.restClient.serverInfo.versionAsFloat < kJS_SERVER_VERSION_CODE_EMERALD_5_6_0) {
        exportID = [NSString stringWithFormat:@"%@;pages=%@;", self.savedReport.format, self.pagesRange.formattedPagesRange];
        NSString *attachmentPrefix = kJMAttachmentPrefix;
        exportID = [exportID stringByAppendingFormat:@"attachmentsPrefix=%@;", attachmentPrefix];
    }
    
    NSString *outputResourceURLString = [[self exportURLWithExportID:exportID] stringByAppendingString:@"outputResource?sessionDecorator=no&decorate=no#"];
    return outputResourceURLString;
}

- (NSString *)attachmentURLWithName:(NSString *)attachmentName
{
    return [[self exportURL] stringByAppendingFormat:@"attachments/%@", attachmentName];
}

#pragma mark - File manage helpers
- (NSError *)moveResourceFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:fromPath
                                            toPath:toPath
                                             error:&error];
    return error;
}

- (NSError *)moveContentFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    NSError *error;
    NSArray *items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fromPath error:&error];
    for (NSString *item in items) {
        NSString *itemFromPath = [fromPath stringByAppendingPathComponent:item];
        NSString *itemToPath = [toPath stringByAppendingPathComponent:item];
        [self moveResourceFromPath:itemFromPath toPath:itemToPath];
    }
    return error;
}

- (NSError *)removeReportAtPath:(NSString *)path
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    return error;
}

- (NSError *)createLocationAtPath:(NSString *)path
{
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    return error;
}

- (NSString *)attachmentPathWithName:(NSString *)attachmentName
{
    NSString *attachmentComponent = [NSString stringWithFormat:@"%@%@", (kJMAttachmentPrefix ?: @""), attachmentName];
    NSString *temporaryDirectory = [JMSavedResources pathToTempFolderForSavedReport:self.savedReport];
    NSString *attachmentPath = [temporaryDirectory stringByAppendingPathComponent:attachmentComponent];
    return attachmentPath;
}

- (NSString *)thumbnailPath
{
    NSString *originalDirectory = [JMSavedResources pathToFolderForSavedReport:self.savedReport];
    NSString *thumbnailPath = [originalDirectory stringByAppendingPathComponent:kJMThumbnailImageFileName];
    return thumbnailPath;
}

- (void)removeTempDirectory
{
    NSString *tempDirectory = [JMSavedResources pathToTempReportsFolder];
    [self removeReportAtPath:tempDirectory];
}

#pragma mark - Helpers
- (void)fetchOutputResourceURLForReportWithFileExtension:(NSString *)format
                                              completion:(void(^)(BOOL success, NSError *error))completion
{
    self.reportExecutor.asyncExecution = YES;
    self.reportExecutor.interactive = NO;
    self.reportExecutor.attachmentsPrefix = kJMAttachmentPrefix;
    self.reportExecutor.format = format;
    
    __weak typeof (self) weakSelf = self;
    [self.reportExecutor executeWithCompletion:^(JSReportExecutionResponse *executionResponse, NSError *executionError) {
        __strong typeof(self)strongSelf = weakSelf;
        if (executionResponse) {
            self.requestExecution = executionResponse;

            __weak typeof (self) weakSelf = strongSelf;
            [self.reportExecutor exportForRange:self.pagesRange withCompletion:^(JSExportExecutionResponse * _Nullable exportResponse, NSError * _Nullable exportError) {
                __strong typeof(self)strongSelf = weakSelf;
                if (exportResponse) {
                    strongSelf.exportExecution = exportResponse;
                    if (completion) {
                        completion(YES, nil);
                    }
                } else {
                    if (completion) {
                        completion(NO, exportError);
                    }
                }
            }];
        } else {
            if (completion) {
                completion(NO, executionError);
            }
        }
    }];
}

- (BOOL)isExistSavedReport:(JMSavedResources *)savedReport
{
    NSString *fileReportPath = [JMSavedResources absolutePathToSavedReport:self.savedReport];
    BOOL isExistInFS = [[NSFileManager defaultManager] fileExistsAtPath:fileReportPath];
    return isExistInFS;
}

@end
