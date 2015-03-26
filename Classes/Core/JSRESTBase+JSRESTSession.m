/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2014 Jaspersoft Corporation. All rights reserved.
 * http://community.jaspersoft.com/project/mobile-sdk-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is part of Jaspersoft Mobile SDK for iOS.
 *
 * Jaspersoft Mobile SDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Jaspersoft Mobile SDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Jaspersoft Mobile SDK for iOS. If not, see
 * <http://www.gnu.org/licenses/lgpl>.
 */

//
//  JSRESTBase+JSRESTSession.m
//  Jaspersoft Corporation
//


#import "JSRESTBase+JSRESTSession.h"
#import "JSConstants.h"
#import "weakself.h"

NSString * const kJSAuthenticationUsernameKey       = @"j_username";
NSString * const kJSAuthenticationPasswordKey       = @"j_password";
NSString * const kJSAuthenticationOrganizationKey   = @"orgId";
NSString * const kJSAuthenticationLocaleKey         = @"userLocale";
NSString * const kJSAuthenticationTimezoneKey       = @"userTimezone";

@implementation JSRESTBase(JSRESTSession)
- (BOOL)isSessionAuthorized {
    if ([self.cookies count]) {
        return YES;
    } else {
        return [self authenticationToken];
    }
}

- (BOOL)authenticationToken {
    JSRequest *request = [[JSRequest alloc] initWithUri:[JSConstants sharedInstance].REST_AUTHENTICATION_URI];
    request.restVersion = JSRESTVersion_None;
    request.method = RKRequestMethodGET;
    request.responseAsObjects = NO;
    request.redirectAllowed = NO;
    request.asynchronous = NO;
    
    [self resetReachabilityStatus];
    
    [request addParameter:kJSAuthenticationUsernameKey      withStringValue:self.serverProfile.username];
    [request addParameter:kJSAuthenticationPasswordKey      withStringValue:self.serverProfile.password];
    [request addParameter:kJSAuthenticationOrganizationKey  withStringValue:self.serverProfile.organization];
    [request addParameter:kJSAuthenticationTimezoneKey      withStringValue:[[NSTimeZone systemTimeZone] abbreviation]];
    
    // Add locale to session
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSInteger dividerPosition = [currentLanguage rangeOfString:@"_"].location;
    if (dividerPosition != NSNotFound) {
        currentLanguage = [currentLanguage substringToIndex:dividerPosition];
    }
    NSString *currentLocale = [[JSConstants sharedInstance].REST_JRS_LOCALE_SUPPORTED objectForKey:currentLanguage];
    [request addParameter:kJSAuthenticationLocaleKey withStringValue:currentLocale];
    
    __block BOOL authenticationSuccess = NO;
    [request setCompletionBlock:@weakself(^(JSOperationResult *result)) {
        authenticationSuccess = (!result.error);
    } @weakselfend];
    [self sendRequest:request];
    
    return authenticationSuccess;
}

@end
