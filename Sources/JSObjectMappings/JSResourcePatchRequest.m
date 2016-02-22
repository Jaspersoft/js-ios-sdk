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
//  JSResourcePatchRequest.m
//  Jaspersoft Corporation
//

#import "JSResourcePatchRequest.h"
#import "JSResourceParameter.h"

@interface JSResourcePatchRequest()
@property (nonatomic, strong, nonnull) NSNumber *version;
@property (nonatomic, strong, nonnull) NSArray *patch;
@end

@implementation JSResourcePatchRequest

- (nonnull instancetype)initWithResource:(nonnull JSResourceLookup *)resource {
    self = [super init];
    if (self) {
        self.version = resource.version;
        self.patch = [self patchesArrayFromResource:resource];
    }
    return self;
}

+ (nonnull instancetype)patchRecuestWithResource:(nonnull JSResourceLookup *)resource {
    return [[[self class] alloc] initWithResource:resource];
}

#pragma mark - EKMappingProtocol

//+ (nonnull NSArray <RKRequestDescriptor *> *)rkRequestDescriptorsForServerProfile:(nonnull JSProfile *)serverProfile {
//    NSMutableArray *descriptorsArray = [NSMutableArray array];
//    [descriptorsArray addObject:[RKRequestDescriptor requestDescriptorWithMapping:[[self classMappingForServerProfile:serverProfile] inverseMapping]
//                                                                      objectClass:self
//                                                                      rootKeyPath:nil
//                                                                           method:JSRequestHTTPMethodAny]];
//    
//    return descriptorsArray;
//}
//
//+ (nonnull RKObjectMapping *)classMappingForServerProfile:(nonnull JSProfile *)serverProfile {
//    RKObjectMapping *classMapping = [RKObjectMapping mappingForClass:self];
//    [classMapping addAttributeMappingsFromDictionary:@{
//                                                       @"version": @"version"
//                                                       }];
//    [classMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"patch"
//                                                                                 toKeyPath:@"patch"
//                                                                               withMapping:[JSResourceParameter classMappingForServerProfile:serverProfile]]];
//
//    return classMapping;
//}
//
//+ (NSArray<RKResponseDescriptor *> *)rkResponseDescriptorsForServerProfile:(JSProfile *)serverProfile {
//    return [JSResourceLookup rkResponseDescriptorsForServerProfile:serverProfile];
//}

#pragma mark - Private API
- (NSArray *)patchesArrayFromResource:(JSResourceLookup *)resource {
    NSMutableArray *patchesArray = [NSMutableArray array];
    [patchesArray addObject:[JSResourceParameter resourceParameterWithField:@"label" value:resource.label]];
    [patchesArray addObject:[JSResourceParameter resourceParameterWithField:@"description" value:resource.resourceDescription]];
    return [patchesArray copy];
}

@end
