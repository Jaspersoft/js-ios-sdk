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

#import <EasyMapping/EKMapper.h>
#import "JSReportExecutionRequest.h"
#import "JSReportExecutionResponse.h"
#import "JSExportExecutionRequest.h"
#import "JSExportExecutionResponse.h"
#import "JSErrorDescriptor.h"

#import "JSRESTBase+JSRESTReport.h"
#import "JSInputControlOption.h"

#import "AFURLRequestSerialization.h"
#import "JSReportComponent.h"


@interface JSRESTBase (PrivateAPI)
- (void) addReportParametersToRequest:(JSRequest *)request withSelectedValues:(NSArray *)selectedValues;

- (NSString *)fullReportExecutionUri:(NSString *)requestId;

- (NSString *)fullReportsUriForIC:(NSString *)uri withInputControls:(NSArray <NSString *> *)dependencies initialValuesOnly:(BOOL)initialValuesOnly;

- (NSString *)fullExportExecutionUri:(NSString *)requestId;

- (NSString *)encodeAttachmentsPrefix:(NSString *)exportOutput;
@end

@implementation JSRESTBase (JSRESTReportOptions)

- (void)inputControlsForReport:(NSString *)reportUri selectedValues:(NSArray <JSReportParameter *> *)selectedValues
               completionBlock:(JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[NSString stringWithFormat:@"%@%@%@", kJS_REST_REPORTS_URI, (reportUri.hostEncodedString ?: @""), kJS_REST_INPUT_CONTROLS_URI]];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSInputControlDescriptor objectMappingForServerProfile:self.serverProfile] keyPath:@"inputControl"];
    request.restVersion = JSRESTVersion_2;
    request.method = ([selectedValues count]) ? JSRequestHTTPMethodPOST : JSRequestHTTPMethodGET;
    request.completionBlock = block;
    [self addReportParametersToRequest:request withSelectedValues:selectedValues];
    [self sendRequest:request];
}

- (void)updatedInputControlsValues:(NSString *)reportUri ids:(NSArray <NSString *> *)ids
                    selectedValues:(NSArray <JSReportParameter *> *)selectedValues completionBlock:(JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullReportsUriForIC:reportUri withInputControls:ids initialValuesOnly:YES]];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSInputControlState objectMappingForServerProfile:self.serverProfile] keyPath:@"inputControlState"];
    request.method = JSRequestHTTPMethodPOST;
    request.restVersion = JSRESTVersion_2;
    [self addReportParametersToRequest:request withSelectedValues:selectedValues];
    request.completionBlock = block;
    [self sendRequest:request];
}

- (void)reportOptionsForReportURI:(NSString *)reportURI completion:(JSRequestCompletionBlock)block {
    NSString *uri = [NSString stringWithFormat:@"%@%@%@", kJS_REST_REPORTS_URI, reportURI.hostEncodedString, kJS_REST_REPORT_OPTIONS_URI];
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSReportOption objectMappingForServerProfile:self.serverProfile] keyPath:@"reportOptionsSummary"];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    [self sendRequest:request];
}

