//
//  JSXMLSerializer.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 30.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSSerializer.h"
#import <Foundation/Foundation.h>

/**
 Provides method that represents object as string in the XML format
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.0
 */
@interface JSXMLSerializer : NSObject <JSSerializer>

/**
 Returns an object representation of the string encoded in the XML format
 
 @param object The object for serialization
 @return A new string representation of object
 */
- (NSString *)stringFromObject:(id)object;

@end
