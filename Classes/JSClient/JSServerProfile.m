//
//  JSServerProfile.m
//  JaspersoftMobileSDK
//
//  Created by Volodya on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSServerProfile.h"

@implementation JSServerProfile

@synthesize  alias;
@synthesize  username;
@synthesize  password;
@synthesize  organization;
@synthesize  baseUrl;

// The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithAlias:(NSString *)theAlias Username:(NSString *)user Password:(NSString *)pass Organization:(NSString *)org Url:(NSString *)url {
    
	if( (self=[super init]) ) {
		alias=theAlias;
		username = user;
		password = pass;
		organization = org;
		baseUrl = url;
	}
	
	return self;
}

- (NSString *)getUsernameWithOrgId {
    if ([self organization] != nil && [[self organization] length] > 0) {
        NSMutableString *userWithOrganization = [NSMutableString stringWithFormat:@"%@|%@", [self username], [self organization]];
        return userWithOrganization;
    } else {
        return [self username];    
    }        
}

@end
