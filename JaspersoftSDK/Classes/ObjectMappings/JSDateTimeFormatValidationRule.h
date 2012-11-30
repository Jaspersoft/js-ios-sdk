//
//  JSDateTimeFormatValidationRule.h
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 12.11.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.4
 */
@interface JSDateTimeFormatValidationRule : NSObject

@property (nonatomic, retain) NSString *errorMessage;
@property (nonatomic, retain) NSString *format;

@end