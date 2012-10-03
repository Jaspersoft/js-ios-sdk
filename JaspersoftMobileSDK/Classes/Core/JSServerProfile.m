/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2001 - 2012 Jaspersoft Corporation. All rights reserved.
 * http://community.jaspersoft.com/project/mobile-sdk-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is part of Jaspersoft Mobile SDK.
 *
 * Jaspersoft Mobile SDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Jaspersoft Mobile SDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FJaspersoft CorpOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Jaspersoft Mobile SDK. If not, see <http://www.gnu.org/licenses/>.
 */

//
//  JSServerProfile.m
//  Jaspersoft Corporation
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
