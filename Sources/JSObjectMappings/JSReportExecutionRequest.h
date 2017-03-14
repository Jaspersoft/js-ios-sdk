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
#import "JSReportParameter.h"

/**
 Represents a report execution request descriptor for convenient XML serialization process
 */
@interface JSReportExecutionRequest : NSObject <JSObjectMappingsProtocol>

@property (nonatomic, retain, nonnull) NSString *reportUnitUri;
@property (nonatomic, retain, nonnull) NSString *async;
@property (nonatomic, retain, nonnull) NSString *outputFormat;
@property (nonatomic, retain, nonnull) NSString *interactive;
@property (nonatomic, retain, nonnull) NSString *freshData;
@property (nonatomic, retain, nonnull) NSString *saveDataSnapshot;
@property (nonatomic, retain, nonnull) NSString *ignorePagination;
@property (nonatomic, retain, nonnull) NSString *baseURL;
@property (nonatomic, retain, nullable) NSString *transformerKey;
@property (nonatomic, retain, nullable) NSString *pages;
@property (nonatomic, retain, nullable) NSString *attachmentsPrefix;
@property (nonatomic, assign) JSMarkupType markupType;
@property (nonatomic, retain, nullable) NSArray <JSReportParameter *> *parameters;

@end
