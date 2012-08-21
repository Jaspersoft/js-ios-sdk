//
//  JSRequestBuilder.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 10.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSRequest.h"
#import <Foundation/Foundation.h>

@interface JSRequestBuilder : NSObject

@property (nonatomic, readonly) JSRequest *request;

+ (JSRequestBuilder *)requestWithUri:(NSString *)uri method:(JSRequestMethod)method;
- (JSRequestBuilder *)requestWithUri:(NSString *)uri method:(JSRequestMethod)method;
- (JSRequestBuilder *)body:(id)body;
- (JSRequestBuilder *)params:(NSDictionary *)params;
- (JSRequestBuilder *)timeoutInterval:(NSTimeInterval)timeoutInterval;
- (JSRequestBuilder *)delegate:(id<JSRequestDelegate>)delegate;
- (JSRequestBuilder *)finishedBlock:(JSRequestFinishedBlock)finishedBlock;
- (JSRequestBuilder *)responseAsObjects:(BOOL)responseAsObjects;
- (JSRequestBuilder *)downloadDestinationPath:(NSString *)downloadDestinationPath;

@end
