/*
 * Copyright ©  2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSEncryptionData.h"

@implementation JSEncryptionData

#pragma mark - JSObjectMappingsProtocol

+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{@"e"         : @"exponent",
                                               @"maxdigits" : @"maxdigits",
                                               @"n"         : @"modulus"}];
    }];
}

@end
