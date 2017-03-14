/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.2
 */


#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"

@class JSInputControlDescriptor;

@interface JSReportOption : NSObject <JSObjectMappingsProtocol, NSCopying>
@property (nonatomic, strong, nullable) NSString *uri;
@property (nonatomic, strong, nullable) NSString *identifier;
@property (nonatomic, strong, nullable) NSString *label;

@property (nonatomic, strong, nullable) NSArray <JSInputControlDescriptor *> *inputControls;

- (BOOL)isEqual:(nullable id)object;

+ (nonnull JSReportOption *)defaultReportOption;

@end
