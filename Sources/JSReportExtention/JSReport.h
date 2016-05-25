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

#import "JSResourceLookup.h"

@class JSReportOption, JSInputControlDescriptor, JSReportParameter, JSReportComponent;

extern NSString * const kJSReportIsMutlipageDidChangedNotification;
extern NSString * const kJSReportCountOfPagesDidChangeNotification;
extern NSString * const kJSReportCurrentPageDidChangeNotification;

@interface JSReport : NSObject <NSCopying>
// getters
@property (nonatomic, strong, readonly) JSResourceLookup *resourceLookup;

@property (nonatomic, copy, readonly) NSArray *reportParameters;
@property (nonatomic, copy, readonly) NSString *reportURI;
@property (nonatomic, assign, readonly) NSInteger currentPage;
@property (nonatomic, assign, readonly) NSInteger countOfPages;
@property (nonatomic, assign, readonly) BOOL isMultiPageReport;
@property (nonatomic, assign, readonly) BOOL isReportWithInputControls;
@property (nonatomic, assign, readonly) BOOL isReportEmpty;
@property (nonatomic, strong, readonly) NSString *requestId;
@property (nonatomic, assign) BOOL isReportAlreadyLoaded;

// Report Components
@property (nonatomic, copy) NSArray <JSReportComponent *>*reportComponents;
@property (nonatomic, assign, getter=isElasticChart) BOOL elasticChart;

// html
@property (nonatomic, copy, readonly) NSString *HTMLString;
@property (nonatomic, copy, readonly) NSString *baseURLString;

// report options
@property (nonatomic, strong, readonly) NSArray <JSReportOption *> *reportOptions;
@property (nonatomic, strong) JSReportOption *activeReportOption;


- (instancetype)initWithResourceLookup:(JSResourceLookup *)resourceLookup;
+ (instancetype)reportWithResourceLookup:(JSResourceLookup *)resourceLookup;

// update state
- (void)generateReportOptionsWithInputControls:(NSArray <JSInputControlDescriptor *>*)inputControls;
- (void)addReportOptions:(NSArray <JSReportOption *>*)reportOptions;
- (void)removeReportOption:(JSReportOption *)reportOption;

- (void)updateReportParameters:(NSArray <JSReportParameter *>*)reportParameters;
- (void)updateCurrentPage:(NSInteger)currentPage;
- (void)updateCountOfPages:(NSInteger)countOfPages;
- (void)updateHTMLString:(NSString *)HTMLString
            baseURLSring:(NSString *)baseURLString;
- (void)updateRequestId:(NSString *)requestId;
- (void)updateIsMultiPageReport:(BOOL)isMultiPageReport;
// restore state
- (void)restoreDefaultState;

@end
