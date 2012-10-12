//
//  JSResourceProperty.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 05.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents a resource property entity for convenient XML serialization process.
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @version 1.0
 */
@interface JSResourceProperty : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSArray *childResourceProperties; 

- (NSString *)description;

@end
