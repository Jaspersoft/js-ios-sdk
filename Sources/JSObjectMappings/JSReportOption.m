/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSReportOption.h"
#import "JSMandatoryValidationRule.h"
#import "JSDateTimeFormatValidationRule.h"

@implementation JSReportOption

+ (JSReportOption *)defaultReportOption
{
    JSReportOption *reportOption = [JSReportOption new];
    reportOption.label = JSCustomLocalizedString(@"report_options_default_option_title", nil);
    return reportOption;
}

- (BOOL)isEqual:(nullable id)object
{
    if (![self isKindOfClass:[object class]]) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    
    return ((self.uri == [object uri] || [self.uri isEqualToString:[object uri]]) && (self.label == [object label] || [self.label isEqualToString:[object label]]));
}

#pragma mark - JSObjectMappingsProtocol
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"id": @"identifier",
                                               @"uri": @"uri",
                                               @"label": @"label"
                                               }];
    }];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSReportOption *newReportOption = [[self class] allocWithZone:zone];
    newReportOption.uri             = [self.uri copyWithZone:zone];
    newReportOption.label           = [self.label copyWithZone:zone];
    newReportOption.identifier      = [self.identifier copyWithZone:zone];
    newReportOption.inputControls   = [[NSArray alloc] initWithArray:self.inputControls copyItems:YES];
    
    return newReportOption;
}
@end
