/*
 * Copyright © 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.6
 */

#import "JSRESTBase.h"
@class JSOrganization;

@interface JSRESTBase(JSRESTServer)

/**
 Fetch Server Info
 
 @param block The block to inform of the results
 
 @since 2.6
 */
- (void)fetchServerInfoWithCompletion:(JSRequestCompletionBlock)block;

/**
 Fetch Server Organizations
 
 @param block The block to inform of the results
 
 @since 2.6
 */
- (void)fetchServerOrganizationsWithCompletion:(JSRequestCompletionBlock)block;

/**
 Fetch Server Roles
 
 @param organization The organization for loading it roles
 
 @param block The block to inform of the results
 
 @since 2.6
 */
- (void)fetchServerRolesWithOrganization:(JSOrganization *)organization
                              completion:(JSRequestCompletionBlock)block;

@end
