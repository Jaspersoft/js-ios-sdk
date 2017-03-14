/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */

/**
 @author Olexandr Dahno odahno@tibco.com
 @since 2.3
 */

#import "JSObjectMappingsProtocol.h"
@class JSScheduleJobState;

@interface JSScheduleLookup : NSObject <JSObjectMappingsProtocol>
@property (nonatomic, assign) NSInteger jobIdentifier;
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) NSString *reportUnitURI;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *scheduleDescription;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *reportLabel;
@property (nonatomic, strong) JSScheduleJobState *state;
@end
