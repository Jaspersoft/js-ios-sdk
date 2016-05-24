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
#import "JSReportExecutor.h"
#import "JSReportExecutionConfiguration.h"
#import "JSRESTBase+JSRESTReport.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface JSReportSaver()

@property (nonatomic, strong, nullable) NSString *tempReportDirectory;
@property (nonatomic, copy) JSSaveReportCompletion saveReportCompletion;

@end

@implementation JSReportSaver

#pragma mark - Public API
- (void)saveReportWithName:(NSString *)name format:(NSString *)format pagesRange:(JSReportPagesRange *)pagesRange completion:(JSSaveReportCompletion)completionBlock {
    self.saveReportCompletion = completionBlock;
    
    __weak typeof(self)weakSelf = self;
    JSReportExecutionConfiguration *saveReportConfiguration = [JSReportExecutionConfiguration saveReportConfigurationWithFormat:format pagesRange:pagesRange];
    [self executeWithConfiguration:saveReportConfiguration completion:^(JSReportExecutionResponse * _Nullable executionResponse, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error) {
            [self sendCallbackWithError:error];
        } else {
            __weak typeof(self)weakSelf = strongSelf;
            [strongSelf exportWithCompletion:^(JSExportExecutionResponse * _Nullable exportResponse, NSError * _Nullable error) {
                __strong typeof(self)strongSelf = weakSelf;
                if (error) {
                    [self sendCallbackWithError:error];
                } else {
                    NSString *exportID = exportResponse.uuid;
                    // Fix for JRS version smaller 5.6.0
                    if (strongSelf.restClient.serverInfo.versionAsFloat < kJS_SERVER_VERSION_CODE_EMERALD_5_6_0) {
                        exportID = [NSString stringWithFormat:@"%@;pages=%@;", format, pagesRange.formattedPagesRange];
                        NSString *attachmentPrefix = strongSelf.configuration.attachmentsPrefix;
                        exportID = [exportID stringByAppendingFormat:@"attachmentsPrefix=%@;", attachmentPrefix];
                    }
                    NSString *outputResourceURLString = [strongSelf.restClient generateReportOutputUrl:strongSelf.executionResponse.requestId exportOutput:exportID];
                    
                    // save report to disk
                    NSString *tempAppDirectory = NSTemporaryDirectory();
                    self.tempReportDirectory = [tempAppDirectory stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]];
                    NSString *tempReportPath = [[self.tempReportDirectory stringByAppendingPathComponent:name] stringByAppendingPathExtension:format];
                    __weak typeof(self)weakSelf = strongSelf;
                    [JSReportSaver downloadResourceWithRestClient:self.restClient fromURLString:outputResourceURLString destinationPath:tempReportPath completion:^(NSError *error) {
                        __strong typeof(self)strongSelf = weakSelf;
                        if (error) {
                            [self sendCallbackWithError:error];
                        } else {
                            // save attachments or exit
                            NSMutableArray *attachmentNames = [exportResponse.attachments valueForKeyPath:@"@unionOfObjects.fileName"];
                            [strongSelf downloadAttachments:attachmentNames forExport:exportResponse withCompletion:^(NSError *error) {
                                [self sendCallbackWithError:error];
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)cancelSavingReport {
    self.saveReportCompletion = nil;
    [self cancelReportExecution];
    [self.restClient cancelAllRequests];
    
    [self removeTempReportDirectory];
}

#pragma mark - Network calls
+ (void)downloadResourceWithRestClient:(JSRESTBase *)restClient
                         fromURLString:(NSString *)resourceURLString
                      destinationPath:(NSString *)destinationPath
                            completion:(void(^)(NSError *error))completion {
    NSString *fileDirectory = [destinationPath stringByDeletingLastPathComponent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileDirectory isDirectory:nil]) {
        NSError * directoryCreationError = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:fileDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&directoryCreationError];
        if (directoryCreationError) {
            if (completion) {
                completion(directoryCreationError);
            }
            return;
        }
    }
    NSURLRequest *request = [restClient.requestSerializer requestWithMethod:[JSRequest httpMethodStringRepresentation: JSRequestHTTPMethodGET]
                                                                  URLString:resourceURLString parameters:nil error:nil];
    [[restClient downloadTaskWithRequest:request
                                progress:nil
                             destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                 return [NSURL fileURLWithPath:destinationPath];
                             } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                 if (error && [[NSFileManager defaultManager] fileExistsAtPath:filePath.path]) {
                                     [[NSFileManager defaultManager] removeItemAtPath:filePath.path error:nil];
                                 }
                                 if (completion) {
                                     NSError *handledError = error;
                                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                     
                                     if (httpResponse.statusCode == 401) {
                                         handledError = [JSErrorBuilder httpErrorWithCode:JSSessionExpiredErrorCode
                                                                                 HTTPCode:httpResponse.statusCode];
                                     } else if (httpResponse.statusCode && !error) {
                                         handledError = [JSErrorBuilder httpErrorWithCode:JSHTTPErrorCode
                                                                                 HTTPCode:httpResponse.statusCode];
                                     } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
                                         switch (error.code) {
                                             case NSURLErrorUserCancelledAuthentication:
                                             case NSURLErrorUserAuthenticationRequired: {
                                                 handledError = [JSErrorBuilder errorWithCode:JSSessionExpiredErrorCode];
                                                 break;
                                             }
                                             case NSURLErrorCannotFindHost:
                                             case NSURLErrorCannotConnectToHost:
                                             case NSURLErrorResourceUnavailable:{
                                                 handledError = [JSErrorBuilder errorWithCode:JSServerNotReachableErrorCode];
                                                 break;
                                             }
                                             case NSURLErrorTimedOut: {
                                                 handledError = [JSErrorBuilder errorWithCode:JSRequestTimeOutErrorCode];
                                                 break;
                                             }
                                             default: {
                                                 handledError = [JSErrorBuilder errorWithCode:JSHTTPErrorCode message:error.localizedDescription];
                                             }
                                         }
                                     }
                                     
                                     completion(handledError);
                                 }
                             }] resume];
}

- (void) downloadAttachments:(NSMutableArray *)attachments forExport:(JSExportExecutionResponse *)exportResponse withCompletion:(void(^)(NSError *error))completionBlock {
    if (attachments.count) {
        NSString *attachmentName = attachments.firstObject;
        NSString *attachmentURLString = [[self exportURLWithExportID:exportResponse.uuid] stringByAppendingFormat:@"attachments/%@", attachmentName];
        NSString *attachmentPath = [self attachmentPathWithName:attachmentName];

        
        __weak typeof(self)weakSelf = self;
        [JSReportSaver downloadResourceWithRestClient:self.restClient fromURLString:attachmentURLString destinationPath:attachmentPath completion:^(NSError *error) {

            __strong typeof(self)strongSelf = weakSelf;
            if (error) {
                if (completionBlock) {
                    completionBlock(error);
                }
            } else {
                [attachments removeObject:attachmentName];
                [strongSelf downloadAttachments:attachments forExport:exportResponse withCompletion:completionBlock];
            }
        }];
    } else {
        if (completionBlock) {
            completionBlock(nil);
        }
    }
}

#pragma mark - URI helpers
- (NSString *)exportURLWithExportID:(NSString *)exportID {
    NSString *serverURL = [self.restClient.serverProfile.serverUrl stringByAppendingString:@"/rest_v2"];
    return [serverURL stringByAppendingFormat:@"%@/%@/exports/%@/", kJS_REST_REPORT_EXECUTION_URI,self.executionResponse.requestId, exportID];
}

#pragma mark - File manage helpers
- (NSError *)moveResourceFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:fromPath
                                            toPath:toPath
                                             error:&error];
    if (error) { // Remove all UDID's path components from error message
        NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
        NSString *errorMessage = userInfo[NSLocalizedDescriptionKey];
        if (errorMessage) {
            errorMessage = [errorMessage stringByReplacingOccurrencesOfString:fromPath withString:[toPath lastPathComponent]];
            errorMessage = [errorMessage stringByReplacingOccurrencesOfString:toPath withString:[toPath lastPathComponent]];
            
            userInfo[NSLocalizedDescriptionKey] = errorMessage;
        }
        return [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
    }
    return nil;
}

- (NSString *)attachmentPathWithName:(NSString *)attachmentName {
    NSString *attachmentComponent = [NSString stringWithFormat:@"%@%@", (self.configuration.attachmentsPrefix ?: @""), attachmentName];
    return [self.tempReportDirectory stringByAppendingPathComponent:attachmentComponent];
}

- (void) removeTempReportDirectory {
    [[NSFileManager defaultManager] removeItemAtPath:self.tempReportDirectory error:nil];
}

- (void) sendCallbackWithError:(NSError *)error {
    if (self.saveReportCompletion) {
        if (error) {
            self.saveReportCompletion(nil , error);
            [self cancelSavingReport];
        } else {
            NSURL *reportURL = [NSURL fileURLWithPath:self.tempReportDirectory isDirectory:YES];
            self.saveReportCompletion(reportURL, nil);
        }
    }
}

@end
