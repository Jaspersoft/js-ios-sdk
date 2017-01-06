//
//  JSServerProfileProvider.h
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 4/27/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

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
