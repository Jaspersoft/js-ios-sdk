/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @since 2.3
 */

#import <Foundation/Foundation.h>
#import "JSConstants.h"

extern NSString * const JSHTTPErrorResponseStatusKey;

@interface JSErrorBuilder : NSObject

+ (NSError *)errorWithCode:(JSErrorCode)code;
+ (NSError *)errorWithCode:(JSErrorCode)code message:(NSString *)message;

+ (NSError *)httpErrorWithCode:(JSErrorCode)code HTTPCode:(NSInteger)HTTPcode;

@end
