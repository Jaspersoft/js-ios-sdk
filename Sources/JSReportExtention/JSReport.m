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
//  JSReport.m
//  Jaspersoft Corporation
//

#import "JSReport.h"
#import "JSReportOption.h"
#import "JSResourceLookup.h"
#import "JSInputControlDescriptor.h"
#import "JSReportParameter.h"
#import "JSReportComponent.h"

NSString * const kJSReportIsMutlipageDidChangedNotification = @"kJSReportIsMutlipageDidChangedNotification";
NSString * const kJSReportCountOfPagesDidChangeNotification = @"kJSReportCountOfPagesDidChangeNotification";
NSString * const kJSReportCurrentPageDidChangeNotification = @"kJSReportCurrentPageDidChangeNotification";

@interface JSReport()
@property (nonatomic, strong) NSMutableArray *availableReportOptions;
// setters
@property (nonatomic, assign, readwrite) NSInteger currentPage;
@property (nonatomic, assign, readwrite) NSInteger countOfPages;
@property (nonatomic, assign, readwrite) BOOL isMultiPageReport;
@property (nonatomic, assign, readwrite) BOOL isReportWithInputControls;
@property (nonatomic, assign, readwrite) BOOL isReportEmpty;
@property (nonatomic, strong, readwrite) NSString *requestId;

// html
@property (nonatomic, copy, readwrite) NSString *HTMLString;
@property (nonatomic, copy, readwrite) NSString *baseURLString;

@property (nonatomic, copy, readwrite) NSArray *reportParameters;
@end

@implementation JSReport
@synthesize activeReportOption = _activeReportOption;
@dynamic reportOptions;
@dynamic reportURI;


#pragma mark - LifeCycle
- (instancetype)initWithResourceLookup:(JSResourceLookup *)resourceLookup
{
    self = [super init];
    if (self) {
        _resourceLookup = resourceLookup;
        
        [self restoreDefaultState];
        
        _isReportEmpty = YES;
    }
    return self;
}

+ (instancetype)reportWithResourceLookup:(JSResourceLookup *)resourceLookup
{
    return [[self alloc] initWithResourceLookup:resourceLookup];
}


#pragma mark - Custom accessors
- (void)setIsMultiPageReport:(BOOL)isMultiPageReport
{
    _isMultiPageReport = isMultiPageReport;
    [self postNotificationMultipageReport];
}

- (void)setCountOfPages:(NSInteger)countOfPages
{
    _countOfPages = countOfPages;
    [self postNotificationCountOfPages];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    [self postNotificationCurrentPageChanged];
}

- (NSArray *)reportOptions
{
    return self.availableReportOptions;
}

- (JSReportOption *)activeReportOption
{
    if (_activeReportOption) {
        return _activeReportOption;
    }
    return [self.reportOptions firstObject];
}


- (void)setActiveReportOption:(JSReportOption *)activeReportOption
{
    _activeReportOption = activeReportOption;
    _reportParameters = nil;
}

- (NSString *)reportURI
{
    if ([self.activeReportOption.uri length]) {
        return self.activeReportOption.uri;
    }
    return self.resourceLookup.uri;
}

- (NSArray *)reportParameters
{
    if (!_reportParameters) {
        if ([self.reportOptions indexOfObject:self.activeReportOption] == NSNotFound) {
            _reportParameters = [JSUtils reportParametersFromInputControls:self.activeReportOption.inputControls];
        }
    }
    return _reportParameters;
}

- (void)setReportComponents:(NSArray *)reportComponents
{
    _reportComponents = [reportComponents copy];

    self.elasticChart = NO;
    for (JSReportComponent *component in reportComponents) {
        if (component.type == JSReportComponentTypeChart) {
            NSArray *services = ((JSReportComponentChartStructure *)component.structure).services;
            if (services.count == 1) {
                JSHighchartServiceType serviceType = (JSHighchartServiceType) ((NSNumber *)services.firstObject).integerValue;
                if (serviceType == JSHighchartServiceTypeAdhoc) {
                    self.elasticChart = YES;
                    break;
                }
            }
        }
    }
}

#pragma mark - Public API

- (void)generateReportOptionsWithInputControls:(NSArray *)inputControls;
{
    if ([inputControls count]) {
        _isReportWithInputControls = YES;
        JSReportOption *defaultReportOption = [JSReportOption defaultReportOption];
        defaultReportOption.inputControls = [[NSArray alloc] initWithArray:inputControls copyItems:YES];
        self.availableReportOptions = [@[defaultReportOption] mutableCopy];
        _reportParameters = nil;
    }
}

- (void)addReportOptions:(NSArray *)reportOptions
{
    [self.availableReportOptions addObjectsFromArray:reportOptions];
}

- (void)removeReportOption:(JSReportOption *)reportOption
{
    [self.availableReportOptions removeObject:reportOption];
}

- (void)updateReportParameters:(NSArray *)reportParameters
{
    _reportParameters = [reportParameters copy];
}

- (void)updateCurrentPage:(NSInteger)currentPage
{
    if (self.currentPage == currentPage) {
        return;
    }
    
    self.currentPage = currentPage;
}

- (void)updateCountOfPages:(NSInteger)countOfPages
{
    if (self.countOfPages == countOfPages) {
        return;
    }
    
    self.isReportEmpty = countOfPages == 0 || countOfPages == NSNotFound;
    self.countOfPages = countOfPages;
    
    if (countOfPages != NSNotFound) {
        self.isMultiPageReport = countOfPages > 1;
    }
}

- (void)updateHTMLString:(NSString *)HTMLString
            baseURLSring:(NSString *)baseURLString
{
    self.HTMLString = HTMLString;
    self.baseURLString = baseURLString;
}

- (void)updateRequestId:(NSString *)requestId
{
    self.requestId = requestId;
}

- (void)updateIsMultiPageReport:(BOOL)isMultiPageReport
{
    self.isReportEmpty = NO;
    self.isMultiPageReport = isMultiPageReport;
}

#pragma mark - Notifications
- (void)postNotificationMultipageReport
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kJSReportIsMutlipageDidChangedNotification
                                                        object:self];
}

- (void)postNotificationCountOfPages
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kJSReportCountOfPagesDidChangeNotification
                                                        object:self];
}

- (void)postNotificationCurrentPageChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kJSReportCurrentPageDidChangeNotification
                                                        object:self];
}

#pragma mark - Restore default state
- (void)restoreDefaultState
{
    self.HTMLString = nil;
    self.baseURLString = nil;
    self.currentPage = NSNotFound;
    self.countOfPages = NSNotFound;
    self.isMultiPageReport = NO;
    self.isReportEmpty = YES;
    self.reportParameters = nil;
    self.requestId = nil;
}

#pragma mark - Helpers
- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"\nReport: %@\ncount of pages: %@\nisEmpty: %@", self.resourceLookup.label, @(self.countOfPages), @(self.isReportEmpty)];
    return description;
}

@end
