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
//  JSReport.h
//  Jaspersoft Corporation
//

/**
 @author Aleksandr Dakhno odahno@tibco.com
 @author Alexey Gubarev ogubarie@tibco.com
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
