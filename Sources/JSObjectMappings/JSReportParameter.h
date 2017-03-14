/*
 * Copyright © 2013 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.4
 */

#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"
#import "JSParameter.h"

@interface JSReportParameter : JSParameter <JSObjectMappingsProtocol, NSCopying>

@end
