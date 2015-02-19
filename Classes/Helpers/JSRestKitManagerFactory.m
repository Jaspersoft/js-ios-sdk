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
//  JSRestKitManagerFactory.m
//  Jaspersoft Corporation
//


#import "JSRestKitManagerFactory.h"
#import "JSRESTBase.h"
#import "JSConstants.h"

@implementation JSRestKitManagerFactory
+ (RKObjectManager *)createRestKitObjectManagerForServerProfile:(JSProfile *)serverProfile{
    // Creates RKObjectManager for loading and mapping encoded response (i.e XML, JSON etc.)
    // directly to objects
    RKObjectManager *restKitObjectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:serverProfile.serverUrl]];
    [restKitObjectManager.HTTPClient setAuthorizationHeaderWithUsername:serverProfile.username password:serverProfile.password];
    restKitObjectManager.HTTPClient.allowsInvalidSSLCertificate = YES;
    [restKitObjectManager.HTTPClient registerHTTPOperationClass:[AFXMLRequestOperation class]];
    
    // Sets default content-type and charset to object manager
    [restKitObjectManager.HTTPClient setDefaultHeader:kJSRequestCharset value:[JSConstants sharedInstance].REST_SDK_CHARSET_USED];
    restKitObjectManager.requestSerializationMIMEType = [JSConstants sharedInstance].REST_SDK_MIMETYPE_USED;
    [restKitObjectManager setAcceptHeaderWithMIMEType:[JSConstants sharedInstance].REST_SDK_MIMETYPE_USED];
    
    return restKitObjectManager;
}

@end
