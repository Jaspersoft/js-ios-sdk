/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSMandatoryValidationRule.h"

@implementation JSMandatoryValidationRule

#pragma mark - JSObjectMappingsProtocol

+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"errorMessage": @"errorMessage",
                                               }];
    }];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSMandatoryValidationRule *newandatoryValidationRule = [[self class] allocWithZone:zone];
    newandatoryValidationRule.errorMessage = [self.errorMessage copyWithZone:zone];
    return newandatoryValidationRule;
}
@end
