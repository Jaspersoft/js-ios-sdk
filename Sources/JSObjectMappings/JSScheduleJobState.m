/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSScheduleJobState.h"
#import "JSServerInfo.h"
#import "JSDateFormatterFactory.h"


@implementation JSScheduleJobState

#pragma mark - JSObjectMappingsProtocol

+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"value": @"value",
                                               }];

        id(^valueBlock)(NSString *key, id value) = ^id(NSString *key, id value) {
            if (value == nil)
                return nil;

            if (![value isKindOfClass:[NSString class]]) {
                return [NSNull null];
            }

            NSMutableArray *formattersArray = [NSMutableArray array];
            [formattersArray addObject:[[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"]];
            [formattersArray addObject:[[JSDateFormatterFactory sharedFactory] formatterWithPattern:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"]];
            [formattersArray addObject:serverProfile.serverInfo.serverDateFormatFormatter];

            for (NSDateFormatter *formatter in formattersArray) {
                NSDate *date = [formatter dateFromString:value];
                if (date) {
                    return date;
                }
            }
            return nil;
        };

        id(^reverseBlock)(id value) = ^id(id value) {
            if (value == nil)
                return nil;

            if (![value isKindOfClass:[NSDate class]]) {
                return [NSNull null];
            }

            NSDateFormatter *formatter = [serverProfile.serverInfo serverDateFormatFormatter];
            NSString *string = [formatter stringFromDate:value];
            return string;
        };

        [mapping mapKeyPath:@"nextFireTime"
                 toProperty:@"nextFireTime"
             withValueBlock:valueBlock
               reverseBlock:reverseBlock];

        [mapping mapKeyPath:@"previousFireTime"
                 toProperty:@"previousFireTime"
             withValueBlock:valueBlock
               reverseBlock:reverseBlock];
    }];
}

@end
