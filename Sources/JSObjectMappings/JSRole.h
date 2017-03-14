/*
 * Copyright © 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.6
 */

#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"


@interface JSRole : NSObject <JSObjectMappingsProtocol>

@property (nonatomic, assign) BOOL externallyDefined;
@property (nonatomic, strong) NSString *name;

@end
