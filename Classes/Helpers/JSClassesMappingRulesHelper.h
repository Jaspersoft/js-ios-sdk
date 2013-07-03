//
//  JSClassMappingRulesHelper.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 29.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

// Mapping types defined in ClassMappingRules.plist property file (mapping file)
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

/**
 @cond EXCLUDE_JS_CLASSES_MAPPING_RULES_HELPER
 
 Loads and represents as dictonary data from <b>ClassesMappingRules.plist</b> file.
 This file (can be found by path /Classes/Helpers/MappingConfiguration/) contains
 classes mapping rules (all classes from <b>ObjectMappings</b> group).
 
 Class mapping rule describes how returned HTTP response (in JSON, XML and other
 formats) should be mapped directly to this class (i.e. describes how XML should
 be mapped to JSResourceDescriptor, JSReportDescriptor etc.)
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.3
 */
@interface JSClassesMappingRulesHelper : NSObject

/**
 Returns a dictionary of loaded classes mapping rules from file 
 <b>ClassesMappingRules.plist</b>
 
 @return A dictionary of classes mapping rules
 */
+ (NSDictionary *)loadedRules;

@end

/** @endcond */