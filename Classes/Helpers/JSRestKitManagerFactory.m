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
//  JSRestKitManagerFactory.m
//  Jaspersoft Corporation
//


#import "JSRestKitManagerFactory.h"
#import "JSErrorDescriptor.h"
#import "JSRESTBase.h"

// Helper keys for _restKitObjectMappings dictionary
NSString * const _keyMapping = @"mapping";
NSString * const _keyPaths = @"paths";
NSString * const _keyClass = @"class";

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

// URI path and extension for SDK bundle and mapping file
NSString * const _jaspersoftSDKBundleName = @"JaspersoftSDK-resources";
NSString * const _jaspersoftSDKBundleExtension = @"bundle";
NSString * const _classesMappingRulesPath = @"ClassesMappingRules";
NSString * const _classesMappingRulesExtension = @"plist";

@implementation JSRestKitManagerFactory
+ (RKObjectManager *)createRestKitObjectManagerForClasses:(NSArray *)classes andServerProfile:(JSProfile *)serverProfile{
    // Creates RKObjectManager for loading and mapping encoded response (i.e XML, JSON etc.)
    // directly to objects
    RKObjectManager *restKitObjectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:serverProfile.serverUrl]];
    [restKitObjectManager.HTTPClient setAuthorizationHeaderWithUsername:serverProfile.username password:serverProfile.password];
    restKitObjectManager.HTTPClient.allowsInvalidSSLCertificate = YES;
    
    // Add locale to object manager
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSInteger dividerPosition = [currentLanguage rangeOfString:@"_"].location;
    if (dividerPosition != NSNotFound) {
        currentLanguage = [currentLanguage substringToIndex:dividerPosition];
    }
    NSString *currentLocale = [[JSConstants sharedInstance].REST_JRS_LOCALE_SUPPORTED objectForKey:currentLanguage];
    if (currentLocale) {
        [restKitObjectManager.HTTPClient setDefaultHeader:@"Accept-Language" value:currentLocale];
    }
    [restKitObjectManager.HTTPClient setDefaultHeader:@"Accept-Timezone" value:[NSString stringWithFormat:@"%@", [[NSTimeZone systemTimeZone] abbreviation]]];
    
    
    // Sets default content-type and charset to object manager
    [restKitObjectManager.HTTPClient setDefaultHeader:kJSRequestCharset value:[JSConstants sharedInstance].REST_SDK_CHARSET_USED];
    restKitObjectManager.requestSerializationMIMEType = [JSConstants sharedInstance].REST_SDK_MIMETYPE_USED;
    [restKitObjectManager setAcceptHeaderWithMIMEType:[JSConstants sharedInstance].REST_SDK_MIMETYPE_USED];
    
    if (classes.count) {
        NSDictionary *restKitObjectMappings = [self restKitObjectMappings];
        
        // Set all mapping rules for provided classes to RestKit's object manager
        for (Class objectClass in classes) {
            NSDictionary *pathsAndMappingForClass = [restKitObjectMappings objectForKey:NSStringFromClass(objectClass)];
            
            RKObjectMapping *mapping = [pathsAndMappingForClass objectForKey:_keyMapping];
            for (NSString *path in [pathsAndMappingForClass objectForKey:_keyPaths]) {
                [restKitObjectManager addResponseDescriptor:
                 [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                              method:RKRequestMethodAny
                                                         pathPattern:nil
                                                             keyPath:path
                                                         statusCodes:nil]];
            }
            if ([pathsAndMappingForClass objectForKey:JSKeyRootNode]) {
                [restKitObjectManager addRequestDescriptor:
                 [RKRequestDescriptor requestDescriptorWithMapping:[mapping inverseMapping]
                                                       objectClass:objectClass
                                                       rootKeyPath:[pathsAndMappingForClass objectForKey:JSKeyRootNode]
                                                            method:RKRequestMethodAny]];
            }
        }
    }
    
    return restKitObjectManager;
}

