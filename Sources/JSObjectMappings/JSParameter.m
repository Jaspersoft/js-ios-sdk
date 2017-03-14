/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSParameter.h"

@implementation JSParameter

- (nonnull instancetype)initWithName:(NSString *)name value:(id)value {
    if (self = [super init]) {
        self.name = name;
        self.value = value;
    }
    return self;
}

+ (nonnull instancetype)parameterWithName:(nonnull NSString *)name value:(nullable id)value {
    return [[[self class] alloc] initWithName:name value:value];
}

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"name": @"name",
                                               @"value": @"value",
                                               }];
    }];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    JSParameter *parameter = [[self class] allocWithZone:zone];
    parameter.name = [self.name copyWithZone:zone];
    parameter.value = [self.value copyWithZone:zone];
    return parameter;
}
@end
