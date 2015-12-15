//
//  JSReportExecutorConfiguration.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 12/15/15.
//
//

#import "JSReportExecutorConfiguration.h"

@implementation JSReportExecutorConfiguration

+(instancetype)defaultConfigurationWithRestClient:(JSRESTBase *)restClient {
    JSReportExecutorConfiguration *configuration = [JSReportExecutorConfiguration new];
    configuration.restClient = restClient;
    configuration.asyncExecution = YES;
    configuration.interactive = YES;
    configuration.freshData = NO;
    configuration.saveDataSnapshot = YES;
    configuration.ignorePagination = NO;
    configuration.outputFormat = kJS_CONTENT_TYPE_HTML;
    configuration.transformerKey = nil;
    configuration.attachmentsPrefix = @"_";
    configuration.pagesRange = [JSReportPagesRange allPagesRange];
    return configuration;
}

+(nonnull instancetype)saveReportConfigurationWithRestClient:(nonnull JSRESTBase *)restClient {
    JSReportExecutorConfiguration *configuration = [JSReportExecutorConfiguration new];
    configuration.restClient = restClient;
    configuration.asyncExecution = YES;
    configuration.interactive = NO;
    configuration.freshData = NO;
    configuration.saveDataSnapshot = YES;
    
#warning NEED CHECK WITH IGNORE PAGINATION YES!
    configuration.ignorePagination = YES;
    configuration.outputFormat = kJS_CONTENT_TYPE_PDF;
    configuration.transformerKey = nil;
    configuration.attachmentsPrefix = @"_";
    configuration.pagesRange = [JSReportPagesRange allPagesRange];
    return configuration;
}


@end
