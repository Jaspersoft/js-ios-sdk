/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSUtils.h"
#import "JSInputControlDescriptor.h"
#import "JSReportParameter.h"

NSString * const JSLocalizationBundleName = @"JaspersoftSDK";
NSString * const JSLocalizationTable = @"Localizable";
NSString * const JSPreferredLanguage = @"en";
NSString * const JSLocalizationBundleType = @"lproj";

@implementation JSUtils

+ (nonnull NSString *)stringFromBOOL:(BOOL)aBOOL {
    return aBOOL ? @"true" : @"false";
}

+ (BOOL)BOOLFromString:(nonnull NSString *)aString {
    NSComparisonResult result = [aString caseInsensitiveCompare:@"true"];
    return (result == NSOrderedSame);
}

+ (nonnull NSString *)keychainIdentifier {
    return [NSString stringWithFormat:@"%@.GenericKeychainSuite", [NSBundle mainBundle].bundleIdentifier];
}

+ (NSString *)localizedStringForKey:(NSString *)key comment:(nullable NSString *)comment{
    NSURL *localizationBundleURL = [[NSBundle mainBundle] URLForResource:JSLocalizationBundleName withExtension:@"bundle"];
    if (!localizationBundleURL) {
        localizationBundleURL = [[NSBundle bundleForClass:[self class]] bundleURL];
    }
    
    NSBundle *localizationBundle = localizationBundleURL ? [NSBundle bundleWithURL:localizationBundleURL] : [NSBundle mainBundle];
    
    NSString *localizedString = NSLocalizedStringFromTableInBundle(key, JSLocalizationTable, localizationBundle, comment);

    if (![[NSLocale preferredLanguages][0] isEqualToString:JSPreferredLanguage] && [localizedString isEqualToString:key]) {
        NSString *path = [localizationBundle pathForResource:JSPreferredLanguage ofType:JSLocalizationBundleType];
        NSBundle *preferredLanguageBundle = [NSBundle bundleWithPath:path];
        localizedString = [preferredLanguageBundle localizedStringForKey:key value:@"" table:JSLocalizationTable];
    }
    
    return localizedString;
}

+ (nonnull NSArray<JSReportParameter *> *)reportParametersFromInputControls:(nonnull NSArray <JSInputControlDescriptor *> *)inputControls {
    NSMutableArray *parameters = [NSMutableArray array];
    for (JSInputControlDescriptor *inputControlDescriptor in inputControls) {
        [parameters addObject:[[JSReportParameter alloc] initWithName:inputControlDescriptor.uuid
                                                                value:inputControlDescriptor.selectedValues]];
    }
    return [parameters copy];
}

+ (nonnull NSString *)usedMimeType {
    return @"application/json";
}

+ (NSTimeInterval) checkServerConnectionTimeout {
    return 7.f;
}

+ (nonnull NSDictionary *)supportedLocales {
    return @{@"en" : @"en_US",
             @"de" : @"de",
             @"ja" : @"ja",
             @"es" : @"es",
             @"fr" : @"fr",
             @"it" : @"it",
             @"zh" : @"zh_CN",
             @"pt" : @"pt_BR"};
}

+ (NSString *)backgroundSessionConfigurationIdentifier {
    return [NSString stringWithFormat:@"%@.BackgroundSessionConfigurationIdentifier", [NSBundle mainBundle].bundleIdentifier];
}

+ (float) minSupportedServerVersion
{
    return kJS_SERVER_VERSION_CODE_EMERALD_5_5_0;
}

@end

NSString *JSCustomLocalizedString(NSString *key, NSString *comment) {
    return [JSUtils localizedStringForKey:key comment:comment];
}
