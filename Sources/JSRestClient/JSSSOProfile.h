/*
 * Copyright © 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.6
 */

#import "JSProfile.h"

/**
 Uses to store connection details for JasperReports server with SSO
*/
@interface JSSSOProfile : JSProfile <NSCopying, NSSecureCoding>

/**
 The SSO token, must be a valid token for JasperReports Server
 */
@property (nonatomic, readonly, nonnull) NSString *ssoToken;

/**
 The SSO token field, must be a valid token for JasperReports Server. Default parameter name for an authentication token is "ticket". This parameter name can be changed via Spring configuration in corresponding applicationContext-externalAuth-*.xml
 */
@property (nonatomic, nonnull) NSString *ssoTokenField;

/**
 Returns a profile with the specified parameters
 
 @param alias The association name for server profile
 @param serverUrl The serverUrl. Should match pattern http://hostname:port/jasperserver (port is not required)
 @param ssoToken The SSO token
 @return A configured JSProfile instance
 */
- (nonnull instancetype)initWithAlias:(nonnull NSString *)alias serverUrl:(nonnull NSString *)serverUrl ssoToken:(nullable NSString *)ssoToken;

@end
