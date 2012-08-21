//
//  JSProfile.m
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 03.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSProfile.h"

@implementation JSProfile

@synthesize alias;
@synthesize serverUrl;
@synthesize username;
@synthesize password;
@synthesize organization;

- (id)init {
    return [self initWithAlias:nil username:nil password:nil organization:nil serverUrl:nil];
}

- (id)initWithAlias:(NSString *)anAlias username:(NSString *)user password:(NSString *)pass 
      organization:(NSString *)org serverUrl:(NSString *)url {
    if (self = [super init]) {
        self.alias = anAlias;
        self.username = user;
        self.password = pass;
        self.organization = org;
        self.serverUrl = url;
    }
    
    return self;
}

- (NSString *)getUsenameWithOrganization {
    if ([self.organization length] != 0) {
        return [NSString stringWithFormat:@"%@|%@", self.username, self.organization];
    }
    
    return self.username;
}

- (id)copyWithZone:(NSZone *)zone {
    JSProfile *copiedProfile = [[JSProfile allocWithZone:zone] initWithAlias:self.alias 
                                                                    username:self.username 
                                                                    password:self.password
                                                                organization:self.organization 
                                                                   serverUrl:self.serverUrl];
    return copiedProfile;
}

@end
