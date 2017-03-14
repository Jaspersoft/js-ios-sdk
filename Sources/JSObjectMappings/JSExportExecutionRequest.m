/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSExportExecutionRequest.h"
#import "JSServerInfo.h"

@implementation JSExportExecutionRequest

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"outputFormat": @"outputFormat",
                                               @"pages": @"pages",
                                               @"attachmentsPrefix": @"attachmentsPrefix",
                                               }];
        if (serverProfile && serverProfile.serverInfo.versionAsFloat >= kJS_SERVER_VERSION_CODE_EMERALD_5_6_0) {
            [mapping mapPropertiesFromArray:@[@"baseUrl"]];
        }

        if (serverProfile && serverProfile.serverInfo.versionAsFloat >= kJS_SERVER_VERSION_CODE_AMBER_6_0_0) {

            NSDictionary *markupTypes = @{
                    @"full": @(JSMarkupTypeFull),
                    @"embeddable": @(JSMarkupTypeEmbeddable)
            };

            [mapping mapKeyPath:@"markupType" toProperty:@"markupType" withValueBlock:^(NSString *key, id value) {
                return markupTypes[value];
            } reverseBlock:^id(id value) {
                return [markupTypes allKeysForObject:value].lastObject;
            }];
        }

    }];
}

@end