- (void)deleteReportOption:(JSReportOption *)reportOption
             withReportURI:(NSString *)reportURI
                completion:(JSRequestCompletionBlock)completion {
    NSString *requestURIString = [NSString stringWithFormat:@"%@%@%@/%@",
                                                            kJS_REST_REPORTS_URI,
                                                            reportURI.hostEncodedString,
                                                            kJS_REST_REPORT_OPTIONS_URI,
                                                            reportOption.identifier.hostEncodedString];
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
                                                            reportURI.hostEncodedString,
                                                            kJS_REST_REPORT_OPTIONS_URI, optionLabel.queryEncodedString, [JSUtils stringFromBOOL:YES]];

    JSRequest *request = [[JSRequest alloc] initWithUri:requestURIString];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSReportOption objectMappingForServerProfile:self.serverProfile] keyPath:nil];
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
                if ([reportParam.value lastObject]) {
                    [queryParams setObject:[reportParam.value lastObject] forKey:reportParam.name];
                }
            }
        }
    }

    NSString *urlString = [NSString stringWithFormat:@"%@/%@%@%@.%@", self.serverProfile.serverUrl,
                                                     kJS_REST_SERVICES_V2_URI, kJS_REST_REPORTS_URI, uri.hostEncodedString, format.hostEncodedString];


    AFHTTPRequestSerializer *urlSerializer = [AFHTTPRequestSerializer new];
    NSURLRequest *urlRequest = [urlSerializer requestWithMethod:@"GET" URLString:urlString parameters:queryParams error:nil];

    urlString = [urlRequest URL].path;

    // TODO: remove code duplication...
    // Remove all [] for query params (i.e. query &PL_Country_multi_select[]=Mexico&PL_Country_multi_select[]=USA will
    // be changed to &PL_Country_multi_select=Mexico&PL_Country_multi_select=USA without any [])
    NSString *brackets = @"[]";
    if ([urlString rangeOfString:brackets].location != NSNotFound) {
        urlString = [urlString stringByReplacingOccurrencesOfString:brackets withString:@""];
    }

    return urlString;
}

- (void)runReportExecution:(NSString *)reportUnitUri
                     async:(BOOL)async
              outputFormat:(NSString *)outputFormat
               interactive:(BOOL)interactive
                 freshData:(BOOL)freshData
          saveDataSnapshot:(BOOL)saveDataSnapshot
          ignorePagination:(BOOL)ignorePagination
            transformerKey:(NSString *)transformerKey
                     pages:(NSString *)pages
         attachmentsPrefix:(NSString *)attachmentsPrefix
                parameters:(NSArray <JSReportParameter *> *)parameters
           completionBlock:(JSRequestCompletionBlock)block
{
    [self runReportExecution:reportUnitUri
                       async:async
                outputFormat:outputFormat
                  markupType:JSMarkupTypeFull
                 interactive:interactive
                   freshData:freshData
            saveDataSnapshot:saveDataSnapshot
            ignorePagination:ignorePagination
              transformerKey:transformerKey
                       pages:pages
           attachmentsPrefix:attachmentsPrefix
                  parameters:parameters
             completionBlock:block];
}

- (void)runReportExecution:(nonnull NSString *)reportUnitUri
                     async:(BOOL)async
              outputFormat:(nonnull NSString *)outputFormat
                markupType:(JSMarkupType)markupType
               interactive:(BOOL)interactive
                 freshData:(BOOL)freshData
          saveDataSnapshot:(BOOL)saveDataSnapshot
          ignorePagination:(BOOL)ignorePagination
            transformerKey:(nullable NSString *)transformerKey
                     pages:(nullable NSString *)pages
         attachmentsPrefix:(nullable NSString *)attachmentsPrefix
                parameters:(nullable NSArray <JSReportParameter *> *)parameters
           completionBlock:(nullable JSRequestCompletionBlock)block
{
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullReportExecutionUri:nil]];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSReportExecutionResponse objectMappingForServerProfile:self.serverProfile] keyPath:nil];
    request.method = JSRequestHTTPMethodPOST;
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;

    JSReportExecutionRequest *executionRequest = [[JSReportExecutionRequest alloc] init];
    executionRequest.reportUnitUri = reportUnitUri;
    executionRequest.async = [JSUtils stringFromBOOL:async];
    executionRequest.interactive = [JSUtils stringFromBOOL:interactive];
    executionRequest.freshData = [JSUtils stringFromBOOL:freshData];
    executionRequest.saveDataSnapshot = [JSUtils stringFromBOOL:saveDataSnapshot];
    executionRequest.outputFormat = outputFormat;
    executionRequest.transformerKey = transformerKey;
    executionRequest.pages = pages;
    executionRequest.attachmentsPrefix = attachmentsPrefix;
    executionRequest.parameters = parameters;
    
    if (ignorePagination) {
        executionRequest.ignorePagination = [JSUtils stringFromBOOL:ignorePagination];
    }

    if (self.serverInfo.versionAsFloat >= kJS_SERVER_VERSION_CODE_EMERALD_5_6_0) {
        executionRequest.baseURL = self.serverProfile.serverUrl;
    }

    if (self.serverInfo.versionAsFloat >= kJS_SERVER_VERSION_CODE_AMBER_6_0_0) {
        executionRequest.markupType = markupType;
    }

    request.body = executionRequest;
    [self sendRequest:request];
}


