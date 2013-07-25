//
//  JSRESTReport.m
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 06.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSConstants.h"
#import "JSRequestBuilder.h"
#import "JSResourceParameter.h"
#import "JSReportDescriptor.h"
#import "JSReportParameter.h"
#import "JSReportParametersList.h"
#import "JSRESTReport.h"
#import "JSInputControlDescriptor.h"
#import "JSInputControlOption.h"
#import "JSInputControlState.h"
#import <RestKit/NSString+RKAdditions.h>

// Report query used for setting output format (i.e PDF, HTML, etc.)
// and path for images (current dir) when exporting report in HTML
static NSString * const _baseReportQuery = @"?IMAGES_URI=./&RUN_OUTPUT_FORMAT=";

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
                                   [JSInputControlDescriptor class], [JSInputControlOption class], [JSInputControlState class], nil];
    
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
           format:(NSString *)format usingBlock:(void (^)(JSRequest *request))block {
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
       usingBlock:(void (^)(JSRequest *request))block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullRunReportUri:resourceDescriptor.uriString]
                                                           method:JSRequestMethodPUT] body:resourceDescriptor];
    [builder params:[self runReportQueryParams:format]];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)reportFile:(NSString *)uuid fileName:(NSString *)fileName path:(NSString *)path delegate:(id<JSRequestDelegate>)delegate {
    [self sendRequest:[self requestForUUID:uuid fileName:fileName path:path delegate:delegate usingBlock:nil]];
}

- (void)reportFile:(NSString *)uuid fileName:(NSString *)fileName path:(NSString *)path usingBlock:(void (^)(JSRequest *request))block {
    [self sendRequest:[self requestForUUID:uuid fileName:fileName path:path delegate:nil usingBlock:block]];
}

#pragma mark -
#pragma mark Public methods for REST V2 report API

- (NSString *)generateReportUrl:(JSResourceDescriptor *)resourceDescriptor page:(NSInteger)page format:(NSString *)format {
    JSConstants *constants = [JSConstants sharedInstance];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    if (page > 0) {
        [queryParams setObject:[NSNumber numberWithInt:page] forKey:@"page"];
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
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullReportsUriForIC:reportUri includingDependencies:nil] method:JSRequestMethodGET]
                                  restVersion:JSRESTVersion_2] delegate:delegate];
    [self sendRequest:builder.request];
}

- (void)inputControlsForReport:(NSString *)reportUri usingBlock:(void (^)(JSRequest *))block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullReportsUriForIC:reportUri includingDependencies:nil] method:JSRequestMethodGET]
                                 restVersion:JSRESTVersion_2];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)updatedInputControlsValues:(NSString *)reportUri ids:(NSArray *)ids selectedValues:(NSArray *)selectedValues delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullReportsUriForIC:reportUri includingDependencies:ids] method:JSRequestMethodPOST] delegate:delegate] restVersion:JSRESTVersion_2];
    [self sendRequest:[builder body:[[JSReportParametersList alloc] initWithReportParameters:selectedValues]].request];
}

- (void)updatedInputControlsValues:(NSString *)reportUri ids:(NSArray *)ids selectedValues:(NSArray *)selectedValues usingBlock:(void (^)(JSRequest *))block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullReportsUriForIC:reportUri includingDependencies:ids] method:JSRequestMethodPOST] restVersion:JSRESTVersion_2];
    [self sendRequest:[[builder body:[[JSReportParametersList alloc] initWithReportParameters:selectedValues]].request usingBlock:block]];
}

#pragma mark -
#pragma mark Private methods

- (NSString *)fullDownloadReportFileUri:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@/%@", [JSConstants sharedInstance].REST_REPORT_URI, uuid];
}

- (NSString *)fullRunReportUri:(NSString *)uri {
    return [NSString stringWithFormat:@"%@%@", [JSConstants sharedInstance].REST_REPORT_URI, (uri ?: @"")];
}

- (NSString *)fullReportsUriForIC:(NSString *)uri includingDependencies:(NSArray *)dependencies {
    JSConstants *constants = [JSConstants sharedInstance];
    NSString *fullReportsUri = [NSString stringWithFormat:@"%@%@%@", constants.REST_REPORTS_URI, (uri ?: @""), constants.REST_INPUT_CONTROLS_URI];
    
    if (dependencies && dependencies.count) {
        NSMutableString *dependenciesUriPart = [[NSMutableString alloc] initWithString:@"/"];
        for (NSString *dependency in dependencies) {
            [dependenciesUriPart appendFormat:@"%@;", dependency];
        }
        fullReportsUri = [fullReportsUri stringByAppendingFormat:@"%@%@", dependenciesUriPart, constants.REST_VALUES_URI];
    }
    
    return fullReportsUri;
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
    
    // Return resource descriptor if no any other params was provideds
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

// Creates request and configures request for downloading files including save files to path
- (JSRequest *)requestForUUID:(NSString *)uuid fileName:(NSString *)fileName path:(NSString *)path
                     delegate:(id<JSRequestDelegate>)delegate usingBlock:(void (^)(JSRequest *request))block {
    JSRequestBuilder *builder = [JSRequestBuilder requestWithUri:[self fullDownloadReportFileUri:uuid] method:JSRequestMethodGET];
    [[builder params:[NSDictionary dictionaryWithObjectsAndKeys:fileName, @"file", nil]] responseAsObjects:NO];
    [builder downloadDestinationPath:path];
    
    JSRequest *request = block ? [builder.request usingBlock:block] : builder.request;
    
    // Store finished block passed from client to request (via "usingBlock:" method)
    JSRequestFinishedBlock clientFinishedBlock = request.finishedBlock;
    
    // After sending request and getting RestKit's response this block will be called
    // before delegate or clientFinishedBlock (if it was provided)
    request.finishedBlock = ^(JSOperationResult *result) {
        // Write receive file to specified directory path
        if (!result.error) {
            [result.body writeToFile:path atomically:YES];
        }
        
        if (clientFinishedBlock) {
            clientFinishedBlock(result);
        }
        
        if (delegate) {
            [delegate requestFinished:result];
        }
    };
    
    return request;
}

@end
