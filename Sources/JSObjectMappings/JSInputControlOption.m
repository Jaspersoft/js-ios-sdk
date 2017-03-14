/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSInputControlOption.h"

@implementation JSInputControlOption

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"label": @"label",
                                               @"value": @"value",
                                               @"selected": @"selected",
                                               }];
        
    }];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSInputControlOption *newInputControlOption = [[self class] allocWithZone:zone];
    newInputControlOption.label     = [self.label copyWithZone:zone];
    newInputControlOption.value     = [self.value copyWithZone:zone];
    newInputControlOption.selected  = self.selected;
    return newInputControlOption;
}
@end
