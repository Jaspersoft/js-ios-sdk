//
//  JSRequest.m
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSRequest.h"

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

#if TARGET_OS_IPHONE
@synthesize requestBackgroundPolicy = _requestBackgroundPolicy;
#endif

- (id)initWithUri:(NSString *)uri {
    if (self = [super init]) {
        self.uri = uri;
        self.method = JSRequestMethodGET;
        self.responseAsObjects = YES;
    }
    
    return self;
}

- (JSRequest *)usingBlock:(void (^)(JSRequest *request))block {
    block(self);
    return self;
}

- (id)init {
    return [self initWithUri: @""];
}

@end
