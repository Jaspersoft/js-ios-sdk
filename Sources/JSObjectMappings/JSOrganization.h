/*
 * Copyright © 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.6
 */

#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"


@interface JSOrganization : NSObject <JSObjectMappingsProtocol>

@property (nonatomic, strong) NSString *organizationId;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *tenantName;
@property (nonatomic, strong) NSString *tenantDescription;
@property (nonatomic, strong) NSString *tenantNote;
@property (nonatomic, strong) NSString *tenantUri;
@property (nonatomic, strong) NSString *tenantFolderUri;
@property (nonatomic, strong) NSString *theme;

@end
