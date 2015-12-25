//
// Created by Aleksandr Dakhno on 10/16/15.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, JSErrorCode) {
    JSErrorCodeUndefined                = -1,

    JSServerNotReachableErrorCode       = 1000,         // Server not reachable error
    JSRequestTimeOutErrorCode           = 1001,         // Request TimeOut error

    JSHTTPErrorCode                     = 1002,         // HTTP erorrs (status codes 404, 500).

    JSInvalidCredentialsErrorCode       = 1003,         // Invalid Credentilas error
    JSSessionExpiredErrorCode           = 1004,         // Session expired error

    JSClientErrorCode                   = 1005,         // Client error code - when JSErrorDescriptor are received

    JSDataMappingErrorCode              = 1006,         // Data Mapping error code - when responce did load successfully, but can't be parsed

    JSFileSavingErrorCode               = 1007,         // Write to file and file saving error

    JSOtherErrorCode                    = 1008          // All other errors
};

extern NSString * const JSErrorDomain;
extern NSString * const JSHTTPErrorDomain;
extern NSString * const JSAuthErrorDomain;

extern NSString * const JSHTTPErrorResponseStatusKey;
#warning NEED REFACTORED SDK FOR ERROR HANDLING!!!

@interface JSErrorBuilder : NSObject
+ (instancetype)sharedBuilder;

- (NSError *)errorWithCode:(JSErrorCode)code message:(NSString *)message;
- (NSError *)httpErrorWithCode:(JSErrorCode)code HTTPCode:(NSInteger)HTTPcode message:(NSString *)message;
- (NSError *)authErrorWithCode:(JSErrorCode)code message:(NSString *)message;
- (NSError *)networkErrorWithCode:(JSErrorCode)code message:(NSString *)message;
@end