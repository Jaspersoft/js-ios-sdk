//
// Created by Aleksandr Dakhno on 10/16/15.
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
        default:
            return JSCustomLocalizedString(@"error.other.msg", nil);
    }
}

@end