/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSInputControlState.h"

@implementation JSInputControlState

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"id": @"uuid",
                                               @"uri": @"uri",
                                               @"value": @"value",
                                               @"error": @"error",
                                               }];
        [mapping hasMany:[JSInputControlOption class] forKeyPath:@"options" forProperty:@"options" withObjectMapping:[JSInputControlOption objectMappingForServerProfile:serverProfile]];
        
    }];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSInputControlState *newInputControlState = [[self class] allocWithZone:zone];
    newInputControlState.uuid       = [self.uuid copyWithZone:zone];
    newInputControlState.uri        = [self.uri copyWithZone:zone];
    newInputControlState.value      = [self.value copyWithZone:zone];
    newInputControlState.error      = [self.error copyWithZone:zone];
    if (self.options) {
        newInputControlState.options    = [[NSArray alloc] initWithArray:self.options copyItems:YES];
    }
    return newInputControlState;
}
@end
