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
#import "JSEncryptionData.h"
#import "JSUserProfile.h"
#import "JSSSOProfile.h"
#import "JSPAProfile.h"
#import "JSRESTBase+JSRESTServer.h"

#if __has_include("JSSecurity.h")
#import "JSSecurity.h"
#endif

NSString * const kJSSessionDidAuthorizedNotification            = @"JSSessionDidAuthorizedNotification";


NSString * const kJSAuthenticationUsernameKey       = @"j_username";
NSString * const kJSAuthenticationPasswordKey       = @"j_password";
NSString * const kJSAuthenticationOrganizationKey   = @"orgId";
NSString * const kJSAuthenticationLocaleKey         = @"userLocale";
NSString * const kJSAuthenticationTimezoneKey       = @"userTimezone";

@implementation JSRESTBase(JSRESTSession)

#pragma mark - Public API

- (void)verifyIsSessionAuthorizedWithCompletion:(JSRequestCompletionBlock)completion {
    [self deleteCookies];

    // Get server info
    __weak typeof(self)weakSelf = self;
    [self fetchServerInfoWithCompletion:^(JSOperationResult * _Nullable result) {
        if (!result.error && result.objects.count) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.serverProfile.serverInfo = [result.objects firstObject];

            // Try to get authentication token
            if ([strongSelf.serverProfile isKindOfClass:[JSUserProfile class]]) {
                JSUserProfile *userServerProfile = (JSUserProfile *)strongSelf.serverProfile;
                
#if __has_include("JSSecurity.h")
                __weak typeof(self)weakSelf = strongSelf;
                [strongSelf fetchEncryptionKeyWithCompletion:^(JSEncryptionData *encryptionData, NSError *error) {
                    NSString *encPassword = userServerProfile.password;
                    if (encryptionData.modulus && encryptionData.exponent) {
                        JSEncryptionManager *encryptionManager = [JSEncryptionManager new];
                        encPassword = [encryptionManager encryptText:encPassword
                                                         withModulus:encryptionData.modulus
                                                            exponent:encryptionData.exponent];
                    }
                    
                    __strong typeof(self)strongSelf = weakSelf;
                    [strongSelf fetchAuthenticationTokenWithUsername:userServerProfile.username
                                                            password:encPassword
                                                        organization:userServerProfile.organization
                                                          completion:completion];
                }];
#else
                [strongSelf fetchAuthenticationTokenWithUsername:userServerProfile.username
                                                        password:userServerProfile.password
                                                    organization:userServerProfile.organization
                                                      completion:completion];
#endif
            } else if ([strongSelf.serverProfile isKindOfClass:[JSPAProfile class]]) {
                JSPAProfile *paServerProfile = (JSPAProfile *)strongSelf.serverProfile;
                [strongSelf fetchAuthenticationTokenWithSSOToken:paServerProfile.ppToken ssoTokenField:paServerProfile.ppTokenField completion:completion];
            } else if ([strongSelf.serverProfile isKindOfClass:[JSSSOProfile class]]) {
                JSSSOProfile *ssoServerProfile = (JSSSOProfile *)strongSelf.serverProfile;
                [strongSelf fetchAuthenticationTokenWithSSOToken:ssoServerProfile.ssoToken ssoTokenField:ssoServerProfile.ssoTokenField completion:completion];
            } else {
                @throw ([NSException exceptionWithName:@"UnSupportedServerProfileType"
                                                reason:[NSString stringWithFormat:@"Unsupported server profile type: %@", NSStringFromClass(strongSelf.serverProfile.class)]
                                              userInfo:nil]);
            }
        } else if(completion) {
            completion(result);
        }
    }];
}

#pragma mark - Private API

- (void)fetchEncryptionKeyWithCompletion:(void(^)(JSEncryptionData *encryptionData, NSError *error))completion
{
    JSRequest *request = [[JSRequest alloc] initWithUri:kJS_REST_ENCRYPTION_KEY_URI];
    
    request.restVersion = JSRESTVersion_None;
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSEncryptionData objectMappingForServerProfile:self.serverProfile] keyPath:nil];
    request.redirectAllowed = NO;
    request.shouldResendRequestAfterSessionExpiration = NO;
    
    [request setCompletionBlock:^(JSOperationResult *result) {
        if (completion) {
            if (result.error) {
                completion(nil, result.error);
            } else {
                JSEncryptionData *encryptionData = [result.objects lastObject];
                completion(encryptionData, nil);
            }
        }
    }];
    
    [self sendRequest:request];
}

- (void)fetchAuthenticationTokenWithUsername:(NSString *)username
                                    password:(NSString *)password
                                organization:(NSString *)organization
                                  completion:(JSRequestCompletionBlock)completion
{
    JSRequest *request = [self authenticationRequestWithCompletion:completion];
    
    [request addParameter:kJSAuthenticationUsernameKey      withStringValue:username];
    [request addParameter:kJSAuthenticationPasswordKey      withStringValue:password];
    [request addParameter:kJSAuthenticationOrganizationKey  withStringValue:organization];
    
    [self sendRequest:request];
}

- (void)fetchAuthenticationTokenWithSSOToken:(NSString *)ssoToken
                               ssoTokenField:(NSString *)ssoTokenField
                                  completion:(JSRequestCompletionBlock)completion
{
    JSRequest *request = [self authenticationRequestWithCompletion:completion];
    [request addParameter:ssoTokenField withStringValue:ssoToken];
    [self sendRequest:request];
}


- (JSRequest *)authenticationRequestWithCompletion:(JSRequestCompletionBlock)completion {
    JSRequest *request = [[JSRequest alloc] initWithUri:kJS_REST_AUTHENTICATION_URI];
    request.restVersion = JSRESTVersion_None;
    request.method = JSRequestHTTPMethodPOST;
    request.responseAsObjects = NO;
    request.redirectAllowed = NO;
    request.serializationType = JSRequestSerializationType_UrlEncoded;
    
    NSURL *serverURL = [NSURL URLWithString:self.serverProfile.serverUrl];
    NSString *serverDomain = [NSString stringWithFormat:@"%@://%@%@", serverURL.scheme, serverURL.host, serverURL.port ? [NSString stringWithFormat:@":%@", serverURL.port] : @""];
    request.additionalHeaders = @{
                                  @"x-jasper-xdm" : serverDomain
                                  };
    
    // Add locale to session
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSInteger dividerPosition = [currentLanguage rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"_-"]].location;
    if (dividerPosition != NSNotFound) {
        currentLanguage = [currentLanguage substringToIndex:dividerPosition];
    }
    NSString *currentLocale = [[JSUtils supportedLocales] objectForKey:currentLanguage];
    
    [request addParameter:kJSAuthenticationTimezoneKey withStringValue:[[NSTimeZone localTimeZone] name]];
    [request addParameter:kJSAuthenticationLocaleKey   withStringValue:currentLocale];
    
    [request setCompletionBlock:^(JSOperationResult *result) {
        if (!result.error) {
            
            NSURL *url = [NSURL URLWithString:result.request.fullURI];
            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:result.allHeaderFields
                                                                      forURL:url];
            [self updateCookiesWithCookies:cookies];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kJSSessionDidAuthorizedNotification object:self];
        }
        if (completion) {
            completion(result);
        }
    }];
    return request;
}

@end
