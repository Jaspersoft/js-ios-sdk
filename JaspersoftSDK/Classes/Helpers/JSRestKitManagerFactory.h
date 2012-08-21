//
//  JSRestKitManagerFactory.h
//  RestKitDemo
//
//  Created by Volodya Sabadosh on 7/17/12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <Foundation/Foundation.h>

@interface JSRestKitManagerFactory : NSObject

// Create RKObjectManager with mappings for specified classes
+ (RKObjectManager *)createRestKitObjectManagerForClasses:(NSArray *)classes;

@end
