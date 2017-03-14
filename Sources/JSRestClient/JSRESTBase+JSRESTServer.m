/*
 * Copyright © 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


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
