//
//  JSClassMappingRulesHelper.m
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 29.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSResourceDescriptor.h"
#import "JSResourceProperty.h"
#import "JSClassesMappingRulesHelper.h"

// Mapping types in ClassMappingRules.plist property file
NSString * const JSPropertyMappingType = @"property";
NSString * const JSRelationMappingType = @"relation";

// Key elements in ClassMappingRules.plist property file
NSString * const JSKeyRootNode = @"rootNode";
NSString * const JSKeyMappingRules = @"mappingRules";
NSString * const JSKeyMappingPaths = @"mappingPaths";
NSString * const JSKeyNode = @"node";
NSString * const JSKeyProperty = @"prop";
NSString * const JSKeyMappingType = @"type";
NSString * const JSKeyIsAttr = @"isAttr";
NSString * const JSKeyUseNodeInSerialization = @"useNodeInSerialization";

// URI path and extension for SDK bundle and ClassMappingRules.plist file
NSString * const _jaspersoftSDKBundleName = @"jaspersoft-sdk-resources";
NSString * const _jaspersoftSDKBundleExtenstion = @"bundle";
NSString * const _classesMappingRulesPath = @"ClassesMappingRules";
NSString * const _classesMappingRulesExtension = @"plist";

@implementation JSClassesMappingRulesHelper

// Get loded mapping rules for classes from ClassMappingRules.plist file
+ (NSDictionary *)loadedRules {
    static NSDictionary *_loadedRules = nil;
    
    if (!_loadedRules) {
        // Load SDK bundle which contains ClassesMappingRules.plist file
        NSURL *jaspersoftSDKBundleURL = [[NSBundle mainBundle] URLForResource:_jaspersoftSDKBundleName withExtension:_jaspersoftSDKBundleExtenstion];
        
        if (jaspersoftSDKBundleURL) {
            // Load rules from file and sort them by isAttr key (if key isAttr equals YES then rule goes to top).
            // Instead there will be runtime exception in JSXMLSerializer when 
            // it will try to write XML attribute after writing next XML node
            _loadedRules = [self sortByIsAttrKeyMappingRules:[NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithURL:jaspersoftSDKBundleURL] pathForResource:_classesMappingRulesPath ofType:_classesMappingRulesExtension]]];
        } else {
            @throw([NSException exceptionWithName:@"FileNotFoundException" reason:[NSString stringWithFormat:@"SDK \"%@.%@\" file was not found. You should copy this file from SDK directly to your project and add it to section \"Copy Bundle Resources\" in main target", _jaspersoftSDKBundleName, _jaspersoftSDKBundleExtenstion] userInfo:nil]);
        }
    }

    return _loadedRules;
}

// Sorting rules by isAttr key (XML attributes should be written firts)
+ (NSDictionary *)sortByIsAttrKeyMappingRules:(NSMutableDictionary *)mappingRules {
    
    // Sort rules for each class
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
        
        // Set sorted rules for class
        [[mappingRules objectForKey:className] setObject:sortedRulesForClass forKey:JSKeyMappingRules];
    }
    
    return mappingRules;
}

@end
