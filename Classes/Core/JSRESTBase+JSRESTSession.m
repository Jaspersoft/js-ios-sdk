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
#import "JSEncryptionManager.h"

NSString * const kJSAuthenticationUsernameKey       = @"j_username";
NSString * const kJSAuthenticationPasswordKey       = @"j_password";
NSString * const kJSAuthenticationOrganizationKey   = @"orgId";
NSString * const kJSAuthenticationLocaleKey         = @"userLocale";
NSString * const kJSAuthenticationTimezoneKey       = @"userTimezone";

@implementation JSRESTBase(JSRESTSession)

#pragma mark - Public API
- (BOOL)isSessionAuthorized {
    return self.cookies.count > 0;
}

- (void)verifyIsSessionAuthorizedWithCompletion:(void (^)(BOOL isSessionAuthorized))completion
{
    if ([self.cookies count]) {
        if (completion) {
            completion(YES);
        }
    } else {
        [self authenticateWithCompletion:completion];
    }
}

#pragma mark - Private API
- (void)fetchEncryptionKeyWithCompletion:(void(^)(NSString *modulus, NSString *exponent, NSError *error))completion
{
    NSString *URI = @"GetEncryptionKey";
    JSRequest *request = [[JSRequest alloc] initWithUri:URI];

    request.restVersion = JSRESTVersion_None;
    request.method = RKRequestMethodGET;
    request.responseAsObjects = NO;
    request.redirectAllowed = NO;
    request.asynchronous = YES;

    [request setCompletionBlock:^(JSOperationResult *result) {
        if (completion) {
            if (result.error) {
                completion(nil, nil, result.error);
            } else {
                NSData *jsonData = result.body;
                NSError *error = nil;
                if (jsonData) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&error];
                    if (json) {
                        NSString *modulus = json[@"n"];
                        NSString *exponent = json[@"e"];
                        if (modulus && exponent) {
                            completion(modulus, exponent, nil);
                        } else {
                            NSString *localizedDescription = JSCustomLocalizedString(@"session.encription.key.doesn't.valid", nil);
                            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
                            error = [NSError errorWithDomain:NSURLErrorDomain code:JSClientErrorCode userInfo:userInfo];
                            completion(nil, nil, error);
                        }
                    } else {
                        completion(nil, nil, error);
                    }
                } else {
                    NSString *localizedDescription = JSCustomLocalizedString(@"session.encription.key.data.empty", nil);
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
                    error = [NSError errorWithDomain:NSURLErrorDomain code:JSClientErrorCode userInfo:userInfo];
                    completion(nil, nil, error);
                }
            }
        }
    }];

    [self sendRequest:request];
}

- (void)fetchAuthenticationTokenWithUsername:(NSString *)username
                                    password:(NSString *)password
                                organization:(NSString *)organization
                                      method:(RKRequestMethod)requestMethod
                                completion:(void(^)(BOOL isTokenFetchedSuccessful))completion
{
    JSRequest *request = [[JSRequest alloc] initWithUri:[JSConstants sharedInstance].REST_AUTHENTICATION_URI];
    request.restVersion = JSRESTVersion_None;
    request.method = requestMethod;
    request.responseAsObjects = NO;
    request.redirectAllowed = NO;
    request.asynchronous = YES;

    [self resetReachabilityStatus];

    // Add locale to session
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSInteger dividerPosition = [currentLanguage rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"_-"]].location;
    if (dividerPosition != NSNotFound) {
        currentLanguage = [currentLanguage substringToIndex:dividerPosition];
    }
    NSString *currentLocale = [[JSConstants sharedInstance].REST_JRS_LOCALE_SUPPORTED objectForKey:currentLanguage];

    [request addParameter:kJSAuthenticationUsernameKey      withStringValue:username];
    [request addParameter:kJSAuthenticationPasswordKey      withStringValue:password];
    [request addParameter:kJSAuthenticationOrganizationKey  withStringValue:organization];
    [request addParameter:kJSAuthenticationTimezoneKey      withStringValue:[[NSTimeZone localTimeZone] name]];
    [request addParameter:kJSAuthenticationLocaleKey withStringValue:currentLocale];

    if (requestMethod == RKRequestMethodPOST) {
        self.restKitObjectManager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    }

    [request setCompletionBlock:^(JSOperationResult *result) {
            BOOL isTokenFetchedSuccessful;
            switch (result.statusCode) {
                case 401: // Unauthorized
                case 403: { // Forbidden
                    isTokenFetchedSuccessful = NO;
                    break;
                }
                case 302: { // redirect
                    BOOL isErrorRedirect = NO;
                    // TODO: move handle of this error to up
                    NSString *location = result.allHeaderFields[@"Location"];
                    if (location) {
                        NSRange errorStringRange = [location rangeOfString:@"error"];
                        isErrorRedirect = errorStringRange.length > 0;
                    }
                    isTokenFetchedSuccessful = !result.error && !isErrorRedirect;
                    break;
                }
                default: {
                    isTokenFetchedSuccessful = (!result.error);
                }
            }
            if (completion) {
                completion(isTokenFetchedSuccessful);
            }
        }];
    [self sendRequest:request];
}

- (void)authenticateWithCompletion:(void(^)(BOOL isSuccess))completion
{
    NSString *username = self.serverProfile.username;
    NSString *password = self.serverProfile.password;
    NSString *organization = self.serverProfile.organization;

    __weak typeof(self)weakSelf = self;
    [self fetchEncryptionKeyWithCompletion:^(NSString *modulus, NSString *exponent, NSError *error) {
        NSString *encPassword = password;
        if (modulus && exponent) {
            JSEncryptionManager *encryptionManager = [JSEncryptionManager new];
            encPassword = [encryptionManager encryptText:password
                                             withModulus:modulus
                                                exponent:exponent];
        }

        __strong typeof(self)strongSelf = weakSelf;
        [strongSelf fetchAuthenticationTokenWithUsername:username
                                          password:encPassword
                                      organization:organization
                                            method:RKRequestMethodPOST // TODO: make select method
                                        completion:^(BOOL isTokenFetchedSuccessful) {
                                            strongSelf.restKitObjectManager.requestSerializationMIMEType = RKMIMETypeJSON;
                                            if (completion) {
                                                completion(isTokenFetchedSuccessful);
                                            }
                                        }];
        }];
}

@end
