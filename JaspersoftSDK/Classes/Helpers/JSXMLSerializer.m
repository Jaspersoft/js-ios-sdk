//
//  JSXMLSerializer.m
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 30.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "XMLWriter.h"
#import "JSXMLSerializer.h"
#import "JSClassesMappingRulesHelper.h"

@interface JSXMLSerializer()

@property (nonatomic, retain) NSDictionary *mappingRules;

@end

@implementation JSXMLSerializer

@synthesize mappingRules = _mappingRules;

- (id)init {
    if (self = [super init]) {
        self.mappingRules = [JSClassesMappingRulesHelper loadedRules];
    }
    
    return self;
}

- (NSString *)stringFromObject:(id)object {
    XMLWriter *writer = [[XMLWriter alloc] init];
    
    NSString *className = NSStringFromClass([object class]);
    NSArray *loadedRules = [[self.mappingRules objectForKey:className] objectForKey:JSKeyMappingRules];
    NSString *rootNode = [[self.mappingRules objectForKey:className] objectForKey:JSKeyRootNode];
    // Shows if parent node was closed for preventing serializing wrong XML format
    // In example wrong XML can be "<resourceDescriptor <resourceProperty></resourceProperty></resourceDescriptor>"
    // where 1-st element wasn't closed
    BOOL isParentNodeWasClosed = NO;

    [writer writeStartElement:rootNode];
    
    for (NSDictionary *mappingRule in loadedRules) {
        NSString *mappingType = [mappingRule objectForKey:JSKeyMappingType];
        NSString *node = [mappingRule objectForKey:JSKeyNode];        
        // Check if this is a body of an XML element (i.e. <element>body</element>)
        BOOL isBodyOfElement = [node isEqualToString:rootNode];
        id propertyValue = [object valueForKey:[mappingRule objectForKey:JSKeyProperty]];
        
        // Check what is the mapping type (relation or property)
        if ([mappingType isEqualToString:JSPropertyMappingType] && propertyValue) {
            // Check if we have an attribute in XML (i.e. <node attribute="value">...)
            if ([[mappingRule objectForKey:JSKeyIsAttr] boolValue]) {
                [writer writeAttribute:node value:[propertyValue description]];
            } else {
                // Writing next element
                isParentNodeWasClosed = YES;
                if (!isBodyOfElement) {
                    [writer writeStartElement:node];
                }
                
                [writer writeCData:[propertyValue description]];
                
                if (!isBodyOfElement) {
                    [writer writeEndElement];
                }
            }
        } else if ([mappingType isEqualToString:JSRelationMappingType] && [propertyValue count]) {
            // Check if parent node for children nodes should be written
            // (i.e. <elements><element1></element1>...</elements> where <elements> is a parent node
            BOOL useNodeInSerialization = [[mappingRule objectForKey:JSKeyUseNodeInSerialization] boolValue];
            if(useNodeInSerialization) {
                [writer writeStartElement:node];
                [writer writeCloseStartElement];
            }
            
            // Recursive generate XML for children nodes
            for (id child in propertyValue) {
                if (!isParentNodeWasClosed) {
                    [writer writeCloseStartElement];
                    isParentNodeWasClosed = YES;
                }
                [writer write:[self stringFromObject:child]];
            }
            
            if(useNodeInSerialization) {
                [writer writeEndElement];
            }
        }
    }
    
    [writer writeEndElement];
    [writer writeEndDocument];
    
    return [writer toString];
}

@end
