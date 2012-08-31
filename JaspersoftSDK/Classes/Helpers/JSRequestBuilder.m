//
//  JSRequestBuilder.m
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 10.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSRequestBuilder.h"

@implementation JSRequestBuilder

@synthesize request = _request;

+ (JSRequestBuilder *)requestWithUri:(NSString *)uri method:(JSRequestMethod)method {
    return [[[self alloc] init] requestWithUri:uri method:method];
}

- (JSRequestBuilder *)requestWithUri:(NSString *)uri method:(JSRequestMethod)method {
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

@end
