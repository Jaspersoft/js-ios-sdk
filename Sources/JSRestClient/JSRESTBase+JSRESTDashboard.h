/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @author Olexandr Dahno odahno@tibco.com
 @since 2.6
 */

#import "JSRESTBase.h"
#import "JSDashboardParameter.h"

@interface JSRESTBase (JSRESTDashboard)
/**
 Run dashboard export execution job on JRS
 
 @param dashboardURI The repository URI (i.e. /dashboards/samples/)
 @param block The block to inform of the results
 
 @since 2.6
 */

- (void)fetchDashboardComponentsWithURI:(nonnull NSString *)dashboardURI
                             completion:(nullable JSRequestCompletionBlock)block;

/**
 Gets the list of states of input controls with specified IDs for the report with specified URI and according to selected values

 @param params list of repository URIs of the dashboard with relative input controls IDs
 @param block The block to inform of the results

 @since 2.3
 */

- (void)inputControlsForDashboardWithParameters:(nullable NSArray <JSDashboardParameter *> *)params
                                completionBlock:(nonnull JSRequestCompletionBlock)block;

/**
 Gets the list of states of input controls with specified IDs for the report with specified URI and according to selected values

 @param params list of repository URIs of the dashboard with relative input controls selected values
 @param block The block to inform of the results

 @since 2.3
 */

- (void)updatedInputControlValuesForDashboardWithParameters:(nullable NSArray <JSDashboardParameter *> *)params
                                            completionBlock:(nullable JSRequestCompletionBlock)block;

/**
 Run dashboard export execution job on JRS
 
 @param dashboardURI The repository URI (i.e. /dashboards/samples/)
 @param format The format for dashboard exporting (i.e. pdf)
 @param params list of repository URIs of the dashboard with relative input controls selected values
 @param block The block to inform of the results
 
 @since 2.6
 */

- (void)runDashboardExportExecutionWithURI:(nonnull NSString *)dashboardURI
                                  toFormat:(nullable NSString *)format
                                parameters:(nullable NSArray <JSDashboardParameter *> *)params
                                completion:(nullable JSRequestCompletionBlock)block;

/**
 Get status of the dashboard export execution job
 
 @param jobID The dashboard export execution job identifier
 @param block The block to inform of the results
 
 @since 2.6
 */

- (void)dashboardExportExecutionStatusWithJobID:(nonnull NSString *)jobID
                                     completion:(nullable JSRequestCompletionBlock)block;
/**
 Cancel the dashboard export execution job
 
 @param jobID The dashboard export execution job identifier
 @param block The block to inform of the results
 
 @since 2.6
 */

- (void)cancelDashboardExportExecutionWithJobID:(nonnull NSString *)jobID
                                     completion:(nullable JSRequestCompletionBlock)block;

/**
 Generate the dashboard export output URL
 
 @param jobID The dashboard export execution job identifier
 
 @since 2.6
 */

- (nonnull NSString *)generateDashboardOutputUrl:(nonnull NSString *)jobID;

@end
