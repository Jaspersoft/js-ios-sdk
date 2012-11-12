//
//  JSProfile.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 03.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSProfile.h"

@implementation JSProfile

@synthesize alias = _alias;
@synthesize serverUrl = _serverUrl;
@synthesize username = _username;
@synthesize password = _password;
@synthesize organization = _organization;

- (id)init {
    return [self initWithAlias:nil username:nil password:nil organization:nil serverUrl:nil];
}

- (id)initWithAlias:(NSString *)alias 
           username:(NSString *)username 
           password:(NSString *)password 
       organization:(NSString *)organization 
          serverUrl:(NSString *)serverUrl {
    if (self = [super init]) {
        self.alias = alias;
        self.username = username;
        self.password = password;
        self.organization = organization;
        self.serverUrl = serverUrl;
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
