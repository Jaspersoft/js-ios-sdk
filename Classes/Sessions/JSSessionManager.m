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
#import "JSSessionManager.h"

static JSSessionManager *_sharedManager = nil;

@interface JSSessionManager ()
@property (nonatomic, strong, readwrite) JSSession *currentSession;

@end

@implementation JSSessionManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [JSSessionManager new];
    });
    
    return _sharedManager;
}

- (void) createSessionWithServerProfile:(JSProfile *)serverProfile keepLogged:(BOOL)keepLogged completion:(void(^)(BOOL success))completionBlock{
    self.currentSession = [[JSSession alloc] initWithServerProfile:serverProfile keepLogged:keepLogged];
    [self.currentSession authenticationTokenWithCompletion:completionBlock];
}

- (void) saveActiveSessionIfNeeded {
    if (self.currentSession && self.currentSession.keepSession) {
        [NSKeyedArchiver archivedDataWithRootObject:self.currentSession];
    }
}

- (void) restoreLastSessionWithCompletion:(void(^)(BOOL success))completionBlock {
    if (completionBlock) {
        if (self.currentSession && [self.currentSession isSessionAuthorized]) {
            completionBlock(YES);
        }
        
        NSData *savedSession = [[NSUserDefaults standardUserDefaults] objectForKey:kJSSavedSessionKey];
        if (savedSession) {
            id unarchivedSession = [NSKeyedUnarchiver unarchiveObjectWithData:savedSession];
            if (unarchivedSession && [unarchivedSession isKindOfClass:[JSSession class]] && [unarchivedSession keepSession]) {
                self.currentSession = unarchivedSession;
                if ([self.currentSession isSessionAuthorized]) {
                    completionBlock(YES);
                } else {
                    [self.currentSession authenticationTokenWithCompletion:completionBlock];
                }
            }
        }
        completionBlock(NO);
    }
}


@end
