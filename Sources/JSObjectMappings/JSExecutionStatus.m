/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSExecutionStatus.h"

@implementation JSExecutionStatus

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        NSDictionary *statusesStringRepresentation = @{ @"ready"    : @(kJS_EXECUTION_STATUS_READY),
                                                        @"queued"   : @(kJS_EXECUTION_STATUS_QUEUED),
                                                        @"execution": @(kJS_EXECUTION_STATUS_EXECUTION),
                                                        @"cancelled": @(kJS_EXECUTION_STATUS_CANCELED),
                                                        @"failed"   : @(kJS_EXECUTION_STATUS_FAILED)
                                                        };
        [mapping mapKeyPath:@"value" toProperty:@"status" withValueBlock:^(NSString *key, id value) {
            return statusesStringRepresentation[value];
        } reverseBlock:^id(id value) {
            return [statusesStringRepresentation allKeysForObject:value].lastObject;
        }];
    }];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[JSExecutionStatus class]]) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    return self.status == [object status];
}

@end
