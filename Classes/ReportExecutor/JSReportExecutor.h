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
//  JSReportExecutor.h
//  Jaspersoft Corporation
//

/**
 @author Aleksandr Dakhno odahno@tibco.com
 @author Alexey Gubarev ogubarie@tibco.com
 @since 2.3
 */

@class JSRESTBase, JSReport, JSReportPagesRange, JSReportExecutionResponse, JSExportExecutionResponse;

typedef void(^JSReportExecutionCompletionBlock)(JSReportExecutionResponse * __nullable executionResponse, NSError * __nullable error);
typedef void(^JSExportExecutionCompletionBlock)(JSExportExecutionResponse * __nullable exportResponse, NSError * __nullable error);


@interface JSReportExecutor : NSObject
@property (nonatomic, assign) BOOL asyncExecution; // YES by default
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, copy, nullable) NSString *format;
@property (nonatomic, copy, nullable) NSString *attachmentsPrefix;

- (nonnull instancetype)initWithReport:(nonnull JSReport *)report forRestClient:(nonnull JSRESTBase *)restClient;
+ (nonnull instancetype)executorWithReport:(nonnull JSReport *)report forRestClient:(nonnull JSRESTBase *)restClient;

- (void)executeWithCompletion:(nullable JSReportExecutionCompletionBlock)completion;
#warning HERE NEED CHECK USE FORMAT IN THIS METHOD - MAYBE WE CAN USE ONE REPORT EXECUTION FOR DIFFERENT FORMATS
- (void)exportForRange:(nonnull JSReportPagesRange *)pagesRange withCompletion:(nullable JSExportExecutionCompletionBlock)completion;

- (void)cancel;

@end