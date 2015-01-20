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
#import "JSClassesMappingRulesHelper.h"
#import "JSErrorDescriptor.h"

// Access key and value for content-type / charset
NSString * const kJSRequestCharset = @"Charset";
NSString * const kJSRequestContentType = @"Content-Type";
NSString * const kJSRequestResponceType = @"Accept";

// Helper keys for _restKitObjectMappings dictionary
NSString * const _keyMapping = @"mapping";
NSString * const _keyPaths = @"paths";
NSString * const _keyClass = @"class";

static NSMutableDictionary *_restKitObjectMappings;

@implementation JSRestKitManagerFactory

// Already mapped rules for different classes. Uses for creating different REST classes
+ (NSDictionary *)restKitObjectMappings {

    if (!_restKitObjectMappings) {
        _restKitObjectMappings = [[NSMutableDictionary alloc] init];
        
        // Load mapping rules from mapping file
        NSDictionary *mappingRules = [JSClassesMappingRulesHelper loadedRules];
        
        for (NSString *className in mappingRules.keyEnumerator) {
            Class objectClass = NSClassFromString(className);
            
            RKObjectMapping *mapping = [self mappingForClass:objectClass forMappingRules:mappingRules];
            NSArray *mappingPaths = [[mappingRules objectForKey:className] objectForKey:JSKeyMappingPaths];
            
            // Initialize next structure: { @"mapping" : rkObjectMapping, @"paths" : nsArrayOfPaths }
            NSDictionary *pathsAndMappingForClass = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     mapping, _keyMapping,
                                                     mappingPaths, _keyPaths, 
                                                     nil];
            
            // Set mapping result for class
            [_restKitObjectMappings setObject:pathsAndMappingForClass forKey:className];
        }
    }
    
    return _restKitObjectMappings;
}

// Creates RestKit's mapping object for class (by name) using mapping rules from dictionary
+ (RKObjectMapping *)mappingForClass:(Class)objectClass forMappingRules:(NSDictionary *)mappingRules {
    
    // Get class name from Class object (for example: JSResourceDescriptor class -> @"JSResourceDescriptor")
    NSString *className = NSStringFromClass(objectClass);
    
    // Initialize class mapping from a Class object
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:objectClass];

    // Iterate true all mapping rule defined for specified class (by "className")
    for (NSDictionary *mappingRule in [[mappingRules objectForKey:className] objectForKey:JSKeyMappingRules]) {
        
        // Check if we have "property" type of mapping in class 
        if ([[mappingRule objectForKey:JSKeyMappingType] isEqualToString:JSPropertyMappingType]) {
            
            // Set property type of mapping (maps xmlNode in xml to property in class)
            [mapping mapKeyPath:[mappingRule objectForKey:JSKeyNode] toAttribute:[mappingRule objectForKey:JSKeyProperty]];
            
        // Check if we have nested objects and 1:n/1:1 relations between them
        // For example: one JSResourceDescriptor object may contains many JSResourceProperties
        } else if ([[mappingRule objectForKey:JSKeyMappingType] isEqualToString:JSRelationMappingType]) {
            
            // Get name of mapped class
            NSString *relationClassName = [mappingRule objectForKey:_keyClass];
            
            // Check if parent class has relation on himself. This prevents infinite recursive loop
            if (![relationClassName isEqualToString:className]) {
                
                // Check if mapping already exists in classesMappingRules and use it. Otherwise create new
                RKObjectMapping *relationMapping = [[[self restKitObjectMappings] objectForKey:relationClassName]
                                                    objectForKey:_keyMapping] ?: [self mappingForClass:NSClassFromString([mappingRule objectForKey:_keyClass]) forMappingRules:mappingRules];
                
                // Recursively set relation type of mapping
                [mapping mapKeyPath:[mappingRule objectForKey:JSKeyNode] toRelationship:[mappingRule objectForKey:JSKeyProperty]
                        withMapping:relationMapping];
            } else {
                // Add "mapping" of parent class if parent class has relation on himself
                [mapping mapKeyPath:[mappingRule objectForKey:JSKeyNode] toRelationship:[mappingRule objectForKey:JSKeyProperty]
                        withMapping:mapping];
            }
        }
    }
    
    return mapping;
}

// Sets object mapping rule for RestKit's object manager for different paths
+ (void)setObjectMapping:(RKObjectManager *)manager mapping:(RKObjectMapping *)mapping forKeyPaths:(NSArray *)paths {
    for (NSString *path in paths) {
        [manager.mappingProvider setMapping:mapping forKeyPath:path];
    }
}

+ (RKObjectManager *)createRestKitObjectManagerForClasses:(NSArray *)classes andServerProfile:(JSProfile *)serverProfile{
    // Creates RKObjectManager for loading and mapping encoded response (i.e XML, JSON etc.)
    // directly to objects
    RKObjectManager *restKitObjectManager = [RKObjectManager new];
    
    if (classes.count) {
        NSDictionary *restKitObjectMappings = [self restKitObjectMappings];
    
        // Set all mapping rules for provided classes to RestKit's object manager
        for (Class objectClass in classes) {
            NSDictionary *pathsAndMappingForClass = [restKitObjectMappings objectForKey:NSStringFromClass(objectClass)];
            RKObjectMapping *mapping = [pathsAndMappingForClass objectForKey:_keyMapping];
            [self setObjectMapping:restKitObjectManager mapping:mapping forKeyPaths:[pathsAndMappingForClass objectForKey:_keyPaths]];
            
            // Add custom error mapping class JSErrorDescriptor
            if ([JSErrorDescriptor class] == objectClass) {
                [self addCuctomErrorObjectMapping:restKitObjectManager mapping:mapping forKeyPaths:[pathsAndMappingForClass objectForKey:_keyPaths]];
            }
        }
    }
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

    _restKitObjectMappings = nil;
    
    return restKitObjectManager;    
}

+ (void) addCuctomErrorObjectMapping:(RKObjectManager *)manager mapping:(RKObjectMapping *)mapping forKeyPaths:(NSArray *)paths {
    [manager.mappingProvider setErrorMapping:nil];
    [manager.mappingProvider setValue:[NSMutableDictionary dictionary] forContext:RKObjectMappingProviderContextErrors];
    for (NSString *path in paths) {
        [manager.mappingProvider setMapping:mapping forKeyPath:path context:RKObjectMappingProviderContextErrors];
    }
}

@end
