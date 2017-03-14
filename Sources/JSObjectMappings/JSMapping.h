/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */

#import <Foundation/Foundation.h>
#import "EKObjectMapping.h"

@interface JSMapping : NSObject
@property (nonatomic, strong, readonly) EKObjectMapping *objectMapping;
@property (nonatomic, strong, readonly) NSString *keyPath;

- (instancetype) initWithObjectMapping:(EKObjectMapping *)objectMapping keyPath:(NSString *)keyPath;
+ (instancetype) mappingWithObjectMapping:(EKObjectMapping *)objectMapping keyPath:(NSString *)keyPath;

@end
