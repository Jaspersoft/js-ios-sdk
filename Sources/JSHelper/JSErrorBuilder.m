/*
 * TIBCO JasperMobile for iOS
 * Copyright © 2005-2016 TIBCO Software, Inc. All rights reserved.
 * http://community.jaspersoft.com/project/jaspermobile-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/lgpl>.
 */


//
//  JSErrorBuilder.m
//  TIBCO JasperMobile
//

#import "JSErrorBuilder.h"

NSString * const JSHTTPErrorResponseStatusKey = @"JSHTTPErrorResponseStatusKey";

@implementation JSErrorBuilder

#pragma mark - Public API

+ (NSError *)errorWithCode:(JSErrorCode)code {
    return [self errorWithCode:code message:[self localizedMessageForStatusCode:code]];
}

+ (NSError *)errorWithCode:(JSErrorCode)code message:(NSString *)message {
    NSDictionary *userInfo;
    if (message) {
        userInfo = @{NSLocalizedDescriptionKey : message};
    }
    return [self createErrorWithDomain:[self errorDomainForStatusCode:code]
                             errorCode:code
                              userInfo:userInfo];
}

+ (NSError *)httpErrorWithCode:(JSErrorCode)code HTTPCode:(NSInteger)HTTPcode {

    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : [NSHTTPURLResponse localizedStringForStatusCode:HTTPcode],
                               JSHTTPErrorResponseStatusKey : @(HTTPcode)};
    
    return [self createErrorWithDomain:JSHTTPErrorDomain
                             errorCode:code
                              userInfo:userInfo];
}

#pragma mark - Private API
+ (NSError *)createErrorWithDomain:(NSString *)domain
                         errorCode:(NSInteger)errorCode
                          userInfo:(NSDictionary *)userInfo {
    NSError *error = [NSError errorWithDomain:domain
                                         code:errorCode
                                     userInfo:userInfo];
    return error;
}

+ (NSString *)errorDomainForStatusCode:(JSErrorCode)errorCode {
    switch (errorCode) {
        case JSInvalidCredentialsErrorCode:
        case JSSessionExpiredErrorCode:
            return JSAuthErrorDomain;
        
        case JSHTTPErrorCode:
        case JSServerNotReachableErrorCode:
        case JSRequestTimeOutErrorCode:
            return JSHTTPErrorDomain;

        case JSClientErrorCode:
        case JSDataMappingErrorCode:
        case JSFileSavingErrorCode:
        case JSServerVersionNotSupportedErrorCode:
        case JSUnsupportedAcceptTypeErrorCode:
        case JSOtherErrorCode:
            return JSErrorDomain;
    }
}

+ (NSString *) localizedMessageForStatusCode:(JSErrorCode)errorCode {
    switch (errorCode) {
        case JSServerNotReachableErrorCode:
            return JSCustomLocalizedString(@"error.http.502", nil);
        case JSRequestTimeOutErrorCode:
            return JSCustomLocalizedString(@"error.http.504", nil);
        case JSInvalidCredentialsErrorCode:
            return JSCustomLocalizedString(@"error.http.403", nil);
        case JSSessionExpiredErrorCode:
            return JSCustomLocalizedString(@"error.http.401", nil);
        case JSClientErrorCode:
            return JSCustomLocalizedString(@"error.reading.response.msg", nil);
        case JSDataMappingErrorCode:
            return JSCustomLocalizedString(@"error.data.mapping.msg", nil);
        case JSFileSavingErrorCode:
            return JSCustomLocalizedString(@"error.file.saving.msg", nil);
        case JSServerVersionNotSupportedErrorCode:
            return JSCustomLocalizedString(@"error.server.version.not.supported", nil);
        case JSUnsupportedAcceptTypeErrorCode:
            return JSCustomLocalizedString(@"error.accept.type.not.supported", nil);
        default:
            return JSCustomLocalizedString(@"error.other.msg", nil);
    }
}

@end