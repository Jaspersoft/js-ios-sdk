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
//  JSSessionManager.h
//  Jaspersoft Corporation
//

#import "JSSession.h"
#import "JSProfile.h"
#import "weakself.h"
#import "JSConstants.h"

NSString * const kJSSavedSessionKey                 = @"JSSavedSessionKey";
NSString * const kJSSavedSessionServerProfileKey    = @"JSSavedSessionServerProfileKey";
NSString * const kJSSavedSessionTimeoutKey          = @"JSSavedSessionTimeoutKey";
NSString * const kJSSavedSessionKeepSessionKey      = @"JSSavedSessionKeepSessionKey";



NSString * const kJSAuthenticationUsernameKey       = @"j_username";
NSString * const kJSAuthenticationPasswordKey       = @"j_password";
NSString * const kJSAuthenticationOrganizationKey   = @"orgId";
NSString * const kJSAuthenticationLocaleKey         = @"userLocale";
NSString * const kJSAuthenticationTimezoneKey       = @"userTimezone";


// Provide access to private methods of JSRESTBase
@interface JSRESTBase (Private)
- (JSOperationResult *)operationResultWithOperation:(id)restKitOperation;
@end


@interface JSSession ()
//@property (nonatomic, strong, readwrite) JSProfile *serverProfile;
@property (nonatomic, assign, readwrite) BOOL keepSession;

@end

@implementation JSSession

- (instancetype)initWithServerProfile:(JSProfile *)serverProfile keepLogged:(BOOL)keepLogged{
    self = [super initWithServerProfile:serverProfile];
    if (self) {
        self.keepSession = keepLogged;
    }
    return self;
}

- (BOOL)isSessionAuthorized {
    return [[self cookies] count];
}

- (void)authenticationTokenWithCompletion:(void(^)(BOOL success))completionBlock {
    JSRequest *request = [[JSRequest alloc] initWithUri:[JSConstants sharedInstance].REST_AUTHENTICATION_URI];
    request.restVersion = JSRESTVersion_None;
    request.method = RKRequestMethodGET;
    request.responseAsObjects = NO;
    request.redirectAllowed = NO;
    
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
    
    request.completionBlock = @weakself(^(JSOperationResult *result)) {
        if (completionBlock) {
            completionBlock(!!result.error);
        }
    }@weakselfend;
    [self sendRequest:request];
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.serverProfile forKey:kJSSavedSessionServerProfileKey];
    [aCoder encodeBool:self.keepSession forKey:kJSSavedSessionKeepSessionKey];
    [aCoder encodeFloat:self.timeoutInterval forKey:kJSSavedSessionTimeoutKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.serverProfile = [aDecoder decodeObjectForKey:kJSSavedSessionServerProfileKey];
        self.keepSession = [aDecoder decodeBoolForKey:kJSSavedSessionKeepSessionKey];
        self.timeoutInterval = [aDecoder decodeFloatForKey:kJSSavedSessionTimeoutKey];
    }
    return self;
}

#pragma mark - Private
- (JSOperationResult *)operationResultWithOperation:(id)restKitOperation{
    RKHTTPRequestOperation *httpOperation = [restKitOperation isKindOfClass:[RKObjectRequestOperation class]] ? [restKitOperation HTTPRequestOperation] : restKitOperation;

    JSOperationResult *result = [super operationResultWithOperation:restKitOperation];
    
    NSString *urlString = [httpOperation.request.URL relativeString];
    if ([urlString isEqualToString:[JSConstants sharedInstance].REST_AUTHENTICATION_URI]) {
        NSString *redirectURL = [httpOperation.response.allHeaderFields objectForKey:@"Location"];
        
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedStringFromTable(@"error.authenication.dialog.msg", @"JaspersoftSDK", nil)};
        result.error = [NSError errorWithDomain:NSURLErrorDomain code:JSSessionExpiredErrorCode userInfo:userInfo];
    }
    
    return result;
}


@end
