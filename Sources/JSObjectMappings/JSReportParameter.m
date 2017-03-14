/*
 * Copyright © 2013 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSReportParameter.h"

@implementation JSReportParameter
#pragma mark - JSObjectMappingsProtocol
+ (nonnull NSString *)requestObjectKeyPath {
    return @"reportParameter";
}

@end
