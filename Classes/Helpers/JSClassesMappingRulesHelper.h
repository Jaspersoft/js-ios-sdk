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
//  JSClassMappingRulesHelper.h
//  Jaspersoft Corporation
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

/**
 @cond EXCLUDE_JS_CLASSES_MAPPING_RULES_HELPER
 
 Loads and represents as dictionary data from <b>ClassesMappingRules.plist</b> file.
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