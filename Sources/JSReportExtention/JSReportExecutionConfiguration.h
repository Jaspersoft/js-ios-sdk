/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.3
 */

#import <Foundation/Foundation.h>
#import "JSReportPagesRange.h"

@class JSProfile;

@interface JSReportExecutionConfiguration : NSObject

@property (nonatomic, assign) BOOL asyncExecution;
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, assign) BOOL freshData;
@property (nonatomic, assign) BOOL saveDataSnapshot;
@property (nonatomic, assign) BOOL ignorePagination;
@property (nonatomic, strong, nullable) NSString *transformerKey;
@property (nonatomic, strong, nonnull) NSString *outputFormat;
@property (nonatomic, strong, nonnull) NSString *attachmentsPrefix;
@property (nonatomic, copy, nonnull) JSReportPagesRange *pagesRange;

+(nonnull instancetype)saveReportConfigurationWithFormat:(nonnull NSString *)format pagesRange:(nonnull JSReportPagesRange *)pagesRange;

+(nonnull instancetype)viewReportConfigurationWithServerProfile:(nonnull JSProfile *)serverProfile;

@end
