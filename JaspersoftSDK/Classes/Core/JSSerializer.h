//
//  JSSerializer.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 30.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The JSSerializer protocol declares method that a class must implement so that it 
 can provide support of representing object as string
 */
@protocol JSSerializer <NSObject>

@required

/**
 Returns an object representation of the string encoded in the
 format provided by the serializer (i.e. JSON, XML, etc).
 */
- (NSString *)stringFromObject:(id)object;

@end
