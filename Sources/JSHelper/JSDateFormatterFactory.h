/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @since 2.5
 */

#import <Foundation/Foundation.h>

@interface JSDateFormatterFactory : NSObject
+ (instancetype)sharedFactory;
- (NSDateFormatter *)formatterWithPattern:(NSString *)pattern;
- (NSDateFormatter *)formatterWithPattern:(NSString *)pattern timeZone:(NSTimeZone *)timeZone;
@end
