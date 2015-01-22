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
//  JSRequestBuilder.m
//  Jaspersoft Corporation
//

#import "JSRequestBuilder.h"

@implementation JSRequestBuilder

@synthesize request = _request;

+ (JSRequestBuilder *)requestWithUri:(NSString *)uri method:(RKRequestMethod)method {
    return [[[self alloc] init] requestWithUri:uri method:method];
}

- (JSRequestBuilder *)requestWithUri:(NSString *)uri method:(RKRequestMethod)method {
    _request = [[JSRequest alloc] init];
    _request.uri = uri;
    _request.method = method;
    return self;
}

- (JSRequestBuilder *)body:(id)body {
    _request.body = body;
    return self;
}

- (JSRequestBuilder *)params:(NSDictionary *)params {
    _request.params = params;
    return self;
}

- (JSRequestBuilder *)timeoutInterval:(NSTimeInterval)timeoutInterval {
    _request.timeoutInterval = timeoutInterval;
    return self;
}

- (JSRequestBuilder *)delegate:(id<JSRequestDelegate>)delegate {
    _request.delegate = delegate;
    return self;
}

- (JSRequestBuilder *)finishedBlock:(JSRequestFinishedBlock)finishedBlock {
    _request.finishedBlock = finishedBlock;
    return self;
}

- (JSRequestBuilder *)responseAsObjects:(BOOL)responseAsObjects {
    _request.responseAsObjects = responseAsObjects;
    return self;
}

- (JSRequestBuilder *)downloadDestinationPath:(NSString *)downloadDestinationPath {
    _request.downloadDestinationPath = downloadDestinationPath;
    return self;
}

- (JSRequestBuilder *)asynchronous:(BOOL)asynchronous {
    _request.asynchronous = asynchronous;
    return self;
}

- (JSRequestBuilder *)restVersion:(JSRESTVersion)restVersion {
    _request.restVersion = restVersion;
    return self;
}

@end
