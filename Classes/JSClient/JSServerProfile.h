/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2001 - 2012 Jaspersoft Corporation. All rights reserved.
 * http://www.jasperforge.org/projects/mobile
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is part of Jaspersoft Mobile SDK.
 *
 * Jaspersoft Mobile SDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Jaspersoft Mobile SDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FJaspersoft CorpOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Jaspersoft Mobile SDK. If not, see <http://www.gnu.org/licenses/>.
 */

//
//  JSServerProfile.h
//  JaspersoftMobileSDK
//
//  Created by Volodya Sabadosh on 7/3/12.
//  Copyright (c) 2012 Jaspersoft Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSServerProfile : NSObject {
    

}

/** The name used to refer to this JSClient.
 *  The alias is mainly used to display the name of this JSClient in UI (i.e. when displaying a list of available servers).
 */
@property(nonatomic, retain) NSString *alias;

/** The username, must be a valid account on JasperReports Server.
 */
@property(nonatomic, retain) NSString *username;

/** The account password
 */
@property(nonatomic, retain) NSString *password;

/** The name of an organization (used in JasperReport Server Professional which supports multi-tenancy).
 *  Can be nil or empty.
 */
@property(nonatomic, retain) NSString *organization;

/** The URL of JasperReports Server. The url does not include the /rest/ portion of the uri, i.e. http://hostname:port/jasperserver
 */
@property(nonatomic, retain) NSString *baseUrl;

/** Creates a new JSServerProfile with the specified alias.
 */
- (id)initWithAlias:(NSString *)theAlias Username:(NSString *)user Password:(NSString *)pass Organization:(NSString *)org Url:(NSString *)url;

- (NSString *)getUsernameWithOrgId;

@end
