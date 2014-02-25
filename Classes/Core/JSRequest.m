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
//  JSRequest.m
//  Jaspersoft Corporation
//

#import "JSRequest.h"

// TODO: add request success and request finish delegate methods
@implementation JSRequest

@synthesize uri = _uri;
@synthesize body = _body;
@synthesize params = _params;
@synthesize timeoutInterval = _timeoutInterval;
@synthesize method = _method;
@synthesize delegate = _delegate;
@synthesize finishedBlock;
@synthesize responseAsObjects = _responseAsObjects;
@synthesize downloadDestinationPath = _downloadDestinationPath;
@synthesize asynchronous = _asynchronous;
@synthesize restVersion = _restVersion;

#if TARGET_OS_IPHONE
@synthesize requestBackgroundPolicy = _requestBackgroundPolicy;
#endif

- (id)initWithUri:(NSString *)uri {
    if (self = [super init]) {
        self.uri = uri;
        self.method = JSRequestMethodGET;
        self.responseAsObjects = YES;
        self.asynchronous = YES;
        self.restVersion = JSRESTVersion_1;
    }
    
    return self;
}

- (JSRequest *)usingBlock:(JSRequestConfigurationBlock)block {
    block(self);
    return self;
}

- (id)init {
    return [self initWithUri: @""];
}

@end