- (void)cancelReportExecution:(NSString *)requestId completionBlock:(JSRequestCompletionBlock)block {
    NSString *uri = [[self fullReportExecutionUri:requestId] stringByAppendingString:kJS_REST_REPORT_EXECUTION_STATUS_URI];
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSExecutionStatus objectMappingForServerProfile:self.serverProfile] keyPath:nil];
    request.method = JSRequestHTTPMethodPUT;
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    request.shouldResendRequestAfterSessionExpiration = NO;

    JSExecutionStatus *status = [JSExecutionStatus new];
    status.status = kJS_EXECUTION_STATUS_CANCELED;
    request.body = status;

    [self sendRequest:request];
}

- (void)runExportExecution:(NSString *)requestId
              outputFormat:(NSString *)outputFormat
                     pages:(NSString *)pages
         attachmentsPrefix:(NSString *)attachmentsPrefix
           completionBlock:(JSRequestCompletionBlock)block
{
    [self runExportExecution:requestId
                outputFormat:outputFormat
                       pages:pages
                  markupType:JSMarkupTypeFull
           attachmentsPrefix:attachmentsPrefix
             completionBlock:block];
}

- (void)runExportExecution:(nonnull NSString *)requestId
              outputFormat:(nonnull NSString *)outputFormat
                     pages:(nullable NSString *)pages
                markupType:(JSMarkupType)markupType
         attachmentsPrefix:(nullable NSString *)attachmentsPrefix
           completionBlock:(nullable JSRequestCompletionBlock)block
{
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullExportExecutionUri:requestId]];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSExportExecutionResponse objectMappingForServerProfile:self.serverProfile] keyPath:nil];
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

    if (self.serverInfo.versionAsFloat >= kJS_SERVER_VERSION_CODE_AMBER_6_0_0) {
        executionRequest.markupType = markupType;
    }

    request.body = executionRequest;
    [self sendRequest:request];
}

- (NSString *)generateReportOutputUrl:(NSString *)requestId exportOutput:(NSString *)exportOutput {
    return [NSString stringWithFormat:@"%@/%@%@/%@/exports/%@/outputResource", self.serverProfile.serverUrl, kJS_REST_SERVICES_V2_URI, kJS_REST_REPORT_EXECUTION_URI, requestId, exportOutput];
}

- (void)reportExecutionMetadataForRequestId:(NSString *)requestId completionBlock:(JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:[self fullReportExecutionUri:requestId]];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSReportExecutionResponse objectMappingForServerProfile:self.serverProfile] keyPath:nil];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    request.shouldResendRequestAfterSessionExpiration = NO;

    [self sendRequest:request];
}

- (void)reportExecutionStatusForRequestId:(NSString *)requestId completionBlock:(JSRequestCompletionBlock)block {
    NSString *uri = [[self fullReportExecutionUri:requestId] stringByAppendingString:kJS_REST_REPORT_EXECUTION_STATUS_URI];
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSExecutionStatus objectMappingForServerProfile:self.serverProfile] keyPath:nil];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    request.shouldResendRequestAfterSessionExpiration = NO;

    [self sendRequest:request];
}

