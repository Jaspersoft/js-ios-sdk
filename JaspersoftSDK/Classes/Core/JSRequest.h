//
//  JSRequest.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSOperationResult.h"

@class JSRequest;

/**
 Supported HTTP request types
 */
typedef enum {
    JSRequestMethodGET,
    JSRequestMethodPOST,
    JSRequestMethodPUT,
    JSRequestMethodDELETE
} JSRequestMethod;

/** 
 Request blocks as analogue to JSResponseDelegate protocol
 */
typedef void(^JSRequestFinishedBlock)(JSOperationResult *result);

/** 
 This protocol must be implemented by objects that
 want to call the REST services asynchronously.
 */
@protocol JSRequestDelegate <NSObject>  

@required

/** 
 This method is invoked when the request is complete. 
 The results of the request can be checked looking at 
 the JSOperationResult passed as parameter.
 */
- (void)requestFinished:(JSOperationResult *)result;

@optional

- (void)didReceiveData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExpectedToReceive:(NSInteger)totalBytesExpectedToReceive;

@end

@interface JSRequest : NSObject

@property (nonatomic, retain) NSString *uri;
@property (nonatomic, retain) id body;
@property (nonatomic, retain) NSDictionary *params;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) JSRequestMethod method;
@property (nonatomic, retain) id<JSRequestDelegate> delegate;
@property (nonatomic, copy) JSRequestFinishedBlock finishedBlock;
@property (nonatomic, assign) BOOL responseAsObjects;
@property (nonatomic, retain) NSString *downloadDestinationPath;

- (JSRequest *)usingBlock:(void (^)(JSRequest *request))block;

@end