// Already mapped rules for different classes. Uses for creating different REST classes
+ (NSDictionary *)restKitObjectMappings {
    NSMutableDictionary *restKitObjectMappings = [NSMutableDictionary dictionary];
    
    // Load SDK bundle which contains mapping file
    NSURL *jaspersoftSDKBundleURL = [[NSBundle mainBundle] URLForResource:_jaspersoftSDKBundleName withExtension:_jaspersoftSDKBundleExtension];
    if (jaspersoftSDKBundleURL) {
        // Load rules from file
        NSDictionary *mappingRules = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithURL:jaspersoftSDKBundleURL] pathForResource:_classesMappingRulesPath ofType:_classesMappingRulesExtension]];
        
        for (NSString *className in mappingRules.keyEnumerator) {
            Class objectClass = NSClassFromString(className);
            
            RKObjectMapping *mapping = [self mappingForClass:objectClass forMappingRules:mappingRules allObjectmappings:mappingRules];
            NSArray *mappingPaths = [[mappingRules objectForKey:className] objectForKey:JSKeyMappingPaths];
            
            NSString *rootNode = [[mappingRules objectForKey:className] objectForKey:JSKeyRootNode];
            
            // Initialize next structure: { @"mapping" : rkObjectMapping, @"paths" : nsArrayOfPaths }
            NSMutableDictionary *pathsAndMappingForClass = [NSMutableDictionary dictionaryWithObjectsAndKeys:mapping, _keyMapping, mappingPaths, _keyPaths, nil];
            if (rootNode && rootNode.length) {
                [pathsAndMappingForClass setObject:rootNode forKey:JSKeyRootNode];
            }
            
            // Set mapping result for class
            [restKitObjectMappings setObject:pathsAndMappingForClass forKey:className];
        }
    } else {
        @throw([NSException exceptionWithName:@"FileNotFoundException" reason:[NSString stringWithFormat:@"SDK \"%@.%@\" file was not found. You should copy this file from SDK directly to your project and add it to section \"Copy Bundle Resources\" in main target", _jaspersoftSDKBundleName, _jaspersoftSDKBundleExtension] userInfo:nil]);
    }
    
    return restKitObjectMappings;
}

// Creates RestKit's mapping object for class (by name) using mapping rules from dictionary
+ (RKObjectMapping *)mappingForClass:(Class)objectClass forMappingRules:(NSDictionary *)mappingRules allObjectmappings:(NSDictionary *)allObjectMappings{
    
    // Get class name from Class object (for example: JSResourceDescriptor class -> @"JSResourceDescriptor")
    NSString *className = NSStringFromClass(objectClass);
    
    // Initialize class mapping from a Class object
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:objectClass];

    // Iterate true all mapping rule defined for specified class (by "className")
    for (NSDictionary *mappingRule in [[mappingRules objectForKey:className] objectForKey:JSKeyMappingRules]) {
        
        // Check if we have "property" type of mapping in class 
        if ([[mappingRule objectForKey:JSKeyMappingType] isEqualToString:JSPropertyMappingType]) {
            
            // Set property type of mapping (maps xmlNode in xml to property in class)
            [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:[mappingRule objectForKey:JSKeyNode] toKeyPath:[mappingRule objectForKey:JSKeyProperty]]];
            
        // Check if we have nested objects and 1:n/1:1 relations between them
        // For example: one JSResourceDescriptor object may contains many JSResourceProperties
        } else if ([[mappingRule objectForKey:JSKeyMappingType] isEqualToString:JSRelationMappingType]) {
            
            // Get name of mapped class
            NSString *relationClassName = [mappingRule objectForKey:_keyClass];
            
            // Check if parent class has relation on himself. This prevents infinite recursive loop
            if (![relationClassName isEqualToString:className]) {
                
                // Check if mapping already exists in classesMappingRules and use it. Otherwise create new
                RKObjectMapping *relationMapping = [[allObjectMappings objectForKey:relationClassName]
                                                    objectForKey:_keyMapping] ?: [self mappingForClass:NSClassFromString([mappingRule objectForKey:_keyClass]) forMappingRules:mappingRules allObjectmappings:allObjectMappings];
                
                // Recursively set relation type of mapping
                [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[mappingRule objectForKey:JSKeyNode]
                                                                                       toKeyPath:[mappingRule objectForKey:JSKeyProperty]
                                                                                      withMapping:relationMapping]];
            } else {
                // Add "mapping" of parent class if parent class has relation on himself
                [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[mappingRule objectForKey:JSKeyNode]
                                                                                        toKeyPath:[mappingRule objectForKey:JSKeyProperty]
                                                                                      withMapping:mapping]];
            }
        }
    }
    
    return mapping;
}

@end
