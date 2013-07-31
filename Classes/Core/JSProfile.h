/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2013 Jaspersoft Corporation. All rights reserved.
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
//  JSProfile.h
//  Jaspersoft Corporation
//

#import "JSServerInfo.h"
#import <Foundation/Foundation.h>

/** 
 Uses to store connection details for JasperReports server
 
 @author Volodya Sabadosh vsabadosh@jaspersoft.com
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.1
 */
@interface JSProfile : NSObject <NSCopying>

/**
 The name used to refer to this profile. 
 The alias is mainly used to display profile's name in UI (i.e. when displays 
 a list of available servers)
 */
@property (nonatomic, retain) NSString *alias;

/**
 The URL of JasperReports Server. 
 URL should match next pattern http://hostname:port/jasperserver
 port parameter is not required (i.e. http://mobiledemo.jaspersoft.com/jasperserver-pro)
 */
@property (nonatomic, retain) NSString *serverUrl;

/**
 The username, must be a valid account on JasperReports Server
 */
@property (nonatomic, retain) NSString *username;

/**
 The account password
 */
@property (nonatomic, retain) NSString *password;

/**
 The name of an organization. Used in JasperReport Server Professional 
 which supports multi-tenancy. May be <code>nil</code> or empty
 */
@property (nonatomic, retain) NSString *organization;

/**
 The version of JasperReports server 
 */
@property (nonatomic, retain) JSServerInfo *serverInfo;

/**
 Returns a profile with the specified parameters
 
 @param alias The association name for server profile
 @param username The valid server account username
 @param password The account password
 @param organization The server organization. May be <code>nil</code> or empty
 @param serverUrl The serverUrl. Should match pattern http://hostname:port/jasperserver 
 (port is not required)
 @return A configured JSProfile instance
 */
- (id)initWithAlias:(NSString *)alias username:(NSString *)username password:(NSString *)password 
      organization:(NSString *)organization serverUrl:(NSString *)serverUrl;

/**
 Returns account username includes server organization id (separated by | symbol) 
 if id is not <code>nil</code> or empty. Otherwise returns only account username
 
 @return A new string contains server account username and server organization id
 */
- (NSString *)getUsenameWithOrganization;

@end
