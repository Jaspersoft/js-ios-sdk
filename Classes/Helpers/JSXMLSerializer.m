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
//  JSXMLSerializer.m
//  Jaspersoft Corporation
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

// TODO: refactor this "god" method
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
                
                if ([propertyValue isKindOfClass:[NSArray class]]) {
                    for (id value in propertyValue) {
                        [writer writeStartElement:node];
                        [writer writeCData:value];
                        [writer writeEndElement];
                    }
                } else {
                    isParentNodeWasClosed = YES;
                    if (!isBodyOfElement) {
                        [writer writeStartElement:node];
                    }
                    
                    [writer writeCData:[propertyValue description]];
                    
                    if (!isBodyOfElement) {
                        [writer writeEndElement];
                    }
                }
            }
        } else if ([mappingType isEqualToString:JSRelationMappingType] && [propertyValue count]) {
            // Recursive generate XML for children nodes
            for (id child in propertyValue) {
                if (!isParentNodeWasClosed) {
                    [writer writeCloseStartElement];
                    isParentNodeWasClosed = YES;
                }
                [writer write:[self stringFromObject:child]];
            }
        }
    }
    
    [writer writeEndElement];
    [writer writeEndDocument];
    
    return [writer toString];
}

@end
