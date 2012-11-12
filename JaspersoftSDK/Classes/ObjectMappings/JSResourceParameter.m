//
//  JSResourceParameter.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 06.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSResourceParameter.h"

@implementation JSResourceParameter

@synthesize name = _name;
@synthesize isListItem = _isListItem;
@synthesize value = _value;

- (id)initWithName:(NSString *)name isListItem:(NSString *)isListItem value:(NSString *)value {
    if (self = [super init]) {
        self.name = name;
        self.isListItem = isListItem;
        self.value = value;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Resource Parameter - name: %@; Is List Item: %@; Value: %@", 
            self.name, self.isListItem, self.value];
}

@end
