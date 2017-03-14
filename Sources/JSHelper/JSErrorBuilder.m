/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


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

        case JSAccessDeniedErrorCode:
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
            return JSCustomLocalizedString(@"error_http_502", nil);
        case JSRequestTimeOutErrorCode:
            return JSCustomLocalizedString(@"error_http_504", nil);
        case JSInvalidCredentialsErrorCode:
        case JSAccessDeniedErrorCode:
            return JSCustomLocalizedString(@"error_http_403", nil);
        case JSSessionExpiredErrorCode:
            return JSCustomLocalizedString(@"error_http_401", nil);
        case JSClientErrorCode:
            return JSCustomLocalizedString(@"error_reading_response_msg", nil);
        case JSDataMappingErrorCode:
            return JSCustomLocalizedString(@"error_data_mapping_msg", nil);
        case JSFileSavingErrorCode:
            return JSCustomLocalizedString(@"error_file_saving_msg", nil);
        case JSServerVersionNotSupportedErrorCode:
            return JSCustomLocalizedString(@"error_server_version_not_supported", nil);
        case JSUnsupportedAcceptTypeErrorCode:
            return JSCustomLocalizedString(@"error_accept_type_not_supported", nil);
        default:
            return JSCustomLocalizedString(@"error_other_msg", nil);
    }
}

@end
