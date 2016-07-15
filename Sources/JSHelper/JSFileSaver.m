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
//  JSFileSaver.m
//  Jaspersoft Corporation
//

#import "JSFileSaver.h"

@implementation JSFileSaver
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
                                     
                                     if ((httpResponse.statusCode < 200 && httpResponse.statusCode >= 300) || error) {
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
                                     }
                                     
                                     completion(handledError);
                                 }
                             }] resume];
}

@end
