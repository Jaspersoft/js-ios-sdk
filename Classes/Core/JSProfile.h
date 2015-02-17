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
//  JSProfile.h
//  Jaspersoft Corporation
//

#import <Foundation/Foundation.h>

/** 
 Uses to store connection details for JasperReports server
 
 @author Volodya Sabadosh vsabadosh@jaspersoft.com
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Alexey Gubarev ogubarie@tibco.com
 @since 1.1
 */

@class JSServerInfo;

@interface JSProfile : NSObject <NSCopying, NSSecureCoding>

/**
 The name used to refer to this profile. 
 The alias is mainly used to display profile's name in UI (i.e. when displays 
 a list of available servers)
 */
@property (nonatomic, readonly) NSString *alias;

/**
 The URL of JasperReports Server. 
 URL should match next pattern http://hostname:port/jasperserver
 port parameter is not required (i.e. http://mobiledemo.jaspersoft.com/jasperserver-pro)
 */
@property (nonatomic, readonly) NSString *serverUrl;

/**
 The username, must be a valid account on JasperReports Server
 */
@property (nonatomic, readonly) NSString *username;

/**
 The account password
 */
@property (nonatomic, readonly) NSString *password;

/**
 The name of an organization. Used in JasperReport Server Professional 
 which supports multi-tenancy. May be <code>nil</code> or empty
 */
@property (nonatomic, readonly) NSString *organization;

/**
 The version of JasperReports server 
 */
@property (nonatomic, strong) JSServerInfo *serverInfo;

/**
 Returns a profile with the specified parameters
 
 @param alias The association name for server profile
 @param serverUrl The serverUrl. Should match pattern http://hostname:port/jasperserver (port is not required)
 @param organization The server organization. May be <code>nil</code> or empty

 @return A configured JSProfile instance
 */
- (id)initWithAlias:(NSString *)alias serverUrl:(NSString *)serverUrl organization:(NSString *)organization;

/**
 Returns account username includes server organization id (separated by | symbol) 
 if id is not <code>nil</code> or empty. Otherwise returns only account username
 
 @return A new string contains server account username and server organization id
 */
- (NSString *)getUsernameWithOrganization;


/**
 Set Username and password
 
 @param username The valid server account username
 @param password The account password
 @since 1.9
 */
- (void)setCredentialsWithUsername:(NSString *)username password:(NSString *)password;
@end
