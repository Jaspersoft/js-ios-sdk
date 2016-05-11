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
//  JSRESTBase+JSRESTReport.h
//  Jaspersoft Corporation
//

#import "JSRESTBase.h"
#import "JSInputControlDescriptor.h"
#import "JSReportOption.h"
#import "JSReportParameter.h"

@class JSReportComponent;

/**
 Extentions to <code>JSRESTBase</code> class for working with reports by REST calls.
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Alexey Gubarev ogubarie@tibco.com
 @since 1.3
 */

@interface JSRESTBase (JSRESTReportOptions)

/**
 Gets the list of states of input controls with specified IDs for the report with specified URI and according to selected values
 
 @param reportUri repository URI of the report
 @param selectedValues list of input controls selected values
 @param block The block to inform of the results
 
 @since 1.6
 */
- (void)inputControlsForReport:(nonnull NSString *)reportUri selectedValues:(nullable NSArray <JSReportParameter *> *)selectedValues
               completionBlock:(nullable JSRequestCompletionBlock)block;

/**
 Gets the states with updated values for input controls with specified IDs and according to selected values
 
 @param reportUri repository URI of the report
 @param ids list of input controls IDs
 @param selectedValues list of input controls selected values
 @param block The block to inform of the results
 
 @since 1.4
 */
- (void)updatedInputControlsValues:(nonnull NSString *)reportUri ids:(nonnull NSArray <NSString *> *)ids
                    selectedValues:(nonnull NSArray <JSReportParameter *> *)selectedValues completionBlock:(nullable JSRequestCompletionBlock)block;


/**
 Gets the report options array for report
 
 @param reportUri repository URI of the report
 @param block The block to inform of the results
 
 @since 2.2
 */
- (void)reportOptionsForReportURI:(nonnull NSString *)reportURI completion:(nullable JSRequestCompletionBlock)block;

/**
 Delete existed report option
 
 @param reportOption the report option for deleting
 @param reportUri repository URI of the report
 @param block The block to inform of the results
 
 @since 2.2
 */

- (void)deleteReportOption:(nonnull JSReportOption *)reportOption withReportURI:(nonnull NSString *)reportURI completion:(nullable JSRequestCompletionBlock)completion;

/**
 Create new report option
 
 @param reportUri repository URI of the report
 @param optionLabel the name for new report option
 @param reportParameters parameters for new report option creating
 @param block The block to inform of the results
 
 @since 2.2
 */

- (void)createReportOptionWithReportURI:(nonnull NSString *)reportURI optionLabel:(nonnull NSString *)optionLabel reportParameters:(nonnull NSArray <JSReportParameter *> *)reportParameters completion:(nullable JSRequestCompletionBlock)completion;

@end

@interface JSRESTBase (JSRESTReportExecution)

/**
 Generates the report url to receive all pages report output in selected format.
 
 @param uri The resource descriptor uri
 @param reportParams list of report parameter/input control values
 @param page a positive integer value used to output a specific page or 0 to output all pages
 @param format the format of the report output. Possible values: PDF, HTML, XLS, RTF, CSV, XML.
 @return the report url
 
 @since 1.4
 */
- (nonnull NSString *)generateReportUrl:(nonnull NSString *)uri reportParams:(nullable NSArray <JSReportParameter *> *)reportParams page:(NSInteger)page format:(nonnull NSString *)format;

/**
 Executes report
 
 @param reportUnitUri URI of the report to run
 @param async If false, then response is send, when report generation/export is complete, else, response is send immediately, without waiting for completeness
 @param outputFormat Report output format (e.g. html, pdf etc.)
 @param interactive If true, then highcharts are present, then they are generated using JavaScript, else image with chart is generated
 @param freshData Used to specify whether the report should use a previously saved data snapshot (if any) or fetch fresh data from the data source.  By default, if a saved data snapshot exists for the report it will be used when running the report
 @param saveDataSnapshot Used to instruct JRS to fetch fresh data for the report and save it as a data snapshot.  Note that data snapshot persistence must be enabled on the JRS instance in order for this parameter to be effective
 @param ignorePagination If true, then single long page is generated
 @param transformerKey Used when requesting a report as a JasperPrint object.  The parameter allows JRS web services to leverage JR generic print element transformers (net.sf.jasperreports.engine.export.GenericElementTransformer).  Such transformers are pluggable as JR extensions
 @param pages Single page number of pages range in a format "{startPageNumber}-{endPageNumber}"
 @param attachmentsPrefix URL prefix for report attachments. This parameter matter for HTML output only. Placeholders {contextPath}, {reportExecutionId} and {exportOptions} can be used. They are replaced in runtime by corresponding values
 @param parameters List of input control parameters
 @param block The block to inform of the results
 
 @since 1.8
 */
- (void)runReportExecution:(nonnull NSString *)reportUnitUri
                     async:(BOOL)async
              outputFormat:(nonnull NSString *)outputFormat
               interactive:(BOOL)interactive
                 freshData:(BOOL)freshData
          saveDataSnapshot:(BOOL)saveDataSnapshot
          ignorePagination:(BOOL)ignorePagination
            transformerKey:(nullable NSString *)transformerKey
                     pages:(nullable NSString *)pages
         attachmentsPrefix:(nullable NSString *)attachmentsPrefix
                parameters:(nullable NSArray <JSReportParameter *> *)parameters
           completionBlock:(nullable JSRequestCompletionBlock)block;

/**
 Executes report with new parameter - 'markupType'

 @since 2.5
 */

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
           completionBlock:(nullable JSRequestCompletionBlock)block;

/**
 Cancel Report Execution
 
 @param requestId A <b>requestId</b> parameter of the report execution response
 @param block The block to inform of the results
 
 @since 1.9
 */
- (void)cancelReportExecution:(nonnull NSString *)requestId completionBlock:(nullable JSRequestCompletionBlock)block;

/**
 Run Export Execution
 
 @param requestId A <b>requestId</b> parameter of the report execution response
 @param outputFormat Report output format (e.g. html, pdf etc.)
 @param pages Single page number of pages range in a format "{startPageNumber}-{endPageNumber}"
 @param attachmentsPrefix URL prefix for report attachments. This parameter matter for HTML output only. Placeholders {contextPath}, {reportExecutionId} and {exportOptions} can be used. They are replaced in runtime by corresponding values
 @param block The block to inform of the results
 
 @since 1.9
 */
- (void)runExportExecution:(nonnull NSString *)requestId
              outputFormat:(nonnull NSString *)outputFormat
                     pages:(nullable NSString *)pages
         attachmentsPrefix:(nullable NSString *)attachmentsPrefix
           completionBlock:(nullable JSRequestCompletionBlock)block;

/**
 Run Export Execution with new parameter - 'markupType'

 @since 2.5
 */

- (void)runExportExecution:(nonnull NSString *)requestId
              outputFormat:(nonnull NSString *)outputFormat
                     pages:(nullable NSString *)pages
                markupType:(JSMarkupType)markupType
         attachmentsPrefix:(nullable NSString *)attachmentsPrefix
           completionBlock:(nullable JSRequestCompletionBlock)block;


/**
 Generates the report output url

 @param requestId A <b>requestId</b> parameter of the report execution response
 @param exportOutput Export parameters as string in the correct format: {reportFormat};pages={pageOrPagesRange};attachmentsPrefix={attachmentsPrefixUrlEncodedValue}
 @return A generated report output url

 @since 1.8
*/
- (nonnull NSString *)generateReportOutputUrl:(nonnull NSString *)requestId exportOutput:(nonnull NSString *)exportOutput;

/**
 Gets report execution metadata by request id
 
 @param requestId A <b>requestId</b> parameter of the report execution response
 @param block The block to inform of the results
 
 @since 1.8
 */
- (void)reportExecutionMetadataForRequestId:(nonnull NSString *)requestId completionBlock:(nullable JSRequestCompletionBlock)block;

/**
 Gets report execution status by request id
 
 @param requestId A <b>requestId</b> parameter of the report execution response
 @param block The block to inform of the results
 
 @since 1.8
 */
- (void)reportExecutionStatusForRequestId:(nonnull NSString *)requestId completionBlock:(nullable JSRequestCompletionBlock)block;

/**
 Gets report export status by execution id and export output id.
 @param executionID A <b>executionID</b> parameter of the report execution response
 @param exportOutput A <b>exportOutput</b> parameter of the report execution response
 @param block The block to inform of the results

 @since 2.1
*/
- (void)exportExecutionStatusWithExecutionID:(nonnull NSString *)executionID
                                exportOutput:(nonnull NSString *)exportOutput
                                  completion:(nullable JSRequestCompletionBlock)block;

/**
 Loads report output and saves it by specified path if needed

 @param requestId A <b>requestId</b> parameter of the report execution response
 @param exportOutput Export parameters as string:
    - for JRS version smaller 5.6.0 it should be in the follow format: {reportFormat};pages={pageOrPagesRange};attachmentsPrefix={attachmentsPrefixUrlEncodedValue};
    - for JRS version 5.6.0 and greater it should be GUID string; @param loadForSaving If TRUE, report output will be saved by path
 @param loadForSaving If TRUE, report output will be saved by path
 @param path The path where the report output will be saved. Ignored, if loadForSaving is FALSE.
 @param block The block to inform of the results

 @since 1.9
 */
- (void)loadReportOutput:(nonnull NSString *)requestId exportOutput:(nonnull NSString *)exportOutput
           loadForSaving:(BOOL)loadForSaving path:(nullable NSString *)path completionBlock:(nullable JSRequestCompletionBlock)block;


/**
 Downloads report attachment and saves it by specified path
 
 @param requestId A <b>requestId</b> parameter of the report execution response
 @param exportOutput Export parameters as string in the correct format: {reportFormat};pages={pageOrPagesRange};attachmentsPrefix={attachmentsPrefixUrlEncodedValue}
 @param attachmentName A name of report attachment
 @param path The path where the report output will be saved
 @param block The block to inform of the results
 
 @since 1.8
 */
- (void)saveReportAttachment:(nonnull NSString *)requestId exportOutput:(nonnull NSString *)exportOutput attachmentName:(nonnull NSString *)attachmentName path:(nonnull NSString *)path completionBlock:(nullable JSRequestCompletionBlock)block;

@end



@interface JSRESTBase (JSReport)

/**
 Get report components

 @param requestId A <b>requestId</b> parameter of the report execution response
 @param block The block to inform of the results

 @since 2.5
 */
- (void)fetchReportComponentsWithRequestId:(nonnull NSString *)requestId
                                pageNumber:(NSInteger)pageNumber
                                completion:(nonnull JSRequestCompletionBlock)block;

/**
 High level API for getting report components

 @param executionId A <b>executionId</b> parameter of the report execution response
 @param completion The block to inform of the results

 @since 2.5
 */
- (void)reportComponentForReportWithExecutionId:(nonnull NSString *)executionId
                                     pageNumber:(NSInteger)pageNumber
                                     completion:(void(^ __nonnull)(NSArray <JSReportComponent *>* __nullable , NSError * __nullable ))completion;
@end