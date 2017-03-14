/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */

/**
 @author Olexander Dahno odahno@tibco.com
 @since 2.5
 */


#import "JSObjectMappingsProtocol.h"

typedef NS_ENUM(NSInteger, JSDashletHyperlinksTargetType) {
    JSDashletHyperlinksTargetTypeNone,
    JSDashletHyperlinksTargetTypeBlank,
    JSDashletHyperlinksTargetTypeSelf,
    JSDashletHyperlinksTargetTypeParent,
    JSDashletHyperlinksTargetTypeTop,
};

@interface JSDashboardComponent : NSObject <JSObjectMappingsProtocol>
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *resourceId;
@property (nonatomic, strong) NSString *resourceURI;
@property (nonatomic, strong) NSString *ownerResourceURI;
@property (nonatomic, strong) NSString *ownerResourceParameterName;
@property (nonatomic, assign) JSDashletHyperlinksTargetType dashletHyperlinkTarget;
@property (nonatomic, strong) NSString *dashletHyperlinkUrl;
@end
