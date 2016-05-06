/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2014 Jaspersoft Corporation. All rights reserved.
 * http://community.jaspersoft.com/project/mobile-sdk-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is part of Jaspersoft Mobile SDK for iOS.
 *
 * Jaspersoft Mobile SDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Jaspersoft Mobile SDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Jaspersoft Mobile SDK for iOS. If not, see
 * <http://www.gnu.org/licenses/lgpl>.
 */

//
//  JSReportOption.m
//  Jaspersoft Corporation
//

#import "JSReportOption.h"
#import "JSMandatoryValidationRule.h"
#import "JSDateTimeFormatValidationRule.h"

@implementation JSReportOption

+ (JSReportOption *)defaultReportOption
{
    JSReportOption *reportOption = [JSReportOption new];
    reportOption.label = JSCustomLocalizedString(@"report.options.default.option.title", nil);
    return reportOption;
}

- (BOOL)isEqual:(nullable id)object
{
    if (![self isKindOfClass:[object class]]) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    
    if ((self.uri == [object uri] || [self.uri isEqualToString:[object uri]]) && (self.label == [object label] || [self.label isEqualToString:[object label]])) {
        return YES;
    }
    return NO;
}

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"id": @"identifier",
                                               @"uri": @"uri",
                                               @"label": @"label"
                                               }];
    }];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    if ([self isMemberOfClass: [JSReportOption class]]) {
        JSReportOption *newReportOption = [[self class] allocWithZone:zone];
        newReportOption.uri             = [self.uri copyWithZone:zone];
        newReportOption.label           = [self.label copyWithZone:zone];
        newReportOption.identifier      = [self.identifier copyWithZone:zone];
        newReportOption.inputControls   = [[NSArray alloc] initWithArray:self.inputControls copyItems:YES];

        return newReportOption;
    } else {
        NSString *messageString = [NSString stringWithFormat:@"You need to implement \"copyWithZone:\" method in %@",NSStringFromClass([self class])];
        @throw [NSException exceptionWithName:@"Method implementation is missing" reason:messageString userInfo:nil];
    }
}
@end
