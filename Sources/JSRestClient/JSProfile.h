/*
 * Copyright © 2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.1
 */

@class JSServerInfo;

/**
 Uses to store connection details for JasperReports server
*/
@interface JSProfile : NSObject <NSCopying, NSSecureCoding>
/**
 If YES REST Client will try to recreate HTTP session.
 */
@property (nonatomic, assign) BOOL keepSession;         //NO by default

/**
 The name used to refer to this profile.
 The alias is mainly used to display profile's name in UI (i.e. when displays
 a list of available servers)
 */
@property (nonatomic, nonnull) NSString *alias;

/**
 The URL of JasperReports Server.
 URL should match next pattern http://hostname:port/jasperserver
 port parameter is not required (i.e. http://mobiledemo.jaspersoft.com/jasperserver-pro)
 */
@property (nonatomic, readonly, nonnull) NSString *serverUrl;

/**
 The version of JasperReports server
 */
@property (nonatomic, strong, nonnull) JSServerInfo *serverInfo;

/**
 Returns a profile with the specified parameters
 
 @param alias The association name for server profile
 @param serverUrl The serverUrl. Should match pattern http://hostname:port/jasperserver (port is not required)
 @return A configured JSProfile instance
 */
- (nonnull instancetype)initWithAlias:(nonnull NSString *)alias serverUrl:(nonnull NSString *)serverUrl;

@end
