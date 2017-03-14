/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.3
 */

#import <Foundation/Foundation.h>
#import "JSReport.h"

typedef NS_ENUM(NSInteger, JSReportLoaderErrorType) {
    JSReportLoaderErrorTypeUndefined,
    JSReportLoaderErrorTypeEmtpyReport,
    JSReportLoaderErrorTypeSessionDidExpired,
    JSReportLoaderErrorTypeSessionDidRestore,
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
