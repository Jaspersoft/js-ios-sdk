/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2014 Jaspersoft Corporation. All rights reserved.
 * http://community.jaspersoft.com/project/mobile-sdk-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is part of Jaspersoft Mobile SDK for iOS.
 *
 * Jaspersoft Mobile SDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Jaspersoft Mobile SDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Jaspersoft Mobile SDK for iOS. If not, see
 * <http://www.gnu.org/licenses/lgpl>.
 */

//
//  JSSessionManager.h
//  Jaspersoft Corporation
//

#import "JSSession.h"
#import "JSProfile.h"

NSString * const kJSSavedSessionKey                 = @"JSSavedSessionKey";
NSString * const kJSSavedSessionServerProfileKey    = @"JSSavedSessionServerProfileKey";
NSString * const kJSSavedSessionTimeoutKey          = @"JSSavedSessionTimeoutKey";
NSString * const kJSSavedSessionKeepSessionKey      = @"JSSavedSessionKeepSessionKey";

@interface JSSession ()
//@property (nonatomic, strong, readwrite) JSProfile *serverProfile;
@property (nonatomic, assign, readwrite) BOOL keepSession;

@end

@implementation JSSession

- (instancetype)initWithServerProfile:(JSProfile *)serverProfile keepLogged:(BOOL)keepLogged{
    self = [super initWithServerProfile:serverProfile];
    if (self) {
        self.keepSession = keepLogged;
    }
    return self;
}

- (BOOL)isSessionAuthorized {
    return [[self cookies] count];
}

- (void)authenticationTokenWithCompletion:(JSRequestCompletionBlock)completionBlock {
    JSRequest *request = [[JSRequest alloc] initWithUri:[JSConstants sharedInstance].REST_AUTHENTICATION_URI];
    request.restVersion = JSRESTVersion_None;
    request.method = RKRequestMethodPOST;
    request.completionBlock = completionBlock;
    [self sendRequest:request];
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.serverProfile forKey:kJSSavedSessionServerProfileKey];
    [aCoder encodeBool:self.keepSession forKey:kJSSavedSessionKeepSessionKey];
    [aCoder encodeFloat:self.timeoutInterval forKey:kJSSavedSessionTimeoutKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.serverProfile = [aDecoder decodeObjectForKey:kJSSavedSessionServerProfileKey];
        self.keepSession = [aDecoder decodeBoolForKey:kJSSavedSessionKeepSessionKey];
        self.timeoutInterval = [aDecoder decodeFloatForKey:kJSSavedSessionTimeoutKey];
    }
    return self;
}

@end
