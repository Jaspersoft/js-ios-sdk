//
// Created by Aleksandr Dakhno on 10/16/15.
//

#import "JSErrorBuilder.h"

NSString * const JSErrorDomain = @"JSErrorDomain";
NSString * const JSHTTPErrorDomain = @"JSHTTPErrorDomain";
NSString * const JSAuthErrorDomain = @"JSAuthErrorDomain";

NSString * const JSHTTPErrorResponseStatusKey = @"JSHTTPErrorResponseStatusKey";

@implementation JSErrorBuilder

+ (instancetype)sharedBuilder
{
    static JSErrorBuilder *sharedBuilder;
    static dispatch_once_t token_once;

    dispatch_once(&token_once, ^{
        sharedBuilder = [self new];
    });

    return sharedBuilder;
}


#pragma mark - Public API
- (NSError *)errorWithCode:(JSErrorCode)code message:(NSString *)message
{
    return [self createErrorWithDomain:JSErrorDomain
                             errorCode:code
                               message:message];
}

- (NSError *)httpErrorWithCode:(JSErrorCode)code HTTPCode:(NSInteger)HTTPcode message:(NSString *)message
{
    NSString *errorDescription = message ?: [NSHTTPURLResponse localizedStringForStatusCode:HTTPcode];

    return [self createErrorWithDomain:JSHTTPErrorDomain
                             errorCode:code
                               message:errorDescription
                              userInfo:@{JSHTTPErrorResponseStatusKey : @(HTTPcode)}];
}

- (NSError *)authErrorWithCode:(JSErrorCode)code message:(NSString *)message
{
    return [self createErrorWithDomain:JSAuthErrorDomain
                             errorCode:code
                               message:message];
}

- (NSError *)networkErrorWithCode:(JSErrorCode)code message:(NSString *)message
{
    return [self createErrorWithDomain:NSURLErrorDomain
                             errorCode:code
                               message:message];
}

#pragma mark - Private API
- (NSError *)createErrorWithDomain:(NSString *)domain errorCode:(NSInteger)errorCode message:(NSString *)message
{
    return [self createErrorWithDomain:domain
                             errorCode:errorCode
                               message:message
                              userInfo:nil];
}

- (NSError *)createErrorWithDomain:(NSString *)domain
                         errorCode:(NSInteger)errorCode
                           message:(NSString *)message
                          userInfo:(NSDictionary *)usrInfo
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:usrInfo];
    if (message) {
        userInfo[NSLocalizedDescriptionKey] = message;
    }
    NSError *error = [NSError errorWithDomain:domain
                                         code:errorCode
                                     userInfo:userInfo];
    return error;
}

@end