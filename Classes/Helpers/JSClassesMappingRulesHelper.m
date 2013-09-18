/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2013 Jaspersoft Corporation. All rights reserved.
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
//  JSClassMappingRulesHelper.m
//  Jaspersoft Corporation
//

#import "JSClassesMappingRulesHelper.h"

// Mapping types in ClassMappingRules.plist property file (mapping file)
NSString * const JSPropertyMappingType = @"property";
NSString * const JSRelationMappingType = @"relation";

// Key elements in mapping file
NSString * const JSKeyRootNode = @"rootNode";
NSString * const JSKeyMappingRules = @"mappingRules";
NSString * const JSKeyMappingPaths = @"mappingPaths";
NSString * const JSKeyNode = @"node";
NSString * const JSKeyProperty = @"prop";
NSString * const JSKeyMappingType = @"type";
NSString * const JSKeyIsAttr = @"isAttr";

// URI path and extension for SDK bundle and mapping file
NSString * const _jaspersoftSDKBundleName = @"jaspersoft-sdk-resources";
NSString * const _jaspersoftSDKBundleExtension = @"bundle";
NSString * const _classesMappingRulesPath = @"ClassesMappingRules";
NSString * const _classesMappingRulesExtension = @"plist";

@implementation JSClassesMappingRulesHelper

+ (NSDictionary *)loadedRules {
    // Load SDK bundle which contains mapping file
    NSURL *jaspersoftSDKBundleURL = [[NSBundle mainBundle] URLForResource:_jaspersoftSDKBundleName
                                                            withExtension:_jaspersoftSDKBundleExtension];

    if (jaspersoftSDKBundleURL) {
        // Load rules from file and sort them by isAttr key (this key describes
        // if rule  is an XML attribute of node or node itself). This operation
        // required for preventing runtime exception in JSXMLSerializer when
        // it will try to write XML attribute after writing XML node
        return [self sortByIsAttrKeyMappingRules:[NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithURL:jaspersoftSDKBundleURL] pathForResource:_classesMappingRulesPath ofType:_classesMappingRulesExtension]]];
    } else {
        @throw([NSException exceptionWithName:@"FileNotFoundException" reason:[NSString stringWithFormat:@"SDK \"%@.%@\" file was not found. You should copy this file from SDK directly to your project and add it to section \"Copy Bundle Resources\" in main target", _jaspersoftSDKBundleName, _jaspersoftSDKBundleExtension] userInfo:nil]);
    }
}

// Sorts mapping rules by isAttr key
+ (NSDictionary *)sortByIsAttrKeyMappingRules:(NSMutableDictionary *)mappingRules {
    for (NSString *className in mappingRules.keyEnumerator) {
        NSArray *sortedRulesForClass = [[[mappingRules objectForKey:className] objectForKey:JSKeyMappingRules] sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
            BOOL isObj1Attr = [[obj1 objectForKey:JSKeyIsAttr] boolValue];
            BOOL isObj2Attr = [[obj2 objectForKey:JSKeyIsAttr] boolValue];
            
            if (isObj1Attr && !isObj2Attr) {
                return NSOrderedAscending;
            } else if (!isObj1Attr && isObj2Attr) {
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        
        [[mappingRules objectForKey:className] setObject:sortedRulesForClass forKey:JSKeyMappingRules];
    }
    
    return mappingRules;
}

@end
