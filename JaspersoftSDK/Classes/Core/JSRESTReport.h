//
//  JSRESTReport.h
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 06.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSRESTBase.h"
#import "JSResourceDescriptor.h"
#import "JSReportDescriptor.h"
#import <Foundation/Foundation.h>

/**
 Provides wrapper methods for <code>JSRESTBase</code> to interact with the 
 <b>report</b> JasperReports server REST API. This object puts at disposal a set 
 of methods for running reports and downloading report files (all sending methods 
 are asynchronous and use base sendRequest method from <code>JSRESTBase</code> class).
 
 Contains two types of methods which differs by last parameter: first type uses 
 delegate and puts request result into it, second type uses pre-configuration 
 block for setting additional parameters of JSRequest object. Pre-configuration 
 block implicitly supports finishedBlock usage instead delegate object (or use
 them both), setting custom timeoutInterval, custom query parameters, 
 requestBackgroundPolicy etc.
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.3
 */
@interface JSRESTReport : JSRESTBase

/**
 Returns the shared instance of the report
 */
+ (JSRESTReport *)sharedInstance;

/** 
 Returns a rest report instance with provided server profile (for authentication) 
 and proper classes mapping rules for <b>report</b> JasperReports server REST API
 
 @param profile The profile contains server connection details
 @return A fully configured JSRESTReport instance include mapping rules
 */
- (id)initWithProfile:(JSProfile *)profile;

/**
 Runs the report and generates the specified output. The response contains report descriptor
 with the ID of the saved output for downloading later with a GET request.
 
 @param uri The resource descriptor uri
 @param reportParams An input control params uses to generate report with different data
 @param format The format of the report output. Possible values: PDF, HTML, XLS, RTF, CSV,
 XML, JRPRINT
 
 **Default**: PDF
 @param delegate A delegate object to inform of the results
 */
- (void)runReport:(NSString *)uri reportParams:(NSDictionary *)reportParams format:(NSString *)format delegate:(id<JSRequestDelegate>)delegate;

/**
 Runs the report and generates the specified output. The response contains report descriptor
 with the ID of the saved output for downloading later with a GET request.
 
 @param uri The resource descriptor uri
 @param reportParams An input control params uses to generate report with different data
 @param format The format of the report output. Possible values: PDF, HTML, XLS, RTF, CSV,
 XML, JRPRINT
 
 **Default**: PDF
 @param block The block to execute with the request before sending it for processing
 */
- (void)runReport:(NSString *)uri reportParams:(NSDictionary *)reportParams format:(NSString *)format usingBlock:(void (^)(JSRequest *request))block;

/**
 Runs the report and generates the specified output. The response contains report descriptor
 with the ID of the saved output for downloading later with a GET request.
 
 @param resourceDescriptor The resource descriptor of this report
 @param format The format of the report output. Possible values: PDF, HTML, XLS, RTF, CSV,
 XML, JRPRINT
 
 **Default**: PDF
 @param delegate A delegate object to inform of the results
 */
- (void)runReport:(JSResourceDescriptor *)resourceDescriptor format:(NSString *)format delegate:(id<JSRequestDelegate>)delegate;

/**
 Runs the report and generates the specified output. The response contains report descriptor
 with the ID of the saved output for downloading later with a GET request.
 
 @param resourceDescriptor The resource descriptor of this report
 @param format The format of the report output. Possible values: PDF, HTML, XLS, RTF, CSV,
 XML, JRPRINT
 
 **Default**: PDF
 @param block The block to execute with the request before sending it for processing
 */
- (void)runReport:(JSResourceDescriptor *)resourceDescriptor format:(NSString *)format usingBlock:(void (^)(JSRequest *request))block;

/**
 Downloads specified report file, once a report has been generated, and saves it
 to specified path (path should also inlude name of the file)
 
 @param uuid The Universally Unique Identifier. As a side effect of storing the report 
 output in the user session, the UUID in the URI is visible only to the currently 
 logged in user
 @param fileName One of the file names specified in the report xml
 @param path The path where generated report will be saved
 @param delegate A delegate object to inform of the results
 */
- (void)reportFile:(NSString *)uuid fileName:(NSString *)fileName path:(NSString *)path delegate:(id<JSRequestDelegate>)delegate;

/**
 Downloads specified report file, once a report has been generated, and saves it
 to specified path (path should also inlude name of the file)
 
 @param uuid The Universally Unique Identifier. As a side effect of storing the report 
 output in the user session, the UUID in the URI is visible only to the currently 
 logged in user
 @param fileName One of the file names specified in the report xml
 @param path The path where generated report will be saved
 @param block The block to execute with the request before sending it for processing
 */
- (void)reportFile:(NSString *)uuid fileName:(NSString *)fileName path:(NSString *)path usingBlock:(void (^)(JSRequest *request))block;

@end
