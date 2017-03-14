/*
 * Copyright © 2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSReportExecutionRequest.h"
#import "JSServerInfo.h"
#import "EKSerializer.h"

@implementation JSReportExecutionRequest

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"reportUnitUri": @"reportUnitUri",
                                               @"async": @"async",
                                               @"outputFormat": @"outputFormat",
                                               @"interactive": @"interactive",
                                               @"freshData": @"freshData",
                                               @"saveDataSnapshot": @"saveDataSnapshot",
                                               @"ignorePagination": @"ignorePagination",
                                               @"transformerKey": @"transformerKey",
                                               @"pages": @"pages",
                                               @"attachmentsPrefix": @"attachmentsPrefix",
                                               }];
        if (serverProfile && serverProfile.serverInfo.versionAsFloat >= kJS_SERVER_VERSION_CODE_EMERALD_5_6_0) {
            [mapping mapPropertiesFromDictionary:@{@"baseUrl" : @"baseURL"}];
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

        [mapping mapKeyPath:@"parameters" toProperty:@"parameters" withValueBlock:^id(NSString *key, id value) {
            return nil; // Hack, here we need only reverse mapping
        } reverseBlock:^id(id value) {
            NSArray *parametersArray = [EKSerializer serializeCollection:value withMapping:[JSReportParameter objectMappingForServerProfile:serverProfile]];
            return @{@"reportParameter" : parametersArray};
        }];
    }];
}

@end
