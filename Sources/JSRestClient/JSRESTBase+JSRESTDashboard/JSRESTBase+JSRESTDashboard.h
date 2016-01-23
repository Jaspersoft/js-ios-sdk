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

@interface JSRESTBase (JSRESTDashboard)

- (void)fetchDashboardComponentsWithURI:(nonnull NSString *)dashboardURI
                             completion:(nullable JSRequestCompletionBlock)block;

/**
 Gets the list of states of input controls with specified IDs for the report with specified URI and according to selected values

 @param dashboardURI repository URI of the dashboard
 @param ids list of input controls IDs
 @param selectedValues list of input controls selected values
 @param async Determine asynchronous nature of request
 @param block The block to inform of the results

 @since 2.3
 */

- (void)inputControlsForDashboardWithURI:(nonnull NSString *)dashboardURI
                                     ids:(nullable NSArray <NSString *> *)ids
                          selectedValues:(nullable NSArray <JSReportParameter *> *)selectedValues
                                   async:(BOOL)async
                         completionBlock:(nullable JSRequestCompletionBlock)block;

/**
 Gets the list of states of input controls with specified IDs for the report with specified URI and according to selected values

 @param dashboardURI repository URI of the dashboard
 @param ids list of input controls IDs
 @param selectedValues list of input controls selected values
 @param async Determine asynchronous nature of request
 @param block The block to inform of the results

 @since 2.3
 */

- (void)updatedInputControlValuesForDashboardWithURI:(nonnull NSString *)dashboardURI
                                                 ids:(nullable NSArray <NSString *> *)ids
                                      selectedValues:(nullable NSArray <JSReportParameter *> *)selectedValues
                                               async:(BOOL)async
                                     completionBlock:(nullable JSRequestCompletionBlock)block;
@end