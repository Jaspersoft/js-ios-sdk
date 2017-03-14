/*
 * Copyright ©  2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @since 2.2.1
 */

#import "JSObjectMappingsProtocol.h"
#import "JSResourceLookup.h"

@interface JSContentResource : JSResourceLookup <JSObjectMappingsProtocol>
@property (nonatomic, retain, nonnull) NSString *content; //Base64 Data
@property (nonatomic, retain, nonnull) NSString *fileFormat; //Format
@end
