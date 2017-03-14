/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @author Olexandr Dahno odahno@tibco.com
 @since 1.9
 */


#import "JSRESTBase.h"

/**
 Extention to <code>JSRESTBase</code> class for working with HTTP session.
 */

@interface JSRESTBase(JSRESTSession)
/**
 Checks if session is authorized
 
 @param block The block to inform of the results
 
 @since 1.9
 */
- (void)verifyIsSessionAuthorizedWithCompletion:(JSRequestCompletionBlock)block;

extern NSString * const kJSSessionDidAuthorizedNotification;

@end
