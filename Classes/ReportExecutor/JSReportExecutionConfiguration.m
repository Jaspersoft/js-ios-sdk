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
//  JSReportExecutionConfiguration.m
//  Jaspersoft Corporation
//


#import "JSReportExecutionConfiguration.h"
#import "JSServerInfo.h"

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

+(nonnull instancetype)viewReportConfigurationWithServerInfo:(nonnull JSServerInfo *)serverInfo {
    JSReportExecutionConfiguration *configuration = [JSReportExecutionConfiguration new];
    configuration.asyncExecution = YES;
    configuration.interactive = [self isInteractiveForServerInfo:serverInfo];
    configuration.freshData = NO;
    configuration.saveDataSnapshot = YES;
    configuration.ignorePagination = NO;
    configuration.outputFormat = kJS_CONTENT_TYPE_HTML;
    configuration.transformerKey = nil;
    configuration.attachmentsPrefix = kJS_REST_EXPORT_EXECUTION_ATTACHMENTS_PREFIX_URI;
    configuration.pagesRange = [JSReportPagesRange allPagesRange];
    return configuration;
}

#pragma mark - Private API
+ (BOOL)isInteractiveForServerInfo:(JSServerInfo *)serverInfo {
    CGFloat currentVersion = serverInfo.versionAsFloat;
    CGFloat currentVersion_const = kJS_SERVER_VERSION_CODE_EMERALD_5_6_0;
    BOOL interactive = (currentVersion > currentVersion_const || currentVersion < currentVersion_const);
    return interactive;
}

@end