- (void)exportExecutionStatusWithExecutionID:(NSString *)executionID exportOutput:(NSString *)exportOutput completion:(JSRequestCompletionBlock)block {
    NSString *uri = [NSString stringWithFormat:@"%@/%@/exports/%@/status", kJS_REST_REPORT_EXECUTION_URI, executionID, exportOutput];
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSExecutionStatus objectMappingForServerProfile:self.serverProfile] keyPath:nil];
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
    if (!requestId.length) return kJS_REST_REPORT_EXECUTION_URI;
    return [NSString stringWithFormat:@"%@/%@", kJS_REST_REPORT_EXECUTION_URI, requestId];
}

- (NSString *)fullReportsUriForIC:(NSString *)uri withInputControls:(NSArray <NSString *> *)dependencies initialValuesOnly:(BOOL)initialValuesOnly {
    NSString *fullReportsUri = [NSString stringWithFormat:@"%@%@%@", kJS_REST_REPORTS_URI, (uri.hostEncodedString ?: @""), kJS_REST_INPUT_CONTROLS_URI];

    if (dependencies && dependencies.count) {
        NSMutableString *dependenciesUriPart = [[NSMutableString alloc] initWithString:@"/"];
        for (NSString *dependency in dependencies) {
            [dependenciesUriPart appendFormat:@"%@;", dependency.hostEncodedString];
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

- (NSString *)encodeAttachmentsPrefix:(NSString *)exportOutput {
    NSRange prefixRange = [exportOutput rangeOfString:@"attachmentsPrefix="];

    if (prefixRange.location != NSNotFound) {
        NSInteger location = prefixRange.location + prefixRange.length;
        NSRange valueRange = NSMakeRange(location, exportOutput.length - location);
        NSString *value = [exportOutput substringWithRange:valueRange];
        if (value.length) {
            exportOutput = [exportOutput stringByReplacingCharactersInRange:valueRange withString:value.queryEncodedString];
        }
    }

    return exportOutput;
}

@end

@implementation JSRESTBase (JSReport)

- (void)fetchReportComponentsWithRequestId:(nonnull NSString *)requestId
                                pageNumber:(NSInteger)pageNumber
                                completion:(nonnull JSRequestCompletionBlock)block
{
    NSString *uri = @"getReportComponents.html";
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.restVersion = JSRESTVersion_None;
    request.method = JSRequestHTTPMethodPOST;
    request.redirectAllowed = NO;
    request.responseAsObjects = NO;
    request.serializationType = JSRequestSerializationType_UrlEncoded;

    [request addParameter:@"jasperPrintName"
          withStringValue:requestId];

    NSAssert( (pageNumber - 1) >= 0, @"Request report components for wrong page." );
    [request addParameter:@"pageIndex"
         withIntegerValue:(pageNumber - 1)];

    request.completionBlock = block;

    [self sendRequest:request];
}

- (void)reportComponentForReportWithExecutionId:(nonnull NSString *)executionId
                                     pageNumber:(NSInteger)pageNumber
                                     completion:(void(^ __nonnull)(NSArray <JSReportComponent *>* __nullable , NSError * __nullable ))completion
{
    [self fetchReportComponentsWithRequestId:executionId
                                  pageNumber:(NSInteger)pageNumber
                                  completion:^(JSOperationResult *result) {
                                      NSError *error = result.error;
                                      if (error) {
                                          completion(nil, error);
                                      } else {
                                          NSError *serializeError;
                                          NSData *responseData = result.body;
                                          if (!responseData) {
                                              NSError *emptyBodyError = [NSError errorWithDomain:JSErrorDomain
                                                                                            code:JSDataMappingErrorCode
                                                                                        userInfo:@{
                                                                                                NSLocalizedDescriptionKey : @"Empty body"
                                                                                        }];
                                              completion(nil, emptyBodyError);
                                              return;
                                          }
                                          id response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&serializeError];
                                          NSMutableArray *components = [@[] mutableCopy];
                                          if ([response isKindOfClass:[NSDictionary class]]) {

                                              for (NSDictionary *compoentRepresentationKey in response) {
                                                  JSReportComponent *component = [JSReportComponent new];
                                                  [EKMapper fillObject:component
                                            fromExternalRepresentation:response[compoentRepresentationKey]
                                                           withMapping:[JSReportComponent objectMappingForServerProfile:self.serverProfile]];
                                                  switch(component.type) {
                                                      case JSReportComponentTypeUndefined: {
                                                          break;
                                                      }
                                                      case JSReportComponentTypeChart: {
                                                          JSReportComponentChartStructure *chartStructure = [JSReportComponentChartStructure new];
                                                          [EKMapper fillObject:chartStructure
                                                    fromExternalRepresentation:response[compoentRepresentationKey]
                                                                   withMapping:[JSReportComponentChartStructure objectMappingForServerProfile:self.serverProfile]];
                                                          component.structure = chartStructure;
                                                          break;
                                                      }
                                                      case JSReportComponentTypeTable: {
                                                          JSReportComponentTableStructure *talbeStructure = [JSReportComponentTableStructure new];
                                                          [EKMapper fillObject:talbeStructure
                                                    fromExternalRepresentation:response[compoentRepresentationKey]
                                                                   withMapping:[JSReportComponentTableStructure objectMappingForServerProfile:self.serverProfile]];
                                                          component.structure = talbeStructure;
                                                          break;
                                                      }
                                                      case JSReportComponentTypeColumn: {
                                                          JSReportComponentColumnStructure *columnStructure = [JSReportComponentColumnStructure new];
                                                          [EKMapper fillObject:columnStructure
                                                    fromExternalRepresentation:response[compoentRepresentationKey]
                                                                   withMapping:[JSReportComponentColumnStructure objectMappingForServerProfile:self.serverProfile]];
                                                          component.structure = columnStructure;
                                                          break;
                                                      }
                                                      case JSReportComponentTypeFusion: {
                                                          JSReportComponentFusionStructure *fusionStructure = [JSReportComponentFusionStructure new];
                                                          [EKMapper fillObject:fusionStructure
                                                    fromExternalRepresentation:response[compoentRepresentationKey]
                                                                   withMapping:[JSReportComponentFusionStructure objectMappingForServerProfile:self.serverProfile]];
                                                          component.structure = fusionStructure;
                                                          break;
                                                      }
                                                      case JSReportComponentTypeCrosstab: {
                                                          JSReportComponentCrosstabStructure *crosstabStructure = [JSReportComponentCrosstabStructure new];
                                                          [EKMapper fillObject:crosstabStructure
                                                    fromExternalRepresentation:response[compoentRepresentationKey]
                                                                   withMapping:[JSReportComponentCrosstabStructure objectMappingForServerProfile:self.serverProfile]];
                                                          component.structure = crosstabStructure;
                                                          break;
                                                      }
                                                      case JSReportComponentTypeHyperlinks: {
                                                          JSReportComponentHyperlinksStructure *hyperlinksStructure = [JSReportComponentHyperlinksStructure new];
                                                          [EKMapper fillObject:hyperlinksStructure
                                                    fromExternalRepresentation:response[compoentRepresentationKey]
                                                                   withMapping:[JSReportComponentHyperlinksStructure objectMappingForServerProfile:self.serverProfile]];
                                                          component.structure = hyperlinksStructure;
                                                          break;
                                                      }
                                                      case JSReportComponentTypeBookmarks: {
                                                          JSReportComponentBookmarksStructure *bookmarksStructure = [JSReportComponentBookmarksStructure new];
                                                          [EKMapper fillObject:bookmarksStructure
                                                    fromExternalRepresentation:response[compoentRepresentationKey]
                                                                   withMapping:[JSReportComponentBookmarksStructure objectMappingForServerProfile:self.serverProfile]];
                                                          component.structure = bookmarksStructure;
                                                          break;
                                                      }
                                                  }
                                                  [components addObject:component];
                                              }
                                              completion(components, nil);
                                          } else {
                                              completion(nil, serializeError);
                                          }
                                      }
                                  }];
}

@end