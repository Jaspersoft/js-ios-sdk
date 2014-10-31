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
//  JSRESTReport.m
//  Jaspersoft Corporation
//

#import "JSConstants.h"
#import "JSRequestBuilder.h"
#import "JSResourceParameter.h"
#import "JSReportDescriptor.h"
#import "JSReportExecutionRequest.h"
#import "JSReportExecutionResponse.h"
#import "JSExportExecutionRequest.h"
#import "JSExportExecutionResponse.h"
#import "JSErrorDescriptor.h"

#import "JSReportParametersList.h"
#import "JSRESTReport.h"
#import "JSInputControlOption.h"
#import <RestKit/NSString+RKAdditions.h>

#import "JSReportExecutionRequest.h"

// Report query used for setting output format (i.e PDF, HTML, etc.)
// and path for images (current dir) when exporting report in HTML
static NSString * const _baseReportQueryImagesParam = @"IMAGES_URI";
static NSString * const _baseReportQueryOutputFormatParam = @"RUN_OUTPUT_FORMAT";

// Shared (1-st initialized) report instance
static JSRESTReport *_sharedInstance;

@implementation JSRESTReport

+ (JSRESTReport *)sharedInstance {
    return _sharedInstance;
}

- (id)initWithProfile:(JSProfile *)profile {
    NSArray *classesForMappings = [[NSArray alloc] initWithObjects:[JSReportDescriptor class],
                                   [JSInputControlDescriptor class], [JSInputControlOption class], [JSInputControlState class],
                                   [JSReportExecutionRequest class], [JSReportExecutionResponse class], [JSExportExecutionRequest class], [JSExportExecutionResponse class], [JSExecutionStatus class], [JSErrorDescriptor class], nil];
    
    if ((self = [super initWithProfile:profile classesForMappings:classesForMappings]) && !_sharedInstance) {
        _sharedInstance = self;
    }
    
    return self;
}

- (id)init {
    return [self initWithProfile:nil];
}

#pragma mark -
#pragma mark Public methods for report API

- (void)runReport:(NSString *)uri reportParams:(NSDictionary *)reportParams
           format:(NSString *)format delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullRunReportUri:uri] method:JSRequestMethodPUT]
                                  delegate:delegate] body:[self resourceDescriptorForUri:uri withReportParams:reportParams]];
    [builder params:[self runReportQueryParams:format]];
    [self sendRequest:builder.request];
}

- (void)runReport:(NSString *)uri reportParams:(NSDictionary *)reportParams
           format:(NSString *)format usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullRunReportUri:uri] method:JSRequestMethodPUT]
                                 body:[self resourceDescriptorForUri:uri withReportParams:reportParams]];
    [builder params:[self runReportQueryParams:format]];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)runReport:(JSResourceDescriptor *)resourceDescriptor format:(NSString *)format
         delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullRunReportUri:resourceDescriptor.uriString]
                                                            method:JSRequestMethodPUT] delegate:delegate] body:resourceDescriptor];
    [builder params:[self runReportQueryParams:format]];
    [self sendRequest:builder.request];
}

- (void)runReport:(JSResourceDescriptor *)resourceDescriptor format:(NSString *)format
       usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullRunReportUri:resourceDescriptor.uriString]
                                                           method:JSRequestMethodPUT] body:resourceDescriptor];
    [builder params:[self runReportQueryParams:format]];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)reportFile:(NSString *)uuid fileName:(NSString *)fileName path:(NSString *)path delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullDownloadReportFileUri:uuid] method:JSRequestMethodGET] delegate:delegate];
    [[[builder params:[NSDictionary dictionaryWithObjectsAndKeys:fileName, @"file", nil]] responseAsObjects:NO] downloadDestinationPath:path];
    JSRequest *request = [self configureRequestToSaveFile:builder.request];
    [self sendRequest:request];
}

- (void)reportFile:(NSString *)uuid fileName:(NSString *)fileName path:(NSString *)path usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [JSRequestBuilder requestWithUri:[self fullDownloadReportFileUri:uuid] method:JSRequestMethodGET];
    [[[builder params:[NSDictionary dictionaryWithObjectsAndKeys:fileName, @"file", nil]] responseAsObjects:NO] downloadDestinationPath:path];
    JSRequest *request = [self configureRequestToSaveFile:[builder.request usingBlock:block]];
    [self sendRequest:request];
}

#pragma mark -
#pragma mark Public methods for REST V2 report API

- (NSString *)generateReportUrl:(JSResourceDescriptor *)resourceDescriptor page:(NSInteger)page format:(NSString *)format {
    JSConstants *constants = [JSConstants sharedInstance];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    if (page > 0) {
        [queryParams setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    }
    
    for (JSResourceParameter *parameter in resourceDescriptor.parameters) {
        if (parameter.isListItem.boolValue) {
            NSMutableArray *params = [queryParams objectForKey:parameter.name] ?: [[NSMutableArray alloc] init];
            [params addObject:parameter.value];
            [queryParams setObject:params forKey:parameter.name];
        } else {
            [queryParams setObject:parameter.value forKey:parameter.name];
        }
    }
    
    NSString *url = [[NSString stringWithFormat:@"%@%@%@%@.%@", self.serverProfile.serverUrl,
                      constants.REST_SERVICES_V2_URI, constants.REST_REPORTS_URI,
                      resourceDescriptor.uriString, format] stringByAppendingQueryParameters:queryParams];
    
    // TODO: remove code duplication...
    // Remove all [] for query params (i.e. query &PL_Country_multi_select[]=Mexico&PL_Country_multi_select[]=USA will
    // be changed to &PL_Country_multi_select=Mexico&PL_Country_multi_select=USA without any [])
    NSString *brackets = @"[]";
    if ([url rangeOfString:brackets].location != NSNotFound) {
        url = [url stringByReplacingOccurrencesOfString:brackets withString:@""];
    }
    
    return url;
}

- (NSString *)generateReportUrl:(NSString *)uri reportParams:(NSDictionary *)reportParams page:(NSInteger)page format:(NSString *)format {
    return [self generateReportUrl:[self resourceDescriptorForUri:uri withReportParams:reportParams] page:page format:format];
}

- (void)inputControlsForReport:(NSString *)reportUri delegate:(id<JSRequestDelegate>)delegate {
    [self inputControlsForReport:reportUri ids:nil selectedValues:nil delegate:delegate];
}

- (void)inputControlsForReport:(NSString *)reportUri usingBlock:(void (^)(JSRequest *))block {
    [self inputControlsForReport:reportUri ids:nil selectedValues:nil usingBlock:block];
}

- (void)inputControlsForReport:(NSString *)reportUri ids:(NSArray /*<NSString>*/ *)ids selectedValues:(NSArray /*<JSReportParameter>*/ *)selectedValues delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullReportsUriForIC:reportUri withInputControls:ids initialValuesOnly:NO] method:JSRequestMethodPOST]
    restVersion:JSRESTVersion_2] delegate:delegate];
    [self sendRequest:[builder body:[[JSReportParametersList alloc] initWithReportParameters:selectedValues]].request];
}

- (void)inputControlsForReport:(NSString *)reportUri ids:(NSArray /*<NSString>*/ *)ids selectedValues:(NSArray /*<JSReportParameter>*/ *)selectedValues usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullReportsUriForIC:reportUri withInputControls:ids initialValuesOnly:NO] method:JSRequestMethodPOST]
            restVersion:JSRESTVersion_2];
    [self sendRequest:[[builder body:[[JSReportParametersList alloc] initWithReportParameters:selectedValues]].request usingBlock:block]];
}

- (void)updatedInputControlsValues:(NSString *)reportUri ids:(NSArray *)ids selectedValues:(NSArray *)selectedValues delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullReportsUriForIC:reportUri withInputControls:ids initialValuesOnly:YES] method:JSRequestMethodPOST] delegate:delegate] restVersion:JSRESTVersion_2];
    [self sendRequest:[builder body:[[JSReportParametersList alloc] initWithReportParameters:selectedValues]].request];
}

