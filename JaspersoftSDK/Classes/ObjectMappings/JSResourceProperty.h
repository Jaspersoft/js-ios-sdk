//
//  JSResourceProperty.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 05.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class represents a resource property entity for convenient XML serialization process.
 
 @page JSResourceProperty.h
 @author Vlad Zavadskii
 @version 1.0
 */
@interface JSResourceProperty : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSArray *childResourceProperties; 

- (NSString *)description;

@end
