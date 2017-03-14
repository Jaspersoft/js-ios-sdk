/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.4
 */

#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"
#import "JSInputControlOption.h"

@interface JSInputControlState : NSObject <JSObjectMappingsProtocol, NSCopying>

@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *uri;
@property (nonatomic, retain) NSString *value;
/** @since 1.6 */
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSArray <JSInputControlOption *> *options;

@end
