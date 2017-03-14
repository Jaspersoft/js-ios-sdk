/*
 * Copyright © 2013 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSServerInfo.h"
#import "JSDateFormatterFactory.h"

NSString * const kJSSavedServerInfoBuildKey                 = @"JSSavedServerInfoBuildKey";
NSString * const kJSSavedServerInfoEditionKey               = @"JSSavedServerInfoEditionKey";
NSString * const kJSSavedServerInfoEditionNameKey           = @"JSSavedServerInfoEditionNameKey";
NSString * const kJSSavedServerInfoExpirationKey            = @"JSSavedServerInfoExpirationKey";
NSString * const kJSSavedServerInfoFeaturesKey              = @"JSSavedServerInfoFeaturesKey";
NSString * const kJSSavedServerInfoLicenseTypeKey           = @"JSSavedServerInfoLicenseTypeKey";
NSString * const kJSSavedServerInfoVersionKey               = @"JSSavedServerInfoVersionKey";
NSString * const kJSSavedServerInfoDateFormatPatternKey     = @"JSSavedServerInfoDateFormatPatternKey";
NSString * const kJSSavedServerInfoDatetimeFormatPatternKey = @"kJSSavedServerInfoDatetimeFormatPatternKey";

@implementation JSServerInfo

- (float)versionAsFloat {
    NSString *simplyVersionString = self.version;
    NSRange firstDotRange = [self.version rangeOfString:@"."];
    if (firstDotRange.location != NSNotFound) {
        NSRange minorVersionRange = NSMakeRange(firstDotRange.location + firstDotRange.length, self.version.length - (firstDotRange.location + firstDotRange.length));
        simplyVersionString = [self.version stringByReplacingOccurrencesOfString:@"." withString:@"" options:NSCaseInsensitiveSearch range:minorVersionRange];
    }
    return [simplyVersionString floatValue];
}

- (NSDateFormatter *)serverDateFormatFormatter {
    return [[JSDateFormatterFactory sharedFactory] formatterWithPattern:self.datetimeFormatPattern timeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
}

#pragma mark - JSObjectMappingsProtocol

+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"build", @"edition", @"editionName", @"expiration", @"features",
                                          @"licenseType", @"version", @"dateFormatPattern", @"datetimeFormatPattern"]];
    }];
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_build forKey:kJSSavedServerInfoBuildKey];
    [aCoder encodeObject:_edition forKey:kJSSavedServerInfoEditionKey];
    [aCoder encodeObject:_editionName forKey:kJSSavedServerInfoEditionNameKey];
    [aCoder encodeObject:_expiration forKey:kJSSavedServerInfoExpirationKey];
    [aCoder encodeObject:_features forKey:kJSSavedServerInfoFeaturesKey];
    [aCoder encodeObject:_licenseType forKey:kJSSavedServerInfoLicenseTypeKey];
    [aCoder encodeObject:_version forKey:kJSSavedServerInfoVersionKey];
    [aCoder encodeObject:_dateFormatPattern forKey:kJSSavedServerInfoDateFormatPatternKey];
    [aCoder encodeObject:_datetimeFormatPattern forKey:kJSSavedServerInfoDatetimeFormatPatternKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _build = [aDecoder decodeObjectForKey:kJSSavedServerInfoBuildKey];
        _edition = [aDecoder decodeObjectForKey:kJSSavedServerInfoEditionKey];
        _editionName = [aDecoder decodeObjectForKey:kJSSavedServerInfoEditionNameKey];
        _expiration = [aDecoder decodeObjectForKey:kJSSavedServerInfoExpirationKey];
        _features = [aDecoder decodeObjectForKey:kJSSavedServerInfoFeaturesKey];
        _licenseType = [aDecoder decodeObjectForKey:kJSSavedServerInfoLicenseTypeKey];
        _version = [aDecoder decodeObjectForKey:kJSSavedServerInfoVersionKey];
        _dateFormatPattern = [aDecoder decodeObjectForKey:kJSSavedServerInfoDateFormatPatternKey];
        _datetimeFormatPattern = [aDecoder decodeObjectForKey:kJSSavedServerInfoDatetimeFormatPatternKey];
    }
    return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    JSServerInfo *copiedInfo = [[JSServerInfo allocWithZone:zone] init];
    copiedInfo.build = [self.build copyWithZone:zone];
    copiedInfo.edition = [self.edition copyWithZone:zone];
    copiedInfo.editionName = [self.editionName copyWithZone:zone];
    copiedInfo.expiration = [self.expiration copyWithZone:zone];
    copiedInfo.features = [self.features copyWithZone:zone];
    copiedInfo.licenseType = [self.licenseType copyWithZone:zone];
    copiedInfo.version = [self.version copyWithZone:zone];
    copiedInfo.dateFormatPattern = [self.dateFormatPattern copyWithZone:zone];
    copiedInfo.datetimeFormatPattern = [self.datetimeFormatPattern copyWithZone:zone];
    
    return copiedInfo;
}
@end
