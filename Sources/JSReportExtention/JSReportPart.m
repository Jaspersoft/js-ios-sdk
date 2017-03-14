/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSReportPart.h"


@implementation JSReportPart

- (instancetype)initWithTitle:(NSString *)title page:(NSNumber *)page
{
    self = [super init];
    if (self) {
        _title = title;
        _page = page;
    }
    return self;
}

+ (instancetype)reportPartWithTitle:(NSString *)title page:(NSNumber *)page
{
    return [[self alloc] initWithTitle:title page:page];
}

@end
