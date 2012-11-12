//
//  JSReportDescriptor.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 06.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSReportDescriptor.h"

@implementation JSReportDescriptor

@synthesize uuid = _uuid;
@synthesize originalUri = _originalUri;
@synthesize totalPages = _totalPages;
@synthesize startPage = _startPage;
@synthesize endPage = _endPage;
@synthesize attachments = _attachments;

- (NSString *)description {
    return [NSString stringWithFormat:@"Report Descriptor - uuid: %@; Original URI: %@; Total Pages: %@; Start Page: %@; End Page: %@; Attachments Count: %lu", self.uuid, self.originalUri, self.totalPages, self.startPage, self.endPage, (unsigned long)self.attachments.count];
}

@end
