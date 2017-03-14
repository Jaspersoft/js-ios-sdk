/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <Foundation/Foundation.h>
#import "JSUserProfile.h"

extern NSString * const kJSTestProfileName;
extern NSString * const kJSTestProfileUrl;
extern NSString * const kJSTestProfileUsername;
extern NSString * const kJSTestProfilePassword;
extern NSString * const kJSTestProfileOrganization;

@interface JSServerProfileProvider : NSObject

+ (JSUserProfile *)serverProfileWithVersion:(float)serverVersion;

@end
