/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


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
    NSMutableURLRequest *request = [restClient.requestSerializer requestWithMethod:[JSRequest httpMethodStringRepresentation: JSRequestHTTPMethodGET]
                                                                         URLString:resourceURLString parameters:nil error:nil];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];   // This fix is needed for correct images loading!!!
    
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
