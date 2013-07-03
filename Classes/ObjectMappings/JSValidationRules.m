//
//  JSValidationRulesList.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 12.11.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSValidationRules.h"

@implementation JSValidationRules

@synthesize dateTimeFormatValidationRule = _dateTimeFormatValidationRule;

- (NSString *)description {
    return [NSString stringWithFormat:@"Validation Rules - Date Time Format Validation Rule %@", self.dateTimeFormatValidationRule];
}

@end
