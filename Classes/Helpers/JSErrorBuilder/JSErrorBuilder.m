//
// Created by Aleksandr Dakhno on 10/16/15.
//

#import "JSErrorBuilder.h"

NSString * const JSErrorDomain = @"JSErrorDomain";
NSString * const JSHTTPErrorDomain = @"JSHTTPErrorDomain";
NSString * const JSAuthErrorDomain = @"JSAuthErrorDomain";

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
- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message
{
    return [self createErrorWithDomain:JSErrorDomain
                             errorCode:code
                               message:message];
}

- (NSError *)httpErrorWithCode:(NSInteger)code message:(NSString *)message
{
    NSString *errorDescription = message ?: [NSHTTPURLResponse localizedStringForStatusCode:code];

    return [self createErrorWithDomain:JSHTTPErrorDomain
                             errorCode:code
                               message:errorDescription];
}

- (NSError *)authErrorWithCode:(NSInteger)code message:(NSString *)message
{
    return [self createErrorWithDomain:JSAuthErrorDomain
                             errorCode:code
                               message:message];
}

- (NSError *)networkErrorWithCode:(NSInteger)code message:(NSString *)message
{
    return [self createErrorWithDomain:NSURLErrorDomain
                             errorCode:code
                               message:message];
}

#pragma mark - Private API
- (NSError *)createErrorWithDomain:(NSString *)domain errorCode:(NSInteger)errorCode message:(NSString *)message
{
    NSDictionary *userInfo;
    if (message) {
        userInfo = @{
                NSLocalizedDescriptionKey : message
        };
    }
    NSError *error = [NSError errorWithDomain:domain
                                         code:errorCode
                                     userInfo:userInfo];
    return error;
}

@end