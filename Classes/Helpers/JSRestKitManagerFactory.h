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
//  JSRestKitManagerFactory.h
//  Jaspersoft Corporation
//

#import <RestKit/RestKit.h>
#import <Foundation/Foundation.h>

/** 
 @cond EXCLUDE_JS_REST_KIT_MANAGER_FACTORY

 Helps to create and set define mapping rules for RestKit's RKObjectManager class.
 The object manager is the primary interface for interacting with JasperReports 
 Server REST API resources via HTTP
 
 @author Volodya Sabadosh vsabadosh@jaspersoft.com
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.3
 */
@interface JSRestKitManagerFactory : NSObject

/** 
 Creates and configures RKObjectManager instance with mapping rules for specified 
 classes.
 
 Class mapping rule describes how returned HTTP response (in JSON, XML and other
 formats) should be mapped directly to this class.
 
 @param classes A list of classes for which mapping rules will be created
 @return A configured object manager
 */
+ (RKObjectManager *)createRestKitObjectManagerForClasses:(NSArray *)classes;

@end

/** @endcond */
