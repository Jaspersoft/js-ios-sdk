/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.6
 */

#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"
#import "JSDashboardParameter.h"

@interface JSDashboardExportExecutionResource : NSObject <JSObjectMappingsProtocol>
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;

@property (nonatomic, strong) NSArray <JSDashboardParameter *> *parameters;

@end
