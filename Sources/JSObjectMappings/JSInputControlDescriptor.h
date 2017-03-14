/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.4
 */

#import "JSInputControlState.h"
#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"
#import "JSMandatoryValidationRule.h"
#import "JSDateTimeFormatValidationRule.h"
#import "JSDataType.h"


@interface JSInputControlDescriptor : NSObject <JSObjectMappingsProtocol, NSCopying>

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *mandatory;
@property (nonatomic, strong) NSString *readOnly;
@property (nonatomic, assign) kJS_ICD_TYPE type;
@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) NSString *visible;
@property (nonatomic, strong) NSArray <NSString *> *masterDependencies;
@property (nonatomic, strong) NSArray <NSString *> *slaveDependencies;
@property (nonatomic, strong) JSDataType *dataType;
@property (nonatomic, strong) JSInputControlState *state;

@property (nonatomic, readonly) JSDateTimeFormatValidationRule *dateTimeFormatValidationRule;
@property (nonatomic, readonly) JSMandatoryValidationRule *mandatoryValidationRule;


- (NSArray *)selectedValues;

/**
 Returns error string for current input control descriptor, according to validation rules and state error.
 
 @return error string for current input control descriptor, according to validation rules and state error
 */
- (NSString *)errorString;

@end
