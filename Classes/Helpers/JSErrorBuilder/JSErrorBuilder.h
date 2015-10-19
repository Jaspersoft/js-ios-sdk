//
// Created by Aleksandr Dakhno on 10/16/15.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, JSErrorCode) {
    JSErrorCodeUndefined                = -1,
    JSServerNotReachableErrorCode       = 1000,         // Server not reachable error
    JSNetworkErrorCode                  = 1001,         // HTTP erorrs (status codes 404, 500).
    JSRequestTimeOutErrorCode           = 1002,         // Request TimeOut error
    JSInvalidCredentialsErrorCode       = 1003,         // Invalid Credentilas error
    JSSessionExpiredErrorCode           = 1004,         // Session expired error
    JSClientErrorCode                   = 1005,         // Client error code - when JSErrorDescriptor are received
    JSDataMappingErrorCode              = 1006,         // Data Mapping error code - when responce did load successfully, but can't be parsed
    JSFileSavingErrorCode               = 1007,         // Write to file and file saving error
    JSOtherErrorCode                    = 1008          // All other errors
};

NSString * const JSErrorDomain;
NSString * const JSHTTPErrorDomain;
NSString * const JSAuthErrorDomain;


@interface JSErrorBuilder : NSObject
+ (instancetype)sharedBuilder;

- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message;
- (NSError *)httpErrorWithCode:(NSInteger)code message:(NSString *)message;
- (NSError *)authErrorWithCode:(NSInteger)code message:(NSString *)message;
- (NSError *)networkErrorWithCode:(NSInteger)code message:(NSString *)message;
@end