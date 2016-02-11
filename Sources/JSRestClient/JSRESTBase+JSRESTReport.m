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
//  JSRESTBase+JSRESTReport.m
//  Jaspersoft Corporation
//

#import "JSReportExecutionRequest.h"
#import "JSReportExecutionResponse.h"
#import "JSExportExecutionRequest.h"
#import "JSExportExecutionResponse.h"
#import "JSErrorDescriptor.h"

#import "JSRESTBase+JSRESTReport.h"
#import "JSInputControlOption.h"

#import "JSReportExecutionRequest.h"
#import "RKURLEncodedSerialization.h"

// Report query used for setting output format (i.e PDF, HTML, etc.)
// and path for images (current dir) when exporting report in HTML
static NSString * const _baseReportQueryImagesParam = @"IMAGES_URI";
static NSString * const _baseReportQueryOutputFormatParam = @"RUN_OUTPUT_FORMAT";


@interface JSRESTBase (PrivateAPI)
- (void) addReportParametersToRequest:(JSRequest *)request withSelectedValues:(NSArray *)selectedValues;

- (NSString *)fullReportExecutionUri:(NSString *)requestId;

- (NSString *)fullDownloadReportFileUri:(NSString *)uuid;

- (NSString *)fullRunReportUri:(NSString *)uri;

- (NSString *)fullReportsUriForIC:(NSString *)uri withInputControls:(NSArray <NSString *> *)dependencies initialValuesOnly:(BOOL)initialValuesOnly;

- (NSString *)fullExportExecutionUri:(NSString *)requestId;

- (NSDictionary *)runReportQueryParams:(NSString *)format;

- (NSString *)encodeAttachmentsPrefix:(NSString *)exportOutput;
@end

@implementation JSRESTBase (JSRESTReportOptions)

- (void)inputControlsForReport:(NSString *)reportUri ids:(NSArray <NSString *> *)ids
                selectedValues:(NSArray <JSReportParameter *> *)selectedValues completionBlock:(JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullReportsUriForIC:reportUri withInputControls:ids initialValuesOnly:NO]];
    request.expectedModelClass = [JSInputControlDescriptor class];
    request.restVersion = JSRESTVersion_2;
    request.method = (ids && [ids count]) ? JSRequestHTTPMethodPOST : JSRequestHTTPMethodGET;
    request.completionBlock = block;
    [self addReportParametersToRequest:request withSelectedValues:selectedValues];
    [self sendRequest:request];
}

- (void)updatedInputControlsValues:(NSString *)reportUri ids:(NSArray <NSString *> *)ids
                    selectedValues:(NSArray <JSReportParameter *> *)selectedValues completionBlock:(JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullReportsUriForIC:reportUri withInputControls:ids initialValuesOnly:YES]];
    request.expectedModelClass = [JSInputControlState class];
    request.method = JSRequestHTTPMethodPOST;
    request.restVersion = JSRESTVersion_2;
    [self addReportParametersToRequest:request withSelectedValues:selectedValues];
    request.completionBlock = block;
    [self sendRequest:request];
}

- (void)reportOptionsForReportURI:(NSString *)reportURI completion:(JSRequestCompletionBlock)block {
    NSString *uri = [NSString stringWithFormat:@"%@%@%@", kJS_REST_REPORTS_URI, reportURI, kJS_REST_REPORT_OPTIONS_URI];
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.expectedModelClass = [JSReportOption class];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    [self sendRequest:request];
}

- (void)deleteReportOption:(JSReportOption *)reportOption
             withReportURI:(NSString *)reportURI
                completion:(JSRequestCompletionBlock)completion {
    NSString *requestURIString = [NSString stringWithFormat:@"%@%@%@/%@",
                                  kJS_REST_REPORTS_URI,
                                  reportURI,
                                  kJS_REST_REPORT_OPTIONS_URI,
                                  reportOption.identifier];
    JSRequest *request = [[JSRequest alloc] initWithUri:requestURIString];
    request.restVersion = JSRESTVersion_2;
    request.method = JSRequestHTTPMethodDELETE;
    request.completionBlock = completion;
    [self sendRequest:request];
}

