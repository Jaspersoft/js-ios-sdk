/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.3
 */

#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"
#import "JSResourceLookup.h"
#import "JSPatchResourceParameter.h"

@interface JSResourcePatchRequest : NSObject <JSObjectMappingsProtocol>

@property (nonatomic, strong, nonnull) NSNumber *version;
@property (nonatomic, strong, nonnull) NSArray <JSPatchResourceParameter *> *patch;

- (nonnull instancetype)initWithResource:(nonnull JSResourceLookup *)resource;

+ (nonnull instancetype)patchRecuestWithResource:(nonnull JSResourceLookup *)resource;

@end
