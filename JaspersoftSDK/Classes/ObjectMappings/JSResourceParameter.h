//
//  JSResourceParameter.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 06.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class represents a resource parameter entity for convenient XML serialization process.
 
 @author Vlad Zavadskii
 @version 1.0
 */
@interface JSResourceParameter : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *isListItem;
@property (nonatomic, retain) NSString *value;

- (id)initWithName:(NSString *)name isListItem:(NSString *)isListItem value:(NSString *)value;
- (NSString *)description;

@end
