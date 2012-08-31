//
//  JSClassMappingRulesHelper.h
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 29.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

// Mapping types in ClassMappingRules.plist property file
extern NSString * const JSPropertyMappingType;
extern NSString * const JSRelationMappingType;

// Key elements in ClassMappingRules.plist property file
extern NSString * const JSKeyRootNode;
extern NSString * const JSKeyMappingRules;
extern NSString * const JSKeyMappingPaths;
extern NSString * const JSKeyNode;
extern NSString * const JSKeyProperty;
extern NSString * const JSKeyMappingType;
extern NSString * const JSKeyIsAttr;
extern NSString * const JSKeyUseNodeInSerialization;

// Helper class which loads data from ClassesMappingRules.plist file (contains mapping rules for GET and 
// PUT objects using REST service). Class also provides "constants" for accessing elements in file
@interface JSClassesMappingRulesHelper : NSObject

// Returns all loaded rules from file ClassesMappingRules.plist
+ (NSDictionary *)loadedRules;

@end
