//
//  JSDateTimeFormatValidationRule.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 12.11.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSDateTimeFormatValidationRule.h"

@implementation JSDateTimeFormatValidationRule

@synthesize errorMessage = _errorMessage;
@synthesize format = _format;

- (NSString *)description {
    return [NSString stringWithFormat:@"Date Time Format Validation Rule - Error Message: %@; Format: %@", self.errorMessage, self.format];
}

@end
