//
//  JSInputControlOption.h
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 01.11.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.4
 */
@interface JSInputControlOption : NSObject

@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *selected;

@end
