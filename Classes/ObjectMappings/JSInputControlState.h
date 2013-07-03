//
//  JSInputControlState.h
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
@interface JSInputControlState : NSObject

@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *uri;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSArray /*<JSInputControlOption>*/ *options;

@end
