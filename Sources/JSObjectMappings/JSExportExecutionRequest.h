/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.9
 */


#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"

/**
 Represents a export execution request descriptor for convenient XML serialization process
 */
@interface JSExportExecutionRequest : NSObject<JSObjectMappingsProtocol>

@property (nonatomic, retain, nonnull) NSString *outputFormat;
@property (nonatomic, retain, nullable) NSString *pages;
@property (nonatomic, retain, nullable) NSString *attachmentsPrefix;
@property (nonatomic, retain, nonnull) NSString *baseUrl;
@property (nonatomic, assign) JSMarkupType markupType;
@end
