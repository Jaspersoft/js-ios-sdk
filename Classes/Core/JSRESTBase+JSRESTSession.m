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

    [request setCompletionBlock:@weakself(^(JSOperationResult *result)) {
            NSData *jsonData = result.body;
            if (jsonData) {
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
                if (json) {
                    NSString *modulus = json[@"n"];
                    NSString *exponent = json[@"e"];
                    if (completion && modulus && exponent) {
                        completion(modulus, exponent, nil);
                    }
                } else {
                    if (completion) {
                        completion(nil, nil, jsonError);
                    }
                }
            } else {
                if (completion) {
                    completion(nil, nil, result.error);
                }
            }
        } @weakselfend];

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

//        request.multipartFormConstructingBodyBlock = ^(id <AFMultipartFormData> formData) {
//            // username
//            NSData *usernameData = [username dataUsingEncoding:NSUTF8StringEncoding];
//            [formData appendPartWithFormData:usernameData name:kJSAuthenticationUsernameKey];
//            // password
//            NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
//            [formData appendPartWithFormData:passwordData name:kJSAuthenticationPasswordKey];
//            // organization
//            NSData *organizationData = [organization dataUsingEncoding:NSUTF8StringEncoding];
//            [formData appendPartWithFormData:organizationData name:kJSAuthenticationOrganizationKey];
//            // time zone
//            NSData *timeZoneData = [[[NSTimeZone localTimeZone] name] dataUsingEncoding:NSUTF8StringEncoding];
//            [formData appendPartWithFormData:timeZoneData name:kJSAuthenticationTimezoneKey];
//            // locale
//            NSData *localeData = [currentLocale dataUsingEncoding:NSUTF8StringEncoding];
//            [formData appendPartWithFormData:localeData name:kJSAuthenticationLocaleKey];
//        };
    }

    [request setCompletionBlock:@weakself(^(JSOperationResult *result)) {
            BOOL isTokenFetchedSuccessful = NO;
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
        } @weakselfend];
    [self sendRequest:request];
}

- (void)authenticateWithCompletion:(void(^)(BOOL isSuccess))completion
{
    NSString *username = self.serverProfile.username;
    NSString *password = self.serverProfile.password;
    NSString *organization = self.serverProfile.organization;

    [self fetchEncryptionKeyWithCompletion:@weakself(^(NSString *modulus, NSString *exponent, NSError *error)) {
            NSString *encPassword = password;
            if (modulus && exponent) {
                JSEncryptionManager *encryptionManager = [JSEncryptionManager managerWithModulus:modulus
                                                                                        exponent:exponent];
                encPassword = [encryptionManager encryptText:password];
            }

            [self fetchAuthenticationTokenWithUsername:username
                                              password:encPassword
                                          organization:organization
                                                method:RKRequestMethodPOST // TODO: make select method
                                            completion:@weakself(^(BOOL isTokenFetchedSuccessful)) {
                                                    self.restKitObjectManager.requestSerializationMIMEType = RKMIMETypeJSON;
                                                    if (completion) {
                                                        completion(isTokenFetchedSuccessful);
                                                    }
                                                }@weakselfend];
        }@weakselfend];
}

@end
