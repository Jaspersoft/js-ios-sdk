/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @since 2.2.1
 */

#import "JSRESTBase.h"

@class JSResourceLookup;
@class JSContentResource;

@interface JSRESTBase(JSRESTContentResource)
- (void)contentResourceWithResourceLookup:(JSResourceLookup *)resourceLookup
                               completion:(void(^)(JSContentResource *resource, NSError *error))completion;
@end
