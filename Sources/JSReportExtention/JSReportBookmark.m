/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSReportBookmark.h"


@implementation JSReportBookmark
- (instancetype)initWithAnchor:(NSString *)anchor page:(NSNumber *)page
{
    self = [super init];
    if (self) {
        _anchor = anchor;
        _page = page;
    }
    return self;
}

+ (instancetype)bookmarkWithAnchor:(NSString *)anchor page:(NSNumber *)page
{
    return [[self alloc] initWithAnchor:anchor page:page];
}
@end
