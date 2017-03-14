/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @since 2.3
 */

#import "JSObjectMappingsProtocol.h"

@interface JSScheduleJobState : NSObject <JSObjectMappingsProtocol>
@property (nonatomic, strong) NSDate *nextFireTime;
@property (nonatomic, strong) NSDate *previousFireTime;
@property (nonatomic, strong) NSString *value;
@end
