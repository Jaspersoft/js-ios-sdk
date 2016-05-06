//
//  JSServerProfileProvider.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 4/27/16.
//  Copyright © 2016 TIBCO JasperMobile. All rights reserved.
//

#import "JSServerProfileProvider.h"
#import "JSServerInfo.h"
#import "EKMapper.h"

NSString * const kJSTestProfileName = @"TestProfile";
NSString * const kJSTestProfileUrl = @"http://test.url";
NSString * const kJSTestProfileUsername = @"TestUsername";
NSString * const kJSTestProfilePassword = @"TestPassword";
NSString * const kJSTestProfileOrganization = @"TestOrganization";

@implementation JSServerProfileProvider

+ (JSProfile *)serverProfileWithVersion:(float)serverVersion {
    JSProfile *serverProfile = [[JSProfile alloc] initWithAlias:@"TestProfile" serverUrl:@"http://test.url" organization:@"TestOrganization" username:@"TestUsername" password:@"TestPassword"];
    
    id serverInfoJSON = [JSObjectRepresentationProvider JSONObjectForClass:[JSServerInfo class]];
    EKObjectMapping *mapping = [JSServerInfo objectMappingForServerProfile:serverProfile];
    
    serverProfile.serverInfo = [EKMapper objectFromExternalRepresentation:serverInfoJSON withMapping:mapping];
    serverProfile.serverInfo.version = [[NSNumber numberWithFloat:serverVersion] stringValue];
    return serverProfile;
}

@end
