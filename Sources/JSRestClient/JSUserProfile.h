/*
 * Copyright © 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.6
 */

#import "JSProfile.h"

/**
 Uses to store connection details for JasperReports server with user credentials
*/
@interface JSUserProfile : JSProfile <NSCopying, NSSecureCoding>

/**
 The username, must be a valid account on JasperReports Server
 */
@property (nonatomic, readonly, nullable) NSString *username;

/**
 The account password
 */
@property (nonatomic, readonly, nullable) NSString *password;

/**
 The name of an organization. Used in JasperReport Server Professional
 which supports multi-tenancy. May be <code>nil</code> or empty
 */
@property (nonatomic, readonly, nullable) NSString *organization;


/**
 Returns a profile with the specified parameters
 
 @param alias The association name for server profile
 @param serverUrl The serverUrl. Should match pattern http://hostname:port/jasperserver (port is not required)
 @param organization The server organization. May be <code>nil</code> or empty
 @param username The valid server account username
 @param password The account password
 @return A configured JSProfile instance
 */
- (nonnull instancetype)initWithAlias:(nonnull NSString *)alias serverUrl:(nonnull NSString *)serverUrl organization:(nullable NSString *)organization
                             username:(nullable nullable NSString *)username password:(nullable NSString *)password;

@end
