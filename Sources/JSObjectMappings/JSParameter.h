/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.3
 */


#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"

@interface JSParameter : NSObject <JSObjectMappingsProtocol, NSCopying>

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nullable) id value;

- (nonnull instancetype)initWithName:(nonnull NSString *)name value:(nullable id)value;

+ (nonnull instancetype)parameterWithName:(nonnull NSString *)name value:(nullable id)value;

@end
