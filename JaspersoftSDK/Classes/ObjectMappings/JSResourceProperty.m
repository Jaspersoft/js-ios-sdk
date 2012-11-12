//
//  JSResourceProperty.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 05.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSResourceProperty.h"

@implementation JSResourceProperty

@synthesize name = _name;
@synthesize value = _value;
@synthesize childResourceProperties = _childResourceProperties;

- (NSString *)description {
    return [NSString stringWithFormat:@"Resource Property - Name: %@; Value: %@, Child Resource Properties Count: %lu", self.name, self.value, (unsigned long)self.childResourceProperties.count];
}

@end
