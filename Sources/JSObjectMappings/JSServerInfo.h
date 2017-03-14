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

@interface JSServerInfo : NSObject <JSObjectMappingsProtocol, NSSecureCoding, NSCopying>

@property (nonatomic, retain) NSString *build;
@property (nonatomic, retain) NSString *edition;
@property (nonatomic, retain) NSString *editionName;
@property (nonatomic, retain) NSString *expiration;
@property (nonatomic, retain) NSString *features;
@property (nonatomic, retain) NSString *licenseType;
@property (nonatomic, retain) NSString *version;
@property (nonatomic, retain) NSString *dateFormatPattern;
@property (nonatomic, retain) NSString *datetimeFormatPattern;

@property (nonatomic, strong, readonly) NSDateFormatter *serverDateFormatFormatter;

- (float)versionAsFloat;

@end
