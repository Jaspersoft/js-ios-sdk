//
//  JSProfile.h
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 03.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 
 Uses to store connection details for JasperReports server
 
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
