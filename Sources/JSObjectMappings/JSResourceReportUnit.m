/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSResourceReportUnit.h"


@implementation JSResourceReportUnit

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    EKObjectMapping *mapping = [super objectMappingForServerProfile:serverProfile];
    [mapping mapPropertiesFromArray:@[@"alwaysPromptControls"]];
    return mapping;
}

@end
