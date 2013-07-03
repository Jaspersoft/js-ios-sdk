//
//  JSReportParameter.h
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 07.11.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.4
 */
@interface JSReportParameter : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *value;

- (id)initWithName:(NSString *)name value:(NSArray *)value;

@end
