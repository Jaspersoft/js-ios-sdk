/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @since 2.6
 */

@interface JSReportBookmark : NSObject
@property (nonatomic, copy) NSString *anchor;
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, copy) NSArray <JSReportBookmark *> *bookmarks;
- (instancetype)initWithAnchor:(NSString *)anchor page:(NSNumber *)page;
+ (instancetype)bookmarkWithAnchor:(NSString *)anchor page:(NSNumber *)page;
@end
