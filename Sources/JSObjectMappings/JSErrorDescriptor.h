/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.8
 */


#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"

/**
 Represents an error descriptor for convenient XML serialization process
 */

@interface JSErrorDescriptor : NSObject <JSObjectMappingsProtocol>

@property (nonatomic, retain, nonnull) NSString *message;
@property (nonatomic, retain, nonnull) NSString *errorCode;
@property (nonatomic, retain, nullable) NSArray <NSString *> *parameters;

@end
