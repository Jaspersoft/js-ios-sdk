//
// Created by Aleksandr Dakhno on 10/16/15.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, JSErrorCode) {
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

@interface JSErrorBuilder : NSObject
@end