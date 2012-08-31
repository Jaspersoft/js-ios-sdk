//
//  JSResourceParameter.h
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 06.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents a resource parameter entity for convenient XML serialization process.
 
 @author Vlad Zavadskyi
 @version 1.0
 */
@interface JSResourceParameter : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *isListItem;
@property (nonatomic, retain) NSString *value;

/**
 Returns a configured resource parameter. Used by class implemented 
 <code>JSSerializer</code> protocol
 
 @param name The parameter name
 @param isListItem Indicates if parameter is part (item) of list
 @param value The parameter value
 @return A configured JSResourceParameter instance
 */
- (id)initWithName:(NSString *)name isListItem:(NSString *)isListItem value:(NSString *)value;
- (NSString *)description;

@end
