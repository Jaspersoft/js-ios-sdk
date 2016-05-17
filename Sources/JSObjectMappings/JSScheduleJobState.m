/*
 * TIBCO JasperMobile for iOS
 * Copyright © 2005-2016 TIBCO Software, Inc. All rights reserved.
 * http://community.jaspersoft.com/project/jaspermobile-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/lgpl>.
 */


//
//  JSScheduleJobState.h
//  TIBCO JasperMobile
//

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