/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <Foundation/Foundation.h>

@interface NSString(JSURLEncodings)

- (nonnull NSString *)hostEncodedString;

- (nonnull NSString *)queryEncodedString;
@end
