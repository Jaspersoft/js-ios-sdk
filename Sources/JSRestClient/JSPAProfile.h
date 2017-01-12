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
//  JSPAProfile.h
//  Jaspersoft Corporation
//

/**
 Uses to store connection details for JasperReports server with SSO
 
 @author Alexey Gubarev ogubarie@tibco.com
 @since 2.6
 */

#import "JSProfile.h"

@interface JSPAProfile : JSProfile <NSCopying, NSSecureCoding>

/**
 The PP token, must be a valid token for JasperReports Server
 
 The key-value pairs can appear in the token in any order, but must be delineated by the separator specified
 in the 'tokenPairSeparator' property:
 • u — Takes a single value that maps to the username in JasperReports Server.
 • r — Takes as values a comma- separated list of roles; each entry in the list is mapped to a separate role in
 JasperReports Server. If you have defined default internal roles, this parameter is optional.
 • o — Takes as values a comma- separated list that maps to an organization in the JasperReports Server. If
 more than one organization is listed, it is interpreted as an organization hierarchy. For example, o=A, B maps
 the user to the B suborganization of A.
 • exp — Takes a single time value formatted as configured in the 'tokenExpireTimestampFormat' property.
 If exp is before the current time, user authentication is denied; if it is absent, the token never expires.
 • pa1 — Profile attribute that maps to 'profileAttrib1' in the JasperReports Server repository.
 • pa2 — Profile attribute that maps to 'profileAttrib2' in the JasperReports Server repository.
 */
@property (nonatomic, readonly, nonnull) NSString *ppToken;

/**
 The PP token field, must be a valid token for JasperReports Server. Default parameter name for a pre authentication token is "pp". This parameter name can be changed via Spring configuration in corresponding applicationContext-externalAuth-preAuth.xml
 */
@property (nonatomic, nonnull) NSString *ppTokenField;

/**
 Returns a profile with the specified parameters
 
 @param alias The association name for server profile
 @param serverUrl The serverUrl. Should match pattern http://hostname:port/jasperserver (port is not required)
 @param ppToken The pre authentication token
 @return A configured JSProfile instance
 */
- (nonnull instancetype)initWithAlias:(nonnull NSString *)alias serverUrl:(nonnull NSString *)serverUrl ppToken:(nullable NSString *)ppToken;

@end
