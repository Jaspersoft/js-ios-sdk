/*
 * Copyright © 2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.8
 */


#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"

/**
 Represents an output resource for convenient XML serialization process
 */
@interface JSReportOutputResource : NSObject <JSObjectMappingsProtocol>

@property (nonatomic, retain, nonnull) NSString *contentType;
@property (nonatomic, retain, nonnull) NSString *fileName;

@end
