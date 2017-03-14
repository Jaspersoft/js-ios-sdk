/*
 * Copyright ©  2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSContentResource.h"

NSString * const kJSContentResourceFileFormat = @"kJSContentResourceFileFormat";
NSString * const kJSContentResourceContent = @"kJSContentResourceContent";

@implementation JSContentResource

#pragma mark - JSObjectMappingsProtocol

+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile {
    EKObjectMapping *mapping = [super objectMappingForServerProfile:serverProfile];
    [mapping mapPropertiesFromDictionary:@{
                                           @"type": @"fileFormat",
                                           @"content": @"content"
                                           }];
    return mapping;
}

+ (nonnull NSString *)requestObjectKeyPath {
    return @"contentResource";
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSContentResource *newResource  = [super copyWithZone:zone];
    newResource.fileFormat  = [self.fileFormat copyWithZone:zone];
    newResource.content     = [self.content copyWithZone:zone];
    
    return newResource;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:_fileFormat forKey:kJSContentResourceFileFormat];
    [aCoder encodeObject:_content forKey:kJSContentResourceContent];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.fileFormat = [aDecoder decodeObjectForKey:kJSContentResourceFileFormat];
        self.content = [aDecoder decodeObjectForKey:kJSContentResourceContent];
    }
    return self;
}
@end
