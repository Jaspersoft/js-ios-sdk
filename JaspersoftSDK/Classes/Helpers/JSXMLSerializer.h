//
//  JSXMLSerializer.h
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 30.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSSerializer.h"
#import <Foundation/Foundation.h>

@interface JSXMLSerializer : NSObject <JSSerializer>

/**
 Returns an object representation of the string encoded in the XML format
 */
- (NSString *)stringFromObject:(id)object;

@end
