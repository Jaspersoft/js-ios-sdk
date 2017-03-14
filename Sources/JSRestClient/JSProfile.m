/*
 * Copyright © 2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSProfile.h"
#import "JSServerInfo.h"

NSString * const kJSSavedProfileAliasKey        = @"JSSavedSessionKey";
NSString * const kJSSavedProfileServerUrlKey    = @"JSSavedProfileServerUrlKey";
NSString * const kJSSavedProfileServerInfoKey   = @"JSSavedProfileServerInfoKey";
NSString * const kJSSavedProfileKeepSessionKey  = @"JSSavedProfileKeepSessionKey";


@implementation JSProfile
- (nonnull instancetype)initWithAlias:(nonnull NSString *)alias serverUrl:(nonnull NSString *)serverUrl {
    if (self = [super init]) {
        _alias = alias;
        _serverUrl = (([serverUrl characterAtIndex:serverUrl.length - 1] == '/') ? [serverUrl substringToIndex:serverUrl.length - 1] : serverUrl).lowercaseString;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSProfile *copiedProfile = [[[self class] allocWithZone:zone] initWithAlias:self.alias
                                                                      serverUrl:self.serverUrl];
    copiedProfile.serverInfo = [self.serverInfo copyWithZone:zone];
    copiedProfile.keepSession = self.keepSession;
    return copiedProfile;
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_alias forKey:kJSSavedProfileAliasKey];
    [aCoder encodeObject:_serverUrl forKey:kJSSavedProfileServerUrlKey];
    [aCoder encodeObject:_serverInfo forKey:kJSSavedProfileServerInfoKey];
    [aCoder encodeBool:_keepSession forKey:kJSSavedProfileKeepSessionKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _alias = [aDecoder decodeObjectForKey:kJSSavedProfileAliasKey];
        _serverUrl = [aDecoder decodeObjectForKey:kJSSavedProfileServerUrlKey];
        _serverInfo = [aDecoder decodeObjectForKey:kJSSavedProfileServerInfoKey];
        _keepSession = [aDecoder decodeBoolForKey:kJSSavedProfileKeepSessionKey];
    }
    return self;
}
@end
