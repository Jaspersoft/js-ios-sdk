/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2014 Jaspersoft Corporation. All rights reserved.
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
//  JSUtils.m
//  Jaspersoft Corporation
//

#import "JSUtils.h"
#import "RKMIMETypes.h"
#import "JSInputControlDescriptor.h"
#import "JSReportParameter.h"

NSString * const JSLocalizationTable = @"JaspersoftSDK";
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
    NSURL *localizationBundleURL = [[NSBundle mainBundle] URLForResource:JSLocalizationTable withExtension:@"bundle"];
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
    return RKMIMETypeJSON;
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

@end

NSString *JSCustomLocalizedString(NSString *key, NSString *comment) {
    return [JSUtils localizedStringForKey:key comment:comment];
}
