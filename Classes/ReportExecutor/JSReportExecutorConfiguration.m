//
//  JSReportExecutorConfiguration.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 12/15/15.
//
//

#import "JSReportExecutorConfiguration.h"

@implementation JSReportExecutorConfiguration

+(instancetype)defaultConfiguration {
    JSReportExecutorConfiguration *configuration = [JSReportExecutorConfiguration new];
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

+(nonnull instancetype)saveReportConfigurationWithFormat:(NSString *)format pagesRange:(JSReportPagesRange *)pagesRange{
    JSReportExecutorConfiguration *configuration = [JSReportExecutorConfiguration new];
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


@end
