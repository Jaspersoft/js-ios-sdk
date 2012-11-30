//
//  JSReportParameter.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 07.11.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSReportParameter.h"

@implementation JSReportParameter

@synthesize name = _name;
@synthesize value = _value;

- (id)initWithName:(NSString *)name value:(NSArray *)value {
    if (self = [super init]) {
        self.name = name;
        self.value = value;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Report Parameter - Name: %@; Value: %@",
            self.name, self.value];
}

@end
