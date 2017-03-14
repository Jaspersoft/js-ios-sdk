/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.8
 */


#import <Foundation/Foundation.h>
#import "JSErrorDescriptor.h"
#import "JSExecutionStatus.h"
#import "JSReportOutputResource.h"
#import "JSObjectMappingsProtocol.h"

/**
 Represents an export entity for convenient XML serialization process
 */
@interface JSExportExecutionResponse : NSObject <JSObjectMappingsProtocol>

@property (nonatomic, retain, nonnull) NSString *uuid;
@property (nonatomic, retain, nonnull) JSExecutionStatus *status;
@property (nonatomic, retain, nullable) JSErrorDescriptor *errorDescriptor;
@property (nonatomic, retain, nullable) JSReportOutputResource *outputResource;
@property (nonatomic, retain, nullable) NSArray <JSReportOutputResource *> *attachments;

@end
