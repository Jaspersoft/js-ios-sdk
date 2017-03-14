/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.8
 */


#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"
#import "JSConstants.h"

/**
 Represents a report or export execution status for convenient XML serialization process
 */
@interface JSExecutionStatus : NSObject <JSObjectMappingsProtocol>
@property (nonatomic, assign) kJS_EXECUTION_STATUS status;
@end
