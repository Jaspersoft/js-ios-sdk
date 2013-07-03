//
//  JSServerInfo.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 30.10.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSServerInfo.h"

@implementation JSServerInfo

@synthesize build = _build;
@synthesize edition = _edition;
@synthesize editionName = _editionName;
@synthesize expiration = _expiration;
@synthesize features = _features;
@synthesize licenseType = _licenseType;
@synthesize version = _version;

- (NSString *)description {
    return [NSString stringWithFormat:@"Server Info - Build: %@; Edition: %@; Edition Name: %@; Expiration: %@; Features: %@; License Type: %@; Version: %@", self.build, self.edition, self.editionName, self.expiration, self.features, self.licenseType, self.version];
}

- (NSInteger)versionAsInteger {
    NSInteger intVersion = 0;
    
    if (self.version) {
        NSArray *numbers = [self.version componentsSeparatedByString:@"."];
        for (NSInteger i = 0; i < numbers.count; i++) {
            NSInteger exp = (numbers.count - 1 - i) * 2;
            intVersion += [[numbers objectAtIndex:i] integerValue] * pow(10, exp);
        }
    }
    
    return intVersion;
}

@end