- (void)updatedInputControlsValues:(NSString *)reportUri ids:(NSArray *)ids selectedValues:(NSArray *)selectedValues usingBlock:(void (^)(JSRequest *))block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullReportsUriForIC:reportUri withInputControls:ids initialValuesOnly:YES] method:JSRequestMethodPOST] restVersion:JSRESTVersion_2];
    [self sendRequest:[[builder body:[[JSReportParametersList alloc] initWithReportParameters:selectedValues]].request usingBlock:block]];
}

- (void)runReportExecution:(NSString *)reportUnitUri async:(BOOL)async outputFormat:(NSString *)outputFormat
               interactive:(BOOL)interactive freshData:(BOOL)freshData saveDataSnapshot:(BOOL)saveDataSnapshot
          ignorePagination:(BOOL)ignorePagination transformerKey:(NSString *)transformerKey pages:(NSString *)pages
         attachmentsPrefix:(NSString *)attachmentsPrefix parameters:(NSArray /*<JSReportParameter>*/ *)parameters delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullReportExecutionUri:nil] method:JSRequestMethodPOST] restVersion:JSRESTVersion_2] delegate:delegate];
    
    JSReportExecutionRequest *executionRequest = [[JSReportExecutionRequest alloc] init];
    executionRequest.reportUnitUri = reportUnitUri;
    executionRequest.async = [JSConstants stringFromBOOL:async];
    executionRequest.interactive = [JSConstants stringFromBOOL:interactive];
    executionRequest.freshData = [JSConstants stringFromBOOL:freshData];
    executionRequest.saveDataSnapshot = [JSConstants stringFromBOOL:saveDataSnapshot];
    executionRequest.ignorePagination = [JSConstants stringFromBOOL:ignorePagination];
    executionRequest.outputFormat = outputFormat;
    executionRequest.transformerKey = transformerKey;
    executionRequest.pages = pages;
    executionRequest.attachmentsPrefix = attachmentsPrefix;
    executionRequest.parameters = parameters;
    
    [self sendRequest:[builder body:executionRequest].request];
}

- (void)runReportExecution:(NSString *)reportUnitUri async:(BOOL)async outputFormat:(NSString *)outputFormat
               interactive:(BOOL)interactive freshData:(BOOL)freshData saveDataSnapshot:(BOOL)saveDataSnapshot
          ignorePagination:(BOOL)ignorePagination transformerKey:(NSString *)transformerKey pages:(NSString *)pages
         attachmentsPrefix:(NSString *)attachmentsPrefix parameters:(NSArray /*<JSReportParameter>*/ *)parameters usingBlock:(JSRequestConfigurationBlock)block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullReportExecutionUri:nil] method:JSRequestMethodPOST] restVersion:JSRESTVersion_2];
    
    JSReportExecutionRequest *executionRequest = [[JSReportExecutionRequest alloc] init];
    executionRequest.reportUnitUri = reportUnitUri;
    executionRequest.async = [JSConstants stringFromBOOL:async];
    executionRequest.interactive = [JSConstants stringFromBOOL:interactive];
    executionRequest.freshData = [JSConstants stringFromBOOL:freshData];
    executionRequest.saveDataSnapshot = [JSConstants stringFromBOOL:saveDataSnapshot];
    executionRequest.ignorePagination = [JSConstants stringFromBOOL:ignorePagination];
    executionRequest.outputFormat = outputFormat;
    executionRequest.transformerKey = transformerKey;
    executionRequest.pages = pages;
    executionRequest.attachmentsPrefix = attachmentsPrefix;
    executionRequest.parameters = parameters;
    
    [self sendRequest:[[builder body:executionRequest].request usingBlock:block]];
}

