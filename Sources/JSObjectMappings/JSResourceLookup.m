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
//  JSResourceLookup.m
//  Jaspersoft Corporation
//

#import "JSResourceLookup.h"
#import "JSServerInfo.h"

NSString * const kJSResourceLookupLabel = @"kJSResourceLookupLabel";
NSString * const kJSResourceLookupURI = @"kJSResourceLookupURI";
NSString * const kJSResourceLookupResourceDescription = @"kJSResourceLookupResourceDescription";
NSString * const kJSResourceLookupResourceType = @"kJSResourceLookupResourceType";
NSString * const kJSResourceLookupVersion = @"kJSResourceLookupVersion";
NSString * const kJSResourceLookupPermissionMask = @"kJSResourceLookupPermissionMask";
NSString * const kJSResourceLookupCreationDate = @"kJSResourceLookupCreationDate";
NSString * const kJSResourceLookupUpdateDate = @"kJSResourceLookupUpdateDate";

@implementation JSResourceLookup

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"label": @"label",
                                               @"uri": @"uri",
                                               @"description": @"resourceDescription",
                                               @"resourceType": @"resourceType",
                                               @"version": @"version",
                                               @"permissionMask": @"permissionMask"
                                               }];
        [mapping mapKeyPath:@"creationDate" toProperty:@"creationDate" withDateFormatter:[serverProfile.serverInfo serverDateFormatFormatter]];
        [mapping mapKeyPath:@"updateDate" toProperty:@"updateDate" withDateFormatter:[serverProfile.serverInfo serverDateFormatFormatter]];
    }];
}

+ (nonnull NSString *)requestObjectKeyPath {
    return @"resourceLookup";
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    if ([self isMemberOfClass: [JSResourceLookup class]]) {
        JSResourceLookup *newResourceLookup     = [[self class] allocWithZone:zone];
        newResourceLookup.label                 = [self.label  copyWithZone:zone];
        newResourceLookup.uri                   = [self.uri copyWithZone:zone];
        newResourceLookup.resourceDescription   = [self.resourceDescription copyWithZone:zone];
        newResourceLookup.resourceType          = [self.resourceType copyWithZone:zone];
        newResourceLookup.version               = [self.version copyWithZone:zone];
        newResourceLookup.permissionMask        = [self.permissionMask copyWithZone:zone];
        newResourceLookup.creationDate          = [self.creationDate copyWithZone:zone];
        newResourceLookup.updateDate            = [self.updateDate copyWithZone:zone];

        return newResourceLookup;
    } else {
        NSString *messageString = [NSString stringWithFormat:@"You need to implement \"copyWithZone:\" method in %@",NSStringFromClass([self class])];
        @throw [NSException exceptionWithName:@"Method implementation is missing" reason:messageString userInfo:nil];
    }
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_label forKey:kJSResourceLookupLabel];
    [aCoder encodeObject:_uri forKey:kJSResourceLookupURI];
    [aCoder encodeObject:_resourceDescription forKey:kJSResourceLookupResourceDescription];
    [aCoder encodeObject:_resourceType forKey:kJSResourceLookupResourceType];
    [aCoder encodeObject:_version forKey:kJSResourceLookupVersion];
    [aCoder encodeObject:_permissionMask forKey:kJSResourceLookupPermissionMask];
    [aCoder encodeObject:_creationDate forKey:kJSResourceLookupCreationDate];
    [aCoder encodeObject:_updateDate forKey:kJSResourceLookupUpdateDate];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.label = [aDecoder decodeObjectForKey:kJSResourceLookupLabel];
        self.uri = [aDecoder decodeObjectForKey:kJSResourceLookupURI];
        self.resourceDescription = [aDecoder decodeObjectForKey:kJSResourceLookupResourceDescription];
        self.resourceType = [aDecoder decodeObjectForKey:kJSResourceLookupResourceType];
        self.version = [aDecoder decodeObjectForKey:kJSResourceLookupVersion];
        self.permissionMask = [aDecoder decodeObjectForKey:kJSResourceLookupPermissionMask];
        self.creationDate = [aDecoder decodeObjectForKey:kJSResourceLookupCreationDate];
        self.updateDate = [aDecoder decodeObjectForKey:kJSResourceLookupUpdateDate];

    }
    return self;
}

@end
