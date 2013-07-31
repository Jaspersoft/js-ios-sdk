/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2013 Jaspersoft Corporation. All rights reserved.
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
//  JSRESTReport.h
//  Jaspersoft Corporation
//

#import "JSRESTBase.h"
#import "JSResourceDescriptor.h"
#import "JSReportDescriptor.h"
#import "JSInputControlDescriptor.h"
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

//---------------------------------------------------------------------
// The Report Service v2
//---------------------------------------------------------------------

/**
 Generates the report url according to specified parameters. The new v2/reports
 service allows clients to receive report output in a single request-response
 using this url.
 
 @param resourceDescriptor resource descriptor of this report with included list of
 report parameter/input control values (setted list of JSResourceParameter inside descriptor)
 @param page a positive integer value used to output a specific page or 0 to output all pages
 @param format the format of the report output. Possible values: PDF, HTML, XLS, RTF, CSV, XML.
 @return the report url
 
 @since 1.4
 */
- (NSString *)generateReportUrl:(JSResourceDescriptor *)resourceDescriptor page:(NSInteger)page format:(NSString *)format;

/**
 Generates the report url to receive all pages report output in HTML format.
 
 @param resourceDescriptor resource descriptor of this report
 @param parameters list of report parameter/input control values
 @return the report url
 
 @since 1.4
 */
- (NSString *)generateReportUrl:(NSString *)uri reportParams:(NSDictionary *)reportParams page:(NSInteger)page format:(NSString *)format;

/**
 Gets the list of input controls for the report with specified URI
 
 @param reportUri repository URI of the report
 @param delegate A delegate object to inform of the results
 
 @since 1.4
 */
- (void)inputControlsForReport:(NSString *)reportUri delegate:(id<JSRequestDelegate>)delegate;

/**
 Gets the list of input controls for the report with specified URI
 
 @param reportUri repository URI of the report
 @param block The block to execute with the request before sending it for processing
 
 @since 1.4
 */
- (void)inputControlsForReport:(NSString *)reportUri usingBlock:(void (^)(JSRequest *request))block;

/**
 Gets the states with updated values for input controls with specified IDs and according to specified parameters
 
 @param reportUri repository URI of the report
 @param ids list of input controls IDs
 @param selectedValues list of input controls selected values
 @param delegate A delegate object to inform of the results
 
 @since 1.4
 */
- (void)updatedInputControlsValues:(NSString *)reportUri ids:(NSArray /*<NSString>*/ *)ids
                    selectedValues:(NSArray /*<JSReportParameter>*/ *)selectedValues delegate:(id<JSRequestDelegate>)delegate;

/**
 Gets the states with updated values for input controls with specified IDs and according to specified parameters
 
 @param reportUri repository URI of the report
 @param ids list of input controls IDs
 @param selectedValues list of input controls selected values
 @param block The block to execute with the request before sending it for processing
 
 @since 1.4
 */
- (void)updatedInputControlsValues:(NSString *)reportUri ids:(NSArray /*<NSString>*/ *)ids
                    selectedValues:(NSArray /*<JSReportParameter>*/ *)selectedValues usingBlock:(void (^)(JSRequest *request))block;

@end
