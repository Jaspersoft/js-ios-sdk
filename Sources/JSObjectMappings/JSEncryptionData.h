/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */


#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"


@interface JSEncryptionData : NSObject<JSObjectMappingsProtocol>

@property (nonatomic, strong, nullable) NSString *modulus;
@property (nonatomic, strong, nullable) NSString *exponent;
@property (nonatomic, strong, nullable) NSString *maxdigits;

@end