- (void)createReportOptionWithReportURI:(NSString *)reportURI
                            optionLabel:(NSString *)optionLabel
                       reportParameters:(NSArray <JSReportParameter *> *)reportParameters
                             completion:(JSRequestCompletionBlock)completion {
    NSString *requestURIString = [NSString stringWithFormat:@"%@%@%@?label=%@&overwrite=%@",
                                  kJS_REST_REPORTS_URI,
                                  reportURI,
                                  kJS_REST_REPORT_OPTIONS_URI, optionLabel, [JSUtils stringFromBOOL:YES]];
    
    JSRequest *request = [[JSRequest alloc] initWithUri:requestURIString];
    request.expectedModelClass = [JSReportOption class];
    request.restVersion = JSRESTVersion_2;
    request.method = JSRequestHTTPMethodPOST;
    [self addReportParametersToRequest:request withSelectedValues:reportParameters];
    request.completionBlock = completion;
    [self sendRequest:request];
}

@end

@implementation JSRESTBase (JSRESTReportExecution)

- (NSString *)generateReportUrl:(NSString *)uri reportParams:(NSArray <JSReportParameter *> *)reportParams
                           page:(NSInteger)page format:(NSString *)format {
    NSMutableDictionary *queryParams = [NSMutableDictionary new];
    if (page > 0) {
        [queryParams setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    }
    
    for (JSReportParameter *reportParam in reportParams) {
        if (reportParam.name && reportParam.value) {
            if ([reportParam.value count] > 1) {
                [queryParams setObject:reportParam.value forKey:reportParam.name];
            } else {
                if (reportParam.value.lastObject) {
                    [queryParams setObject:reportParam.value.lastObject forKey:reportParam.name];
                }
            }
        }
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@%@%@.%@", self.serverProfile.serverUrl,
                     kJS_REST_SERVICES_V2_URI, kJS_REST_REPORTS_URI, uri, format];
    
    NSString *queryString = RKURLEncodedStringFromDictionaryWithEncoding(queryParams, NSUTF8StringEncoding);
    url = [url stringByAppendingFormat:([url rangeOfString:@"?"].location == NSNotFound) ? @"?%@" : @"&%@" ,queryString];
    
    // TODO: remove code duplication...
    // Remove all [] for query params (i.e. query &PL_Country_multi_select[]=Mexico&PL_Country_multi_select[]=USA will
    // be changed to &PL_Country_multi_select=Mexico&PL_Country_multi_select=USA without any [])
    NSString *brackets = @"[]";
    if ([url rangeOfString:brackets].location != NSNotFound) {
        url = [url stringByReplacingOccurrencesOfString:brackets withString:@""];
    }
    
    return url;
}

- (void)runReportExecution:(NSString *)reportUnitUri async:(BOOL)async outputFormat:(NSString *)outputFormat
               interactive:(BOOL)interactive freshData:(BOOL)freshData saveDataSnapshot:(BOOL)saveDataSnapshot
          ignorePagination:(BOOL)ignorePagination transformerKey:(NSString *)transformerKey pages:(NSString *)pages
         attachmentsPrefix:(NSString *)attachmentsPrefix parameters:(NSArray <JSReportParameter *> *)parameters completionBlock:(JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullReportExecutionUri:nil]];
    request.expectedModelClass = [JSReportExecutionResponse class];
    request.method = JSRequestHTTPMethodPOST;
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    
    JSReportExecutionRequest *executionRequest = [[JSReportExecutionRequest alloc] init];
    executionRequest.reportUnitUri = reportUnitUri;
    executionRequest.async = [JSUtils stringFromBOOL:async];
    executionRequest.interactive = [JSUtils stringFromBOOL:interactive];
    executionRequest.freshData = [JSUtils stringFromBOOL:freshData];
    executionRequest.saveDataSnapshot = [JSUtils stringFromBOOL:saveDataSnapshot];
    executionRequest.ignorePagination = [JSUtils stringFromBOOL:ignorePagination];
    executionRequest.outputFormat = outputFormat;
    executionRequest.transformerKey = transformerKey;
    executionRequest.pages = pages;
    executionRequest.attachmentsPrefix = attachmentsPrefix;
    executionRequest.parameters = parameters;
    if (self.serverInfo.versionAsFloat >= kJS_SERVER_VERSION_CODE_EMERALD_5_6_0) {
        executionRequest.baseURL = self.serverProfile.serverUrl;
    }
    request.body = executionRequest;
    [self sendRequest:request];
}

- (void)cancelReportExecution:(NSString *)requestId completionBlock:(JSRequestCompletionBlock)block {
    NSString *uri = [[self fullReportExecutionUri:requestId] stringByAppendingString:kJS_REST_REPORT_EXECUTION_STATUS_URI];
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.expectedModelClass = [JSExecutionStatus class];
    request.method = JSRequestHTTPMethodPUT;
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    request.shouldResendRequestAfterSessionExpiration = NO;
    
    JSExecutionStatus *status = [JSExecutionStatus new];
    status.statusAsString = @"cancelled";
    request.body = status;
    
    [self sendRequest:request];
}

- (void)runExportExecution:(NSString *)requestId outputFormat:(NSString *)outputFormat pages:(NSString *)pages
         attachmentsPrefix:(NSString *)attachmentsPrefix completionBlock:(JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullExportExecutionUri:requestId]];
    request.expectedModelClass = [JSExportExecutionResponse class];
    request.method = JSRequestHTTPMethodPOST;
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    request.shouldResendRequestAfterSessionExpiration = NO;

    JSExportExecutionRequest *executionRequest = [[JSExportExecutionRequest alloc] init];
    executionRequest.outputFormat = outputFormat;
    executionRequest.pages = pages;
    if (self.serverInfo.versionAsFloat >= kJS_SERVER_VERSION_CODE_EMERALD_5_6_0) {
        executionRequest.baseUrl = self.serverProfile.serverUrl;
        executionRequest.attachmentsPrefix = attachmentsPrefix;
    }
    request.body = executionRequest;
    [self sendRequest:request];
}

- (NSString *)generateReportOutputUrl:(NSString *)requestId exportOutput:(NSString *)exportOutput {
    return [NSString stringWithFormat:@"%@/%@%@/%@/exports/%@/outputResource", self.serverProfile.serverUrl, kJS_REST_SERVICES_V2_URI, kJS_REST_REPORT_EXECUTION_URI, requestId, exportOutput];
}

- (void)reportExecutionMetadataForRequestId:(NSString *)requestId completionBlock:(JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullReportExecutionUri:requestId]];
    request.expectedModelClass = [JSReportExecutionResponse class];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    request.shouldResendRequestAfterSessionExpiration = NO;

    [self sendRequest:request];
}

- (void)reportExecutionStatusForRequestId:(NSString *)requestId completionBlock:(JSRequestCompletionBlock)block {
    NSString *uri = [[self fullReportExecutionUri:requestId] stringByAppendingString:kJS_REST_REPORT_EXECUTION_STATUS_URI];
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.expectedModelClass = [JSExecutionStatus class];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    request.shouldResendRequestAfterSessionExpiration = NO;

    [self sendRequest:request];
}

- (void)exportExecutionStatusWithExecutionID:(NSString *)executionID exportOutput:(NSString *)exportOutput completion:(JSRequestCompletionBlock)block {
    NSString *uri = [NSString stringWithFormat:@"%@/%@/exports/%@/status", kJS_REST_REPORT_EXECUTION_URI, executionID, exportOutput];
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.expectedModelClass = [JSExecutionStatus class];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    request.shouldResendRequestAfterSessionExpiration = NO;

    [self sendRequest:request];
}

- (void)loadReportOutput:(NSString *)requestId exportOutput:(NSString *)exportOutput
           loadForSaving:(BOOL)loadForSaving path:(NSString *)path completionBlock:(JSRequestCompletionBlock)block {
    exportOutput = [self encodeAttachmentsPrefix:exportOutput];
    NSString *uri = [NSString stringWithFormat:@"%@/%@/exports/%@/outputResource?sessionDecorator=no&decorate=no#", kJS_REST_REPORT_EXECUTION_URI, requestId, exportOutput];
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    request.shouldResendRequestAfterSessionExpiration = NO;

    if (loadForSaving) {
        request.downloadDestinationPath = path;
        request.responseAsObjects = NO;
    }
    
    [self sendRequest:request];
}

