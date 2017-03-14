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


@interface JSInputControlOption : NSObject <JSObjectMappingsProtocol, NSCopying>

@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, assign) BOOL selected;

@end
