/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSReportPagesRange.h"

@implementation JSReportPagesRange

#pragma mark - Initializers

+ (instancetype)rangeWithStartPage:(NSUInteger)startPage endPage:(NSUInteger)endPage {
    return [[self alloc] initWithStartPage:startPage endPage:endPage];
}

- (instancetype)initWithStartPage:(NSUInteger)startPage endPage:(NSUInteger)endPage {
    self = [super init];
    if (self) {
        _startPage = startPage;
        _endPage = endPage;
    }
    return self;
}

+ (instancetype)allPagesRange {
    return [self rangeWithStartPage:0 endPage:NSNotFound];
}

- (BOOL) isAllPagesRange {
    return (self.startPage == 0 && self.endPage == NSNotFound);
}

- (BOOL)isEqual:(id)object {
    JSReportPagesRange *pagesRange = (JSReportPagesRange *)object;
    return (self.startPage == pagesRange.startPage && self.endPage == pagesRange.endPage);
}

#pragma mark - Custom Getters
- (NSString *)formattedPagesRange {
    if(self.startPage == 0) {
        return @"";
    } else if (self.startPage == self.endPage) {
        return [NSString stringWithFormat:@"%@", @(self.startPage)];
    }

    return [NSString stringWithFormat:@"%@-%@", @(self.startPage), @(self.endPage)];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    JSReportPagesRange *newRange = [[self class] allocWithZone:zone];
    newRange.startPage = self.startPage;
    newRange.endPage = self.endPage;

    return newRange;
}

#pragma mark - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"PagesRange from: %@, to: %@", @(self.startPage), @(self.endPage)];
}

@end
