/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.6
 */


#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"
#import "JSExecutionStatus.h"

@interface JSDashboardExportExecutionStatus : NSObject <JSObjectMappingsProtocol>
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSNumber *progress;
@property (nonatomic, strong) JSExecutionStatus *status;

@end
