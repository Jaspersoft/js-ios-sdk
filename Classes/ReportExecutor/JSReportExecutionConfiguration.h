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
//  JSReportExecutionConfiguration.h
//  Jaspersoft Corporation
//

/**
 @author Alexey Gubarev ogubarie@tibco.com
 @since 2.3
 */

#import <Foundation/Foundation.h>
#import "JSReportPagesRange.h"

@class JSServerInfo;

@interface JSReportExecutionConfiguration : NSObject

@property (nonatomic, assign) BOOL asyncExecution;
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, assign) BOOL freshData;
@property (nonatomic, assign) BOOL saveDataSnapshot;
@property (nonatomic, assign) BOOL ignorePagination;
@property (nonatomic, strong, nullable) NSString *transformerKey;
@property (nonatomic, strong, nonnull) NSString *outputFormat;
@property (nonatomic, strong, nonnull) NSString *attachmentsPrefix;
@property (nonatomic, strong, nonnull) JSReportPagesRange *pagesRange;

+(nonnull instancetype)saveReportConfigurationWithFormat:(nonnull NSString *)format pagesRange:(nonnull JSReportPagesRange *)pagesRange;

+(nonnull instancetype)viewReportConfigurationWithServerInfo:(nonnull JSServerInfo *)serverInfo;

@end