- (void)saveReportAttachment:(NSString *)requestId exportOutput:(NSString *)exportOutput
              attachmentName:(NSString *)attachmentName path:(NSString *)path completionBlock:(JSRequestCompletionBlock)block {
    exportOutput = [self encodeAttachmentsPrefix:exportOutput];
    NSString *uri = [NSString stringWithFormat:@"%@/%@/exports/%@/attachments/%@", kJS_REST_REPORT_EXECUTION_URI, requestId, exportOutput, attachmentName];
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    request.downloadDestinationPath = path;
    request.responseAsObjects = NO;
    request.shouldResendRequestAfterSessionExpiration = NO;

    [self sendRequest:request];
}

@end

@implementation JSRESTBase (PrivateAPI)
- (void) addReportParametersToRequest:(JSRequest *)request withSelectedValues:(NSArray *)selectedValues {
    for (JSReportParameter *parameter in selectedValues) {
        [request addParameter:parameter.name withArrayValue:parameter.value];
    }
}

- (NSString *)fullReportExecutionUri:(NSString *)requestId {
    NSString *reportExecutionUri = kJS_REST_REPORT_EXECUTION_URI;
    
    if (!requestId.length) return reportExecutionUri;
    return [NSString stringWithFormat:@"%@/%@", reportExecutionUri, requestId];
}

- (NSString *)fullDownloadReportFileUri:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@/%@", kJS_REST_REPORT_URI, uuid];
}

- (NSString *)fullRunReportUri:(NSString *)uri {
    return [NSString stringWithFormat:@"%@%@", kJS_REST_REPORT_URI, (uri ?: @"")];
}

- (NSString *)fullReportsUriForIC:(NSString *)uri withInputControls:(NSArray <NSString *> *)dependencies initialValuesOnly:(BOOL)initialValuesOnly {
    NSString *fullReportsUri = [NSString stringWithFormat:@"%@%@%@", kJS_REST_REPORTS_URI, (uri ?: @""), kJS_REST_INPUT_CONTROLS_URI];
    
    if (dependencies && dependencies.count) {
        NSMutableString *dependenciesUriPart = [[NSMutableString alloc] initWithString:@"/"];
        for (NSString *dependency in dependencies) {
            [dependenciesUriPart appendFormat:@"%@;", dependency];
        }
        fullReportsUri = [fullReportsUri stringByAppendingString:dependenciesUriPart];
    }
    
    if (initialValuesOnly) {
        fullReportsUri = [fullReportsUri stringByAppendingString:kJS_REST_VALUES_URI];
    }
    
    return fullReportsUri;
}

- (NSString *)fullExportExecutionUri:(NSString *)requestId {
    return [NSString stringWithFormat:@"%@/%@%@", kJS_REST_REPORT_EXECUTION_URI, requestId, kJS_REST_EXPORT_EXECUTION_URI];
}

- (NSDictionary *)runReportQueryParams:(NSString *)format {
    return [NSDictionary dictionaryWithObjectsAndKeys:@"./", _baseReportQueryImagesParam,
            format, _baseReportQueryOutputFormatParam, nil];
}

// TODO: refactor, find better way to make URL encoded string
- (NSString *)encodeAttachmentsPrefix:(NSString *)exportOutput {
    NSRange prefixRange = [exportOutput rangeOfString:@"attachmentsPrefix="];
    
    if (prefixRange.location != NSNotFound) {
        NSInteger location = prefixRange.location + prefixRange.length;
        NSRange valueRange = NSMakeRange(location, exportOutput.length - location);
        NSString *value = [exportOutput substringWithRange:valueRange];
        if (value.length) {
            CFStringRef encodedValue = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) value, NULL, (CFStringRef) @"!*’();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
            value = CFBridgingRelease(encodedValue);
            exportOutput = [exportOutput stringByReplacingCharactersInRange:valueRange withString:value];
        }
    }
    
    return exportOutput;
}

@end