- (void)runExportExecution:(NSString *)requestId outputFormat:(NSString *)outputFormat pages:(NSString *)pages
        allowInlineScripts:(BOOL)allowInlineScripts attachmentsPrefix:(NSString *)attachmentsPrefix delegate:(id<JSRequestDelegate>)delegate{
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullExportExecutionUri:requestId] method:JSRequestMethodPOST] restVersion:JSRESTVersion_2] delegate:delegate];
    
    JSExportExecutionRequest *executionRequest = [[JSExportExecutionRequest alloc] init];
    executionRequest.outputFormat = outputFormat;
    executionRequest.pages = pages;
    if (self.serverInfo.versionAsFloat >= [JSConstants sharedInstance].SERVER_VERSION_CODE_EMERALD_5_6_0) {
        executionRequest.baseUrl = self.serverProfile.serverUrl;
        if (attachmentsPrefix) {
            JSConstants *constants = [JSConstants sharedInstance];
            executionRequest.attachmentsPrefix = [NSString stringWithFormat:@"%@%@%@", self.serverProfile.serverUrl, constants.REST_SERVICES_V2_URI, attachmentsPrefix];
        }
    }
    executionRequest.allowInlineScripts = [JSConstants stringFromBOOL:allowInlineScripts];
    [self sendRequest:[builder body:executionRequest].request];
}

- (void)runExportExecution:(NSString *)requestId outputFormat:(NSString *)outputFormat pages:(NSString *)pages
        allowInlineScripts:(BOOL)allowInlineScripts attachmentsPrefix:(NSString *)attachmentsPrefix usingBlock:(JSRequestConfigurationBlock)block {
    
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullExportExecutionUri:requestId] method:JSRequestMethodPOST] restVersion:JSRESTVersion_2];
    
    JSExportExecutionRequest *executionRequest = [[JSExportExecutionRequest alloc] init];
    executionRequest.outputFormat = outputFormat;
    executionRequest.pages = pages;
    if (self.serverInfo.versionAsFloat >= [JSConstants sharedInstance].SERVER_VERSION_CODE_EMERALD_5_6_0) {
        executionRequest.baseUrl = self.serverProfile.serverUrl;
        if (attachmentsPrefix) {
            JSConstants *constants = [JSConstants sharedInstance];
            executionRequest.attachmentsPrefix = [NSString stringWithFormat:@"%@%@%@", self.serverProfile.serverUrl, constants.REST_SERVICES_V2_URI, attachmentsPrefix];
        }
    }
    executionRequest.baseUrl = self.serverProfile.serverUrl;
    [self sendRequest:[[builder body:executionRequest].request usingBlock:block]];
}

- (NSString *)generateReportOutputUrl:(NSString *)requestId exportOutput:(NSString *)exportOutput {
    JSConstants *constants = [JSConstants sharedInstance];
    return [NSString stringWithFormat:@"%@%@%@/%@/exports/%@/outputResource", self.serverProfile.serverUrl, constants.REST_SERVICES_V2_URI, constants.REST_REPORT_EXECUTION_URI, requestId, exportOutput];
}

- (void)getReportExecutionMetadata:(NSString *)requestId delegate:(id<JSRequestDelegate>)delegate {
    NSString *uri = [self fullReportExecutionUri:requestId];
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:uri method:JSRequestMethodGET] restVersion:JSRESTVersion_2] delegate:delegate];
    [self sendRequest:builder.request];
}

- (void)getReportExecutionMetadata:(NSString *)requestId usingBlock:(JSRequestConfigurationBlock)block {
    NSString *uri = [self fullReportExecutionUri:requestId];
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:uri method:JSRequestMethodGET] restVersion:JSRESTVersion_2];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)getReportExecutionStatus:(NSString *)requestId delegate:(id<JSRequestDelegate>)delegate {
    NSString *uri = [NSString stringWithFormat:@"%@/status", [self fullReportExecutionUri:requestId]];
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:uri method:JSRequestMethodGET] restVersion:JSRESTVersion_2] delegate:delegate];
    [self sendRequest:builder.request];
}

- (void)getReportExecutionStatus:(NSString *)requestId usingBlock:(JSRequestConfigurationBlock)block {
    NSString *uri = [NSString stringWithFormat:@"%@/status", [self fullReportExecutionUri:requestId]];
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:uri method:JSRequestMethodGET] restVersion:JSRESTVersion_2];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)loadReportOutput:(NSString *)requestId exportOutput:(NSString *)exportOutput
           loadForSaving:(BOOL)loadForSaving path:(NSString *)path delegate:(id<JSRequestDelegate>)delegate {
    exportOutput = [self encodeAttachmentsPrefix:exportOutput];
    NSString *uri = [NSString stringWithFormat:@"%@/%@/exports/%@/outputResource", [JSConstants sharedInstance].REST_REPORT_EXECUTION_URI, requestId, exportOutput];
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:uri method:JSRequestMethodGET] restVersion:JSRESTVersion_2] delegate:delegate];
    JSRequest *request = nil;
    if (loadForSaving) {
        [[builder downloadDestinationPath:path] responseAsObjects:NO];
        request = [self configureRequestToSaveFile:builder.request];
    } else {
        request = builder.request;
    }
    [self sendRequest:request];
}

