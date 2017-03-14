/*
 * Copyright ©  2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.3
 */


#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"

@interface JSDataType : NSObject <JSObjectMappingsProtocol, NSCopying>

@property (nonatomic, assign) kJS_DT_TYPE type;
@property (nonatomic, strong) NSString *pattern;
@property (nonatomic, strong) id maxValue;
@property (nonatomic, strong) id minValue;
@property (nonatomic, assign) BOOL strictMax;
@property (nonatomic, assign) BOOL strictMin;
@property (nonatomic, assign) NSInteger maxLength;

@end
