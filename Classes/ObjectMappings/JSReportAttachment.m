//
//  JSReportAttachment.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 13.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSReportAttachment.h"

@implementation JSReportAttachment

@synthesize type = _type;
@synthesize name = _name;

- (NSString *)description {
    return [NSString stringWithFormat:@"Report Attachment - type: %@; name: %@", self.type, self.name];
}

@end
