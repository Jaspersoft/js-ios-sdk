//
//  JSInputControlState.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 01.11.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSInputControlState.h"

@implementation JSInputControlState

@synthesize uuid = _uuid;
@synthesize uri = _uri;
@synthesize value = _value;
@synthesize options = _options;

- (NSString *)description {
    return [NSString stringWithFormat:@"Input Control State - uuid: %@; URI: %@; Value: %@; Options Count: %lu", self.uuid, self.uri, self.value, (unsigned long)self.options.count];
}

@end
