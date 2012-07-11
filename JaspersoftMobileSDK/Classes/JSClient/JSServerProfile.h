//
//  JSServerProfile.h
//  JaspersoftMobileSDK
//
//  Created by Volodya on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
