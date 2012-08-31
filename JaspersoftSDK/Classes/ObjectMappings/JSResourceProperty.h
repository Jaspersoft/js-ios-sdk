//
//  JSResourceProperty.h
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 05.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents a resource property entity for convenient XML serialization process.
 
 @author Vlad Zavadskyi
 @version 1.0
 */
@interface JSResourceProperty : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSArray *childResourceProperties; 

- (NSString *)description;

@end
