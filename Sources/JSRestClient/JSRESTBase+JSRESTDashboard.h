/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2016 Jaspersoft Corporation. All rights reserved.
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
//  JSRESTBase+JSRESTDashboard.h
//  Jaspersoft Corporation
//


#import "JSRESTBase.h"
#import "JSDashboardParameter.h"

@interface JSRESTBase (JSRESTDashboard)

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

- (void)runDashboardExportExecutionWithURI:(nonnull NSString *)dashboardURI
                                  toFormat:(nullable NSString *)format
                                parameters:(nullable NSArray <JSDashboardParameter *> *)params
                                completion:(nullable JSRequestCompletionBlock)block;

- (void)dashboardExportExecutionStatusWithJobID:(nonnull NSString *)jobID
                                     completion:(nullable JSRequestCompletionBlock)block;

- (void)cancelDashboardExportExecutionWithJobID:(nonnull NSString *)jobID
                                     completion:(nullable JSRequestCompletionBlock)block;

- (nonnull NSString *)generateDashboardOutputUrl:(nonnull NSString *)jobID;

@end