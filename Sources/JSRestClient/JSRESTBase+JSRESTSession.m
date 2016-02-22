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

#if __has_include("JSSecurity.h")
#import "JSSecurity.h"
#endif

NSString * const kJSAuthenticationUsernameKey       = @"j_username";
NSString * const kJSAuthenticationPasswordKey       = @"j_password";
NSString * const kJSAuthenticationOrganizationKey   = @"orgId";
NSString * const kJSAuthenticationLocaleKey         = @"userLocale";
NSString * const kJSAuthenticationTimezoneKey       = @"userTimezone";

@implementation JSRESTBase(JSRESTSession)

#pragma mark - Public API

- (void)verifyIsSessionAuthorizedWithCompletion:(void (^)(BOOL isSessionAuthorized))completion {
    if ([self.cookies count]) {
        if (completion) {
            completion(YES);
        }
    } else {
        // Get server info
        __weak typeof(self)weakSelf = self;
        [self fetchServerInfoWithCompletion:^(JSOperationResult * _Nullable result) {
            if (!result.error && result.objects.count) {
                __strong typeof(self) strongSelf = weakSelf;
                NSString *username = strongSelf.serverProfile.username;
                NSString *password = strongSelf.serverProfile.password;
                NSString *organization = strongSelf.serverProfile.organization;

                strongSelf.serverProfile.serverInfo = [result.objects firstObject];
                
                // Try to get authentication token
#if __has_include("JSSecurity.h")
                __weak typeof(self)weakSelf = strongSelf;
                [strongSelf fetchEncryptionKeyWithCompletion:^(JSEncryptionData *encryptionData, NSError *error) {
                    NSString *encPassword = password;
                    if (encryptionData.modulus && encryptionData.exponent) {
                        JSEncryptionManager *encryptionManager = [JSEncryptionManager new];
                        encPassword = [encryptionManager encryptText:password
                                                         withModulus:encryptionData.modulus
                                                            exponent:encryptionData.exponent];
                    }
                    
                    __strong typeof(self)strongSelf = weakSelf;
                    [strongSelf fetchAuthenticationTokenWithUsername:username
                                                            password:encPassword
                                                        organization:organization
                                                          completion:completion];
                }];
#else
                [strongSelf fetchAuthenticationTokenWithUsername:username
                                                  password:password
                                              organization:organization
                                                completion:completion];
#endif
            } else if(completion) {
                completion(NO);
            }
        }];
    }
}

#pragma mark - Private API
- (void)fetchServerInfoWithCompletion:(JSRequestCompletionBlock)completion {
    JSRequest *request = [[JSRequest alloc] initWithUri:kJS_REST_SERVER_INFO_URI];
    request.expectedModelClass = [JSServerInfo class];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = completion;
    [self sendRequest:request];
}

- (void)fetchEncryptionKeyWithCompletion:(void(^)(JSEncryptionData *encryptionData, NSError *error))completion
{
    JSRequest *request = [[JSRequest alloc] initWithUri:kJS_REST_ENCRYPTION_KEY_URI];
    
    request.restVersion = JSRESTVersion_None;
    request.expectedModelClass = [JSEncryptionData class];
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
                                  completion:(void(^)(BOOL isTokenFetchedSuccessful))completion
{
    JSRequest *request = [[JSRequest alloc] initWithUri:kJS_REST_AUTHENTICATION_URI];
    request.restVersion = JSRESTVersion_None;
    request.method = JSRequestHTTPMethodPOST;
    request.responseAsObjects = NO;
    request.redirectAllowed = NO;
    request.serializationType = JSRequestSerializationType_UrlEncoded;

    [self resetReachabilityStatus];
    [self deleteCookies];
    
    // Add locale to session
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSInteger dividerPosition = [currentLanguage rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"_-"]].location;
    if (dividerPosition != NSNotFound) {
        currentLanguage = [currentLanguage substringToIndex:dividerPosition];
    }
    NSString *currentLocale = [[JSUtils supportedLocales] objectForKey:currentLanguage];
    
    [request addParameter:kJSAuthenticationUsernameKey      withStringValue:username];
    [request addParameter:kJSAuthenticationPasswordKey      withStringValue:password];
    [request addParameter:kJSAuthenticationOrganizationKey  withStringValue:organization];
    [request addParameter:kJSAuthenticationTimezoneKey      withStringValue:[[NSTimeZone localTimeZone] name]];
    [request addParameter:kJSAuthenticationLocaleKey        withStringValue:currentLocale];
    
    
    [request setCompletionBlock:^(JSOperationResult *result) {
        if (completion) {
            completion(!result.error);
        }
    }];
    [self sendRequest:request];
}

@end
