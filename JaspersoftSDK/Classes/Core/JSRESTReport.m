//
//  JSRESTReport.m
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 06.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSConstants.h"
#import "JSRequestBuilder.h"
#import "JSResourceParameter.h"
#import "JSReportDescriptor.h"
#import "JSRESTReport.h"

// JS REST prefix for report uri
static NSString * const _reportUri = @"/report";

// Report query used for setting output format (i.e PDF, HTML, etc.) 
// and path for images (current dir) when exporting report in HTML
static NSString * const _baseReportQuery = @"?IMAGES_URI=./&RUN_OUTPUT_FORMAT=";

// Shared (1-st initialized) report instance
static JSRESTReport *_sharedInstance;

@implementation JSRESTReport

+ (JSRESTReport *)sharedInstance {
    return _sharedInstance;
}

- (id)initWithProfile:(JSProfile *)profile {
    NSArray *classesForMappings = [[NSArray alloc] initWithObjects:[JSReportDescriptor class], nil];

    if ((self = [super initWithProfile:profile classesForMappings:classesForMappings]) && !_sharedInstance) {
        _sharedInstance = self;
    }
    
    return self;
}

#pragma mark -
#pragma mark Public methods for report API

- (void)runReport:(NSString *)uri reportParams:(NSDictionary *)reportParams 
           format:(NSString *)format delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullRunReportUri:uri format:format] method:JSRequestMethodPUT] 
                                  delegate:delegate] body:[self resourceDescriptorForUri:uri withReportParams:reportParams]];
    [self sendRequest:builder.request];
}

- (void)runReport:(NSString *)uri reportParams:(NSDictionary *)reportParams 
           format:(NSString *)format usingBlock:(void (^)(JSRequest *request))block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullRunReportUri:uri format:format] method:JSRequestMethodPUT] 
                                 body:[self resourceDescriptorForUri:uri withReportParams:reportParams]];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)runReport:(JSResourceDescriptor *)resourceDescriptor format:(NSString *)format
         delegate:(id<JSRequestDelegate>)delegate {
    JSRequestBuilder *builder = [[[JSRequestBuilder requestWithUri:[self fullRunReportUri:resourceDescriptor.uriString format:format] 
                                                            method:JSRequestMethodPUT] delegate:delegate] body:resourceDescriptor];
    [self sendRequest:builder.request];
}

- (void)runReport:(JSResourceDescriptor *)resourceDescriptor format:(NSString *)format 
       usingBlock:(void (^)(JSRequest *request))block {
    JSRequestBuilder *builder = [[JSRequestBuilder requestWithUri:[self fullRunReportUri:resourceDescriptor.uriString format:format] 
                                                           method:JSRequestMethodPUT] body:resourceDescriptor];
    [self sendRequest:[builder.request usingBlock:block]];
}

- (void)reportFile:(NSString *)uuid fileName:(NSString *)fileName path:(NSString *)path delegate:(id<JSRequestDelegate>)delegate {
    [self sendRequest:[self requestForUUID:uuid fileName:fileName path:path delegate:delegate usingBlock:nil]];
}

- (void)reportFile:(NSString *)uuid fileName:(NSString *)fileName path:(NSString *)path usingBlock:(void (^)(JSRequest *request))block {
    [self sendRequest:[self requestForUUID:uuid fileName:fileName path:path delegate:nil usingBlock:block]];
}

#pragma mark -
#pragma mark Private methods

- (NSString *)fullDownloadReportFileUri:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@/%@", _reportUri, uuid];
}

- (NSString *)fullRunReportUri:(NSString *)uri format:(NSString *)format {
    return [NSString stringWithFormat:@"%@%@%@%@", _reportUri, (uri ?: @""), _baseReportQuery, format];
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
    for (NSString *reportParam in reportParams.keyEnumerator) {
        id reportValue = [reportParams objectForKey:reportParams];
        
        if ([reportValue isKindOfClass:[NSArray class]]) {
            for (NSString *subReportValue in reportValue) {
                [resourceParameters addObject:[[JSResourceParameter alloc] initWithName:reportParam 
                                                                             isListItem:[constants stringFromBOOL:YES] 
                                                                                  value:subReportValue]];
            }
        } else {
            [resourceParameters addObject:[[JSResourceParameter alloc] initWithName:reportParam 
                                                                         isListItem:[constants stringFromBOOL:NO] 
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
