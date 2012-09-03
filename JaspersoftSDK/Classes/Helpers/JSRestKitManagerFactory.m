//
//  JSRestKitManagerFactory.m
//  RestKitDemo
//
//  Created by Volodya Sabadosh on 7/17/12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSRestKitManagerFactory.h"
#import "JSClassesMappingRulesHelper.h"

// Define helper keys for _restKitObjectMappings dictionary
static NSString * const _keyMapping = @"mapping";
static NSString * const _keyPaths = @"paths";
static NSString * const _keyClass = @"class";

@implementation JSRestKitManagerFactory

// Already mapped rules for different classes. Uses for creating different JSREST
// classes (version of cache)
+ (NSDictionary *)restKitObjectMappings {
    static NSMutableDictionary *_restKitObjectMappings = nil;
    
    if (!_restKitObjectMappings) {
        _restKitObjectMappings = [[NSMutableDictionary alloc] init];
        
        // Load mapping rules from mapping file
        NSDictionary *mappingRules = [JSClassesMappingRulesHelper loadedRules];
        
        for (NSString *className in mappingRules.keyEnumerator) {
            Class objectClass = NSClassFromString(className);
            
            RKObjectMapping *mapping = [self mappingForClass:objectClass forMappingRules:mappingRules];
            NSArray *mappingPaths = [[mappingRules objectForKey:className] objectForKey:JSKeyMappingPaths];
            
            // Initialize next structure: { @"mapping" : rkObjectMapping, @"paths" : nsArrayOfPaths }
            NSDictionary *pathsAndMappingForClass = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     mapping, _keyMapping,
                                                     mappingPaths, _keyPaths, 
                                                     nil];
            
            // Set mapping result for class
            [_restKitObjectMappings setObject:pathsAndMappingForClass forKey:objectClass];
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
                // Add "mapping" of parent class if parrent class has relation on himself 
                [mapping mapKeyPath:[mappingRule objectForKey:JSKeyNode] toRelationship:[mappingRule objectForKey:JSKeyProperty]
                        withMapping:mapping];
            }
        }
    }
    
    return mapping;
}

// Set object mapping rule for RestKit's object manager for different paths
+ (void)setObjectMapping:(RKObjectManager *)manager mapping:(RKObjectMapping *)mapping forKeyPaths:(NSArray *)paths {
    for (NSString *path in paths) {
        [manager.mappingProvider setMapping:mapping forKeyPath:path];
    }
}

+ (RKObjectManager *)createRestKitObjectManagerForClasses:(NSArray *)classes {
    if (!classes.count) {
        return nil;
    }
    
    NSDictionary *restKitObjectMappings = [self restKitObjectMappings];    
    
    // Creates RKObjectManager for loading and mapping encoded response (i.e XML, JSON etc.) 
    // directly to objects
    RKObjectManager *restKitObjectManager = [[RKObjectManager alloc] init];
    
    // Set all mapping rules for provided classes to RestKit's object manager
    for (Class objectClass in classes) {
        NSDictionary *pathsAndMappingForClass = [restKitObjectMappings objectForKey:objectClass];
        RKObjectMapping *mapping = [pathsAndMappingForClass objectForKey:_keyMapping];
        
        [self setObjectMapping:restKitObjectManager mapping:mapping forKeyPaths:[pathsAndMappingForClass objectForKey:_keyPaths]];
    }
    
    return restKitObjectManager;    
}


@end
