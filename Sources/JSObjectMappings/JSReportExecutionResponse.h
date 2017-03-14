/*
 * Copyright © 2013 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.7
 */

#import "JSErrorDescriptor.h"
#import "JSExecutionStatus.h"
#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"
#import "JSExportExecutionResponse.h"

/**
 Represents a report execution entity for convenient XML serialization process
 */
@interface JSReportExecutionResponse : NSObject <JSObjectMappingsProtocol>

@property (nonatomic, retain, nullable) NSNumber *totalPages;
@property (nonatomic, retain, nonnull) NSNumber *currentPage;
@property (nonatomic, retain, nonnull) NSString *reportURI;
@property (nonatomic, retain, nonnull) NSString *requestId;
@property (nonatomic, retain, nonnull) NSArray <JSExportExecutionResponse *> *exports;
@property (nonatomic, retain, nonnull) JSExecutionStatus *status;
@property (nonatomic, retain, nullable) JSErrorDescriptor *errorDescriptor;

@end
