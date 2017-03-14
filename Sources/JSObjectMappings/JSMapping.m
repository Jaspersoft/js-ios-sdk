/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSMapping.h"

@interface JSMapping ()
@property (nonatomic, strong, readwrite) EKObjectMapping *objectMapping;
@property (nonatomic, strong, readwrite) NSString *keyPath;

@end

@implementation JSMapping
- (instancetype) initWithObjectMapping:(EKObjectMapping *)objectMapping keyPath:(NSString *)keyPath {
    self = [super init];
    if (self) {
        self.objectMapping = objectMapping;
        self.keyPath = keyPath;
    }
    return self;
}

+ (instancetype) mappingWithObjectMapping:(EKObjectMapping *)objectMapping keyPath:(NSString *)keyPath {
    return [[self alloc] initWithObjectMapping:objectMapping keyPath:keyPath];
}

@end