- (void)loadReportOutput:(NSString *)requestId exportOutput:(NSString *)exportOutput
           loadForSaving:(BOOL)loadForSaving path:(NSString *)path usingBlock:(JSRequestConfigurationBlock)block {
    exportOutput = [self encodeAttachmentsPrefix:exportOutput];
    NSString *uri = [NSString stringWithFormat:@"%@/%@/exports/%@/outputResource", [JSConstants sharedInstance].REST_REPORT_EXECUTION_URI, requestId, exportOutput];
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:uri method:JSRequestMethodGET] restVersion:JSRESTVersion_2];
    JSRequest *request = nil;
    if (loadForSaving) {
        [[builder downloadDestinationPath:path] responseAsObjects:NO];
        request = [self configureRequestToSaveFile:builder.request];
    } else {
        request = builder.request;
    }
    [self sendRequest:[request usingBlock:block]];
}

- (void)saveReportAttachment:(NSString *)requestId exportOutput:(NSString *)exportOutput attachmentName:(NSString *)attachmentName path:(NSString *)path delegate:(id<JSRequestDelegate>)delegate {
    exportOutput = [self encodeAttachmentsPrefix:exportOutput];
    NSString *uri = [NSString stringWithFormat:@"%@/%@/exports/%@/attachments/%@", [JSConstants sharedInstance].REST_REPORT_EXECUTION_URI, requestId, exportOutput, attachmentName];
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:uri method:JSRequestMethodGET] restVersion:JSRESTVersion_2];
    [[[builder downloadDestinationPath:path] responseAsObjects:NO] delegate:delegate];
    JSRequest *request = [self configureRequestToSaveFile:builder.request];
    [self sendRequest:request];
}

- (void)saveReportAttachment:(NSString *)requestId exportOutput:(NSString *)exportOutput attachmentName:(NSString *)attachmentName path:(NSString *)path usingBlock:(JSRequestConfigurationBlock)block {
    exportOutput = [self encodeAttachmentsPrefix:exportOutput];
    NSString *uri = [NSString stringWithFormat:@"%@/%@/exports/%@/attachments/%@", [JSConstants sharedInstance].REST_REPORT_EXECUTION_URI, requestId, exportOutput, attachmentName];
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:uri method:JSRequestMethodGET] restVersion:JSRESTVersion_2];
    [[builder downloadDestinationPath:path] responseAsObjects:NO];
    JSRequest *request = [self configureRequestToSaveFile:builder.request];
    [self sendRequest:request];
}

#pragma mark -
#pragma mark Private methods

- (NSString *)fullReportExecutionUri:(NSString *)requestId {
    NSString *reportExecutionUri = [JSConstants sharedInstance].REST_REPORT_EXECUTION_URI;
    
    if (!requestId.length) return reportExecutionUri;
    return [NSString stringWithFormat:@"%@/%@", reportExecutionUri, requestId];
}

- (NSString *)fullDownloadReportFileUri:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@/%@", [JSConstants sharedInstance].REST_REPORT_URI, uuid];
}

- (NSString *)fullRunReportUri:(NSString *)uri {
    return [NSString stringWithFormat:@"%@%@", [JSConstants sharedInstance].REST_REPORT_URI, (uri ?: @"")];
}

