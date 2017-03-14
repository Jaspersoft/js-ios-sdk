/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import "JSServerProfileProvider.h"
#import "JSServerInfo.h"
#import "EKMapper.h"

NSString * const kJSTestProfileName = @"TestProfile";
NSString * const kJSTestProfileUrl = @"http://194.29.62.80:8081/jasperserver-pro-56";
NSString * const kJSTestProfileUsername = @"TestUsername";
NSString * const kJSTestProfilePassword = @"TestPassword";
NSString * const kJSTestProfileOrganization = @"TestOrganization";

@implementation JSServerProfileProvider

+ (JSUserProfile *)serverProfileWithVersion:(float)serverVersion {
    JSUserProfile *serverProfile = [[JSUserProfile alloc] initWithAlias:kJSTestProfileName serverUrl:kJSTestProfileUrl organization:kJSTestProfileOrganization username:kJSTestProfileUsername password:kJSTestProfilePassword];
    
    id serverInfoJSON = [JSObjectRepresentationProvider JSONObjectForClass:[JSServerInfo class]];
    EKObjectMapping *mapping = [JSServerInfo objectMappingForServerProfile:serverProfile];
    
    serverProfile.serverInfo = [EKMapper objectFromExternalRepresentation:serverInfoJSON withMapping:mapping];
    serverProfile.serverInfo.version = [[NSNumber numberWithFloat:serverVersion] stringValue];
    return serverProfile;
}

@end
