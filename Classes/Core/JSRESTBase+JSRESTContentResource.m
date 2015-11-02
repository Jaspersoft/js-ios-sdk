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
//  JSRESTBase(JSRESTContentResource).h
//  Jaspersoft Corporation
//

#import "JSRESTBase+JSRESTContentResource.h"
#import "JSResourceLookup.h"
#import "JSContentResource.h"
#import "JSRESTBase+JSRESTResource.h"

@implementation JSRESTBase(JSRESTContentResource)

- (void)contentResourceWithResourceLookup:(JSResourceLookup *__nonnull)resourceLookup
                               completion:(void(^ __nonnull)(JSContentResource *resource, NSError *error))completion
{
    [self resourceLookupForURI:resourceLookup.uri
                             resourceType:[JSConstants sharedInstance].WS_TYPE_FILE
                               modelClass:[JSContentResource class]
                          completionBlock:^(JSOperationResult *result) {
                              if (result.error) {
                                  completion(nil, result.error);
                              } else {
                                  JSContentResource *resource = result.objects.firstObject;
                                  if (resource) {
                                      completion(resource, nil);
                                  } else {
                                      // TODO: add error
                                      completion(nil, nil);
                                  }
                              }
                          }];
}

@end
