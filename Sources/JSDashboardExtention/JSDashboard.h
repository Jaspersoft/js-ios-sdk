/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.6
 */

#import <Foundation/Foundation.h>
#import "JSResourceLookup.h"
#import "JSInputControlDescriptor.h"

@interface JSDashboard : NSObject <NSCopying>
// getters
@property (nonatomic, strong, readonly) JSResourceLookup *resourceLookup;
@property (nonatomic, copy, readonly) NSString *resourceURI;
@property (nonatomic, copy) NSArray <JSInputControlDescriptor *>*inputControls;

- (instancetype)initWithResourceLookup:(JSResourceLookup *)resource;
+ (instancetype)dashboardWithResourceLookup:(JSResourceLookup *)resource;

@end
