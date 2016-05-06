/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2015 Jaspersoft Corporation. All rights reserved.
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
//  JSContentResource.m
//  Jaspersoft Corporation
//

#import "JSContentResource.h"

NSString * const kJSContentResourceFileFormat = @"kJSContentResourceFileFormat";
NSString * const kJSContentResourceContent = @"kJSContentResourceContent";

@implementation JSContentResource

#pragma mark - JSObjectMappingsProtocol

+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    EKObjectMapping *mapping = [super objectMappingForServerProfile:serverProfile];
    [mapping mapPropertiesFromDictionary:@{
                                           @"type": @"fileFormat",
                                           @"content": @"content"
                                           }];
    return mapping;
}

+ (nonnull NSString *)requestObjectKeyPath {
    return @"contentResource";
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSContentResource *newResource  = [super copyWithZone:zone];
    newResource.fileFormat  = [self.fileFormat copyWithZone:zone];
    newResource.content     = [self.content copyWithZone:zone];
    
    return newResource;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:_fileFormat forKey:kJSContentResourceFileFormat];
    [aCoder encodeObject:_content forKey:kJSContentResourceContent];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.fileFormat = [aDecoder decodeObjectForKey:kJSContentResourceFileFormat];
        self.content = [aDecoder decodeObjectForKey:kJSContentResourceContent];
    }
    return self;
}
@end