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

typedef NS_ENUM(NSInteger, JSReportLoaderState) {
    JSReportLoaderStateInitial,
    JSReportLoaderStateConfigured,
    JSReportLoaderStateLoading,
    JSReportLoaderStateReady,
    JSReportLoaderStateFailed,
    JSReportLoaderStateCancel
};

typedef void(^JSReportLoaderCompletionBlock)(BOOL success, NSError * __nullable error);

@class JSRESTBase;

@protocol JSReportLoaderProtocol <NSObject>
@property (nonatomic, strong, readonly, nonnull) JSReport *report;
@property (nonatomic, assign, readonly) JSReportLoaderState state;

- (nonnull instancetype)initWithRestClient:(nonnull JSRESTBase *)restClient;
+ (nonnull instancetype)loaderWithRestClient:(nonnull JSRESTBase *)restClient;

- (void)runReport:(nonnull JSReport *)report
      initialPage:(nullable NSNumber *)initialPage
initialParameters:(nullable NSArray <JSReportParameter *> *)initialParameters
       completion:(nonnull JSReportLoaderCompletionBlock)completion;
- (void)runReportWithReportURI:(nonnull NSString *)reportURI
                   initialPage:(nullable NSNumber *)initialPage
             initialParameters:(nullable NSArray <JSReportParameter *> *)initialParameters
                    completion:(nonnull JSReportLoaderCompletionBlock)completion;
- (void)fetchPage:(nonnull NSNumber *)page
       completion:(nonnull JSReportLoaderCompletionBlock)completionBlock;
- (void) applyReportParameters:(nullable NSArray <JSReportParameter *> *)parameters
                    completion:(nonnull JSReportLoaderCompletionBlock)completion;
- (void) refreshReportWithCompletion:(nonnull JSReportLoaderCompletionBlock)completion;
- (void)cancel;
- (void)reset;

@optional
- (BOOL) shouldDisplayLoadingView;
@end
