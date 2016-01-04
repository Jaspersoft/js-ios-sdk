//
// Created by Aleksandr Dakhno on 10/16/15.
//

#import <Foundation/Foundation.h>
#import "JSConstants.h"

extern NSString * const JSHTTPErrorResponseStatusKey;

@interface JSErrorBuilder : NSObject

+ (NSError *)errorWithCode:(JSErrorCode)code;
+ (NSError *)errorWithCode:(JSErrorCode)code message:(NSString *)message;

+ (NSError *)httpErrorWithCode:(JSErrorCode)code HTTPCode:(NSInteger)HTTPcode;

@end