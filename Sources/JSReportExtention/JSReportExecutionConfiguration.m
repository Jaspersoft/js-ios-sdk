/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSReportExecutionConfiguration.h"
#import "JSServerInfo.h"
#import "JSProfile.h"

@implementation JSReportExecutionConfiguration

+(nonnull instancetype)saveReportConfigurationWithFormat:(NSString *)format pagesRange:(JSReportPagesRange *)pagesRange {
    JSReportExecutionConfiguration *configuration = [JSReportExecutionConfiguration new];
    configuration.asyncExecution = YES;
    configuration.interactive = NO;
    configuration.freshData = NO;
    configuration.saveDataSnapshot = YES;
    configuration.ignorePagination = NO;
    configuration.outputFormat = format;
    configuration.transformerKey = nil;
    configuration.attachmentsPrefix = @"_";
    configuration.pagesRange = pagesRange;
    return configuration;
}

+(nonnull instancetype)viewReportConfigurationWithServerProfile:(nonnull JSProfile *)serverProfile {
    JSReportExecutionConfiguration *configuration = [JSReportExecutionConfiguration new];
    configuration.asyncExecution = YES;
    configuration.interactive = [self isInteractiveForServerProfile:serverProfile];
    configuration.freshData = NO;
    configuration.saveDataSnapshot = YES;
    configuration.ignorePagination = NO;
    configuration.outputFormat = kJS_CONTENT_TYPE_HTML;
    configuration.transformerKey = nil;
    configuration.attachmentsPrefix = [NSString stringWithFormat:@"%@/%@%@", serverProfile.serverUrl, kJS_REST_SERVICES_V2_URI, kJS_REST_EXPORT_EXECUTION_ATTACHMENTS_PREFIX_URI];
    configuration.pagesRange = [JSReportPagesRange allPagesRange];
    return configuration;
}

#pragma mark - Private API
+ (BOOL)isInteractiveForServerProfile:(JSProfile *)serverProfile {
    float currentVersion = serverProfile.serverInfo.versionAsFloat;
    float currentVersion_const = kJS_SERVER_VERSION_CODE_EMERALD_5_6_0;
    BOOL interactive = (currentVersion > currentVersion_const || currentVersion < currentVersion_const);
    return interactive;
}

@end
