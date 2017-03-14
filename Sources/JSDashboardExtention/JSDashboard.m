/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSDashboard.h"

@implementation JSDashboard
#pragma mark - LifyCycle
- (instancetype)initWithResourceLookup:(JSResourceLookup *)resource
{
    self = [super init];
    if (self) {
        _resourceLookup = resource;
        _resourceURI = resource.uri;
    }
    return self;
}

+ (instancetype)dashboardWithResourceLookup:(JSResourceLookup *)resource
{
    return [[self alloc] initWithResourceLookup:resource];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    JSDashboard *newDashboard     = [[self class] allocWithZone:zone];
    newDashboard->_resourceLookup = [self.resourceLookup copyWithZone:zone];
    newDashboard->_resourceURI = [self.resourceURI copyWithZone:zone];
    if ([self.inputControls count]) {
        newDashboard.inputControls = [[NSArray alloc] initWithArray:self.inputControls copyItems:YES];
    }
    return newDashboard;
}

@end
