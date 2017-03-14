/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSDateTimeFormatValidationRule.h"

@implementation JSDateTimeFormatValidationRule

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"errorMessage": @"errorMessage",
                                               @"format": @"format",
                                               }];
    }];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSDateTimeFormatValidationRule *newDateTimeFormatValidationRule = [[self class] allocWithZone:zone];
    newDateTimeFormatValidationRule.errorMessage    = [self.errorMessage copyWithZone:zone];
    newDateTimeFormatValidationRule.format          = [self.format copyWithZone:zone];
    return newDateTimeFormatValidationRule;
}
@end
