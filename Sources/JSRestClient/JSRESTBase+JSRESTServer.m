/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2015 Jaspersoft Corporation. All rights reserved.
 * http://community.jaspersoft.com/project/mobile-sdk-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is part of Jaspersoft Mobile SDK for iOS.
 *
 * Jaspersoft Mobile SDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Jaspersoft Mobile SDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Jaspersoft Mobile SDK for iOS. If not, see
 * <http://www.gnu.org/licenses/lgpl>.
 */

//
//  JSRESTBase(JSRESTServer).m
//  Jaspersoft Corporation
//

#import "JSRESTBase+JSRESTServer.h"
#import "JSOrganization.h"
#import "JSRole.h"

@implementation JSRESTBase(JSRESTServer)

- (void)fetchServerInfoWithCompletion:(JSRequestCompletionBlock)completion {
    JSRequest *request = [[JSRequest alloc] initWithUri:kJS_REST_SERVER_INFO_URI];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSServerInfo objectMappingForServerProfile:self.serverProfile] keyPath:nil];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = ^(JSOperationResult *_Nullable result){
        if (!result.error) {
            if (result.objects.count) {
                JSServerInfo *serverInfo = result.objects.lastObject;
                if (serverInfo.versionAsFloat < [JSUtils minSupportedServerVersion]) {
                    result.error = [JSErrorBuilder errorWithCode:JSServerVersionNotSupportedErrorCode];
                }
            } else {
                result.error = [JSErrorBuilder errorWithCode:JSClientErrorCode];
            }
        } else if (result.error.code == JSOtherErrorCode || result.error.code == JSUnsupportedAcceptTypeErrorCode) {
            result.error = [JSErrorBuilder errorWithCode:JSServerNotReachableErrorCode];
        }
        
        if (completion) {
            completion(result);
        }
    };
    [self sendRequest:request];
}

- (void)fetchServerOrganizationsWithCompletion:(JSRequestCompletionBlock)block {
    JSRequest *request = [[JSRequest alloc] initWithUri:kJS_REST_ORGANIZATIONS_URI];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSOrganization objectMappingForServerProfile:self.serverProfile] keyPath:nil];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    [self sendRequest:request];
}

- (void)fetchServerRolesWithOrganization:(JSOrganization *)organization
                              completion:(JSRequestCompletionBlock)block {
    NSString *uri = kJS_REST_ROLES_URI;
    if (organization && organization.organizationId.length) {
        uri = [NSString stringWithFormat:@"%@/%@%@", kJS_REST_ORGANIZATIONS_URI, organization.organizationId, kJS_REST_ROLES_URI];
    }
    
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSOrganization objectMappingForServerProfile:self.serverProfile] keyPath:nil];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    [self sendRequest:request];
}

@end
