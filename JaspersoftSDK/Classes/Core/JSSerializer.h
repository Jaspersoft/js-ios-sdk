//
//  JSSerializer.h
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 30.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Declares method that a class must implement so that it can provide support of 
 representing object as string
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.3
 */
@protocol JSSerializer <NSObject>

@required

/**
 Returns an object representation of the string encoded in the
 format provided by the serializer (i.e. JSON, XML, etc).
 
 @param object The object for serialization
 @return A new string representation of object
 */
- (NSString *)stringFromObject:(id)object;

@end
