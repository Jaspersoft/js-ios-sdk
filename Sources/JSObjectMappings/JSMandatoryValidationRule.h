/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.9
 */

#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"


@interface JSMandatoryValidationRule : NSObject <JSObjectMappingsProtocol, NSCopying>

@property (nonatomic, retain) NSString *errorMessage;

@end
