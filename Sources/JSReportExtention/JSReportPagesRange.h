/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.3
 */

@interface JSReportPagesRange : NSObject <NSCopying>

@property (nonatomic, assign) NSUInteger startPage;
@property (nonatomic, assign) NSUInteger endPage;
@property (nonatomic, strong, readonly) NSString *formattedPagesRange;

+ (instancetype)rangeWithStartPage:(NSUInteger)startPage endPage:(NSUInteger)endPage;

- (instancetype)initWithStartPage:(NSUInteger)startPage endPage:(NSUInteger)endPage;

+ (instancetype)allPagesRange;

- (BOOL) isAllPagesRange;

@end
