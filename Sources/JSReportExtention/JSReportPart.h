/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @since 2.6
 */


@interface JSReportPart : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *page;
- (instancetype)initWithTitle:(NSString *)title page:(NSNumber *)page;
+ (instancetype)reportPartWithTitle:(NSString *)title page:(NSNumber *)page;
@end
