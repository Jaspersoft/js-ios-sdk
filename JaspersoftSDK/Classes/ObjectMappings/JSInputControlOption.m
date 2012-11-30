//
//  JSInputControlOption.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 01.11.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSInputControlOption.h"

@implementation JSInputControlOption

@synthesize label = _label;
@synthesize value = _value;
@synthesize selected = _selected;

- (NSString *)description {
    return [NSString stringWithFormat:@"Input Control Option - Label: %@; Value: %@; Selected: %@", self.label, self.value, self.selected];
}

@end
