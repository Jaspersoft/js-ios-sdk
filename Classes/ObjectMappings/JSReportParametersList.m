//
//  JSReportParametersList.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 07.11.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSReportParametersList.h"

@implementation JSReportParametersList

@synthesize reportParameters = _reportParameters;

- (id)initWithReportParameters:(NSArray *)reportParameters {
    if (self = [self init]) {
        self.reportParameters = reportParameters;
    }
    
    return self;
}

@end
