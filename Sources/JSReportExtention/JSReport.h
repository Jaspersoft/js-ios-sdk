/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.3
 */

#import <UIKit/UIKit.h>
#import "JSResourceLookup.h"

extern NSString * __nonnull const JSReportIsMutlipageDidChangedNotification;
extern NSString * __nonnull const JSReportCountOfPagesDidChangeNotification;
extern NSString * __nonnull const JSReportCurrentPageDidChangeNotification;
extern NSString * __nonnull const JSReportBookmarksDidUpdateNotification;
extern NSString * __nonnull const JSReportPartsDidUpdateNotification;

@class JSReportOption, JSInputControlDescriptor, JSReportParameter, JSReportComponent;
@class JSReportBookmark;
@class JSReportPart;
@class JSReportSearch;

@interface JSReport : NSObject <NSCopying>
// getters
@property (nonatomic, strong, readonly) JSResourceLookup * __nonnull resourceLookup;
@property (nonatomic, assign, readonly) NSInteger currentPage;
@property (nonatomic, assign, readonly) NSInteger countOfPages;
@property (nonatomic, assign, readonly) BOOL isMultiPageReport;
@property (nonatomic, strong, readonly) NSString * __nullable requestId;

@property (nonatomic, copy) NSArray <JSReportParameter *> * __nullable reportParameters;
@property (nonatomic, copy, readonly) NSString * __nonnull reportURI;

// Report Components
@property (nonatomic, copy) NSArray <JSReportComponent *> * __nullable reportComponents;
@property (nonatomic, assign, getter=isElasticChart) BOOL elasticChart;

// html
@property (nonatomic, copy, readonly) NSString * __nullable HTMLString;
@property (nonatomic, copy, readonly) NSString * __nullable baseURLString;

@property (nonatomic, strong) UIImage * __nullable thumbnailImage;
@property (nonatomic, strong) NSArray <JSReportBookmark *>* __nullable bookmarks; /** @since 2.6 */
@property (nonatomic, strong) NSArray <JSReportPart *>* __nullable parts; /** @since 2.6 */
@property (nonatomic, strong, nullable) JSReportSearch *currentSearch; /** @since 2.6 */

- (instancetype __nullable)initWithResourceLookup:(JSResourceLookup * __nullable)resourceLookup;
+ (instancetype __nullable)reportWithResourceLookup:(JSResourceLookup * __nullable)resourceLookup;

// update state
- (void)updateCurrentPage:(NSInteger)currentPage;
- (void)updateCountOfPages:(NSInteger)countOfPages;
- (void)updateHTMLString:(NSString * __nullable)HTMLString
            baseURLSring:(NSString * __nullable)baseURLString;
- (void)updateRequestId:(NSString * __nullable)requestId;
- (void)updateIsMultiPageReport:(BOOL)isMultiPageReport;
// restore state
- (void)restoreDefaultState;

@end
