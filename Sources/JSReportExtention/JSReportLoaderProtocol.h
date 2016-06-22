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
//  JSReportLoaderProtocol.h
//  Jaspersoft Corporation
//

/**
 @author Aleksandr Dakhno odahno@tibco.com
 @author Alexey Gubarev ogubarie@tibco.com
 @since 2.3
 */

#import <Foundation/Foundation.h>
#import "JSReport.h"

typedef NS_ENUM(NSInteger, JSReportLoaderErrorType) {
    JSReportLoaderErrorTypeUndefined,
    JSReportLoaderErrorTypeEmtpyReport,
    JSReportLoaderErrorTypeAuthentification,
    JSReportLoaderErrorTypeLoadingCanceled
};

typedef void(^JSReportLoaderCompletionBlock)(BOOL success, NSError * __nullable error);

@class JSRESTBase;

@protocol JSReportLoaderProtocol <NSObject>

@required
@property (nonatomic, weak, readonly, null_unspecified) JSReport *report;
@property (nonatomic, assign, readonly) BOOL isReportInLoadingProcess;

- (nonnull instancetype)initWithReport:(nonnull JSReport *)report restClient:(nonnull JSRESTBase *)restClient;
+ (nonnull instancetype)loaderWithReport:(nonnull JSReport *)report restClient:(nonnull JSRESTBase *)restClient;

- (void)runReportWithPage:(NSInteger)page completion:(nonnull JSReportLoaderCompletionBlock)completion;
- (void)fetchPageNumber:(NSInteger)pageNumber withCompletion:(nonnull JSReportLoaderCompletionBlock)completionBlock;
- (void)cancel;

@optional

- (BOOL) shouldDisplayLoadingView;
- (void) applyReportParametersWithCompletion:(nonnull JSReportLoaderCompletionBlock)completion;
- (void) refreshReportWithCompletion:(nonnull JSReportLoaderCompletionBlock)completion;

@end
