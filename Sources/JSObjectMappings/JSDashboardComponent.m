/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSDashboardComponent.h"


@implementation JSDashboardComponent

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                @"id"                        : @"identifier",
                @"type"                      : @"type",
                @"label"                     : @"label",
                @"name"                      : @"name",
                @"resourceId"                : @"resourceId",
                @"resource"                  : @"resourceURI",
                @"ownerResourceId"           : @"ownerResourceURI",
                @"ownerResourceParameterName": @"ownerResourceParameterName",
                @"dashletHyperlinkUrl"       : @"dashletHyperlinkUrl",
        }];

        // Dashlet Hyperlink Target
        NSDictionary *targetTypes = @{
                @"Blank" : @(JSDashletHyperlinksTargetTypeBlank),
                @"Self"  : @(JSDashletHyperlinksTargetTypeSelf),
                @"Parent": @(JSDashletHyperlinksTargetTypeParent),
                @"Top"   : @(JSDashletHyperlinksTargetTypeTop)
        };

        [mapping mapKeyPath:@"dashletHyperlinkTarget" toProperty:@"dashletHyperlinkTarget" withValueBlock:^(NSString *key, id value) {
            return targetTypes[value];
        } reverseBlock:^id(id value) {
            return [targetTypes allKeysForObject:value].lastObject;
        }];

    }];
}

+ (nonnull NSString *)requestObjectKeyPath {
    return @"dashboardComponent";
}

@end