- (NSString *)fullReportsUriForIC:(NSString *)uri withInputControls:(NSArray *)dependencies initialValuesOnly:(BOOL)initialValuesOnly {
    JSConstants *constants = [JSConstants sharedInstance];
    NSString *fullReportsUri = [NSString stringWithFormat:@"%@%@%@", constants.REST_REPORTS_URI, (uri ?: @""), constants.REST_INPUT_CONTROLS_URI];
    
    if (dependencies && dependencies.count) {
        NSMutableString *dependenciesUriPart = [[NSMutableString alloc] initWithString:@"/"];
        for (NSString *dependency in dependencies) {
            [dependenciesUriPart appendFormat:@"%@;", dependency];
        }
        fullReportsUri = [fullReportsUri stringByAppendingString:dependenciesUriPart];
    }

    if (initialValuesOnly) {
        fullReportsUri = [fullReportsUri stringByAppendingString:constants.REST_VALUES_URI];
    }
    
    return fullReportsUri;
}

- (NSString *)fullExportExecutionUri:(NSString *)requestId {
    return [NSString stringWithFormat:@"%@/%@%@", [JSConstants sharedInstance].REST_REPORT_EXECUTION_URI, requestId, [JSConstants sharedInstance].REST_EXPORT_EXECUTION_URI];
}

- (NSDictionary *)runReportQueryParams:(NSString *)format {
    return [NSDictionary dictionaryWithObjectsAndKeys:@"./", _baseReportQueryImagesParam,
            format, _baseReportQueryOutputFormatParam, nil];
}

// Creates resource descriptor with report parameters (retrieved from IC)
- (JSResourceDescriptor *)resourceDescriptorForUri:(NSString *)uri withReportParams:(NSDictionary *)reportParams {
    JSConstants *constants = [JSConstants sharedInstance];
    
    // Base configuration for resource descriptor
    JSResourceDescriptor *resourceDescriptor = [[JSResourceDescriptor alloc] init];
    resourceDescriptor.name = @"";
    resourceDescriptor.uriString = uri;
    resourceDescriptor.wsType = constants.WS_TYPE_REPORT_UNIT;
    
    // Return resource descriptor if no any other params was provided
    if (!reportParams.count) {
        return resourceDescriptor;
    }
    
    // Create JSResourceParameters from report params
    NSMutableArray *resourceParameters = [[NSMutableArray alloc] init];
    
    for (id reportParam in reportParams.keyEnumerator) {
        id reportValue = [reportParams objectForKey:reportParam];
        
        if ([reportValue isKindOfClass:[NSArray class]]) {
            for (NSString *subReportValue in reportValue) {
                [resourceParameters addObject:[[JSResourceParameter alloc] initWithName:reportParam
                                                                             isListItem:[constants.class stringFromBOOL:YES]
                                                                                  value:subReportValue]];
            }
        } else if([reportValue isKindOfClass:[NSDate class]]) {
            NSString *intervalAsString = [NSString stringWithFormat:@"%lld", [NSNumber numberWithDouble:[reportValue timeIntervalSince1970] * 1000.0f].longLongValue];
            [resourceParameters addObject:[[JSResourceParameter alloc] initWithName:reportParam
                                                                         isListItem:[constants.class stringFromBOOL:NO]
                                                                              value:intervalAsString]];
        } else {
            [resourceParameters addObject:[[JSResourceParameter alloc] initWithName:reportParam
                                                                         isListItem:[constants.class stringFromBOOL:NO]
                                                                              value:reportValue]];
        }
    }
    
    // Parameters for resource descriptor uses by JSXMLSerializer to create proper XML for sending
    resourceDescriptor.parameters = resourceParameters;
    
    return resourceDescriptor;
}

- (JSRequest *)configureRequestToSaveFile:(JSRequest *)request {
    __weak id <JSRequestDelegate> delegate = request.delegate;
    __weak JSRequestFinishedBlock finishedBlock = request.finishedBlock;
    
    // Set delegate in request to nil to avoid 2 delegate invocations
    request.delegate = nil;
    
    // Set save finishedBlock
    request.finishedBlock = ^(JSOperationResult *result) {
        // Write receive file to specified directory path
        if (!result.error) {
            [result.body writeToFile:result.downloadDestinationPath atomically:YES];
        }
        
        if (delegate) {
            [delegate requestFinished:result];
        }
        
        if (finishedBlock) {
            // Call original finishedBlock
            finishedBlock(result);
        }
    };
    
    return request;
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
