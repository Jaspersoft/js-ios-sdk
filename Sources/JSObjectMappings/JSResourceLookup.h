/*
 * Copyright © 2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.7
 */

#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"

typedef NS_ENUM (NSInteger, JSPermissionMask) {
    JSPermissionMask_Administration = 1 << 0,
    JSPermissionMask_Read = 1 << 1,
    JSPermissionMask_Write = 1 << 2,
    JSPermissionMask_Create = 1 << 3,
    JSPermissionMask_Delete = 1 << 4,
    JSPermissionMask_Execute = 1 << 5
};

/**
 Represents a resource lookup entity for convenient XML serialization process.
 */
@interface JSResourceLookup : NSObject <JSObjectMappingsProtocol, NSCopying, NSSecureCoding>

@property (nonatomic, retain, nonnull) NSString *label;
@property (nonatomic, retain, nonnull) NSString *uri;
@property (nonatomic, retain, nullable) NSString *resourceDescription;
@property (nonatomic, retain, nonnull) NSString *resourceType;
@property (nonatomic, retain, nonnull) NSNumber *version;
@property (nonatomic, retain, nonnull) NSNumber *permissionMask;
@property (nonatomic, retain, nonnull) NSDate *creationDate;
@property (nonatomic, retain, nonnull) NSDate *updateDate;

@end
