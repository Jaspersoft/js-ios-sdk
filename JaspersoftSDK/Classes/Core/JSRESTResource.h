//
//  JSRESTResources.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 13.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSRESTBase.h"
#import "JSResourceDescriptor.h"
#import <Foundation/Foundation.h>

/** 
 A class to interact with the JasperReports 
 resource/resources Server REST API. The object puts at disposal 
 a set of method search and navigate the repository, create / modify and 
 get information of resource.
 */
@interface JSRESTResource : JSRESTBase

/**
 Returns the shared instance of the rest resource
 */
+ (JSRESTResource *)sharedInstance;

/** 
 Asynchronous methods for load resource (ResourceDescriptor with ResourceProperties) 
 by specified URI path and specified query parameters. 
 Result will be passed to delegate object or successBlock/failBlock. 
 */
- (void)resource:(NSString *)uri delegate:(id<JSRequestDelegate>)delegate;
- (void)resource:(NSString *)uri usingBlock:(void (^)(JSRequest *request))block;

// Params is list of ResourceParameters
- (void)resourceWithQueryData:(NSString *)uri datasourceUri:(NSString *)datasourceUri resourceParameters:(NSArray *)resourceParameters delegate:(id<JSRequestDelegate>)delegate;
- (void)resourceWithQueryData:(NSString *)uri datasourceUri:(NSString *)datasourceUri resourceParameters:(NSArray *)resourceParameters usingBlock:(void (^)(JSRequest *request))block;

/** Asynchronous methods for load resources (ResourceDescriptors with ResourceProperties) 
 by specified URI path and specified query parameters. 
 Result will be passed to delegate object or successBlock/failBlock.
 */
- (void)resources:(NSString *)uri delegate:(id<JSRequestDelegate>)delegate;
- (void)resources:(NSString *)uri usingBlock:(void (^)(JSRequest *request))block;

- (void)resources:(NSString *)uri query:(NSString *)query type:(NSString *)type 
       recursive:(BOOL)recursive limit:(NSInteger)limit delegate:(id<JSRequestDelegate>)delegate;
- (void)resources:(NSString *)uri query:(NSString *)query type:(NSString *)type 
       recursive:(BOOL)recursive limit:(NSInteger)limit usingBlock:(void (^)(JSRequest *request))block;

/**
 Asynchronous methods for creating modifing and deleting resource
 by specified resource descriptor object. 
 Object will be created by path setted in uriString property for resource descriptor
 Result will be passed to delegate object or successBlock/failBlock.
 */
- (void)createResource:(JSResourceDescriptor *)resource delegate:(id<JSRequestDelegate>)delegate;
- (void)createResource:(JSResourceDescriptor *)resource usingBlock:(void (^)(JSRequest *request))block;

- (void)modifyResource:(JSResourceDescriptor *)resource delegate:(id<JSRequestDelegate>)delegate;
- (void)modifyResource:(JSResourceDescriptor *)resource usingBlock:(void (^)(JSRequest *request))block;

- (void)deleteResource:(NSString *)uri delegate:(id<JSRequestDelegate>)delegate;
- (void)deleteResource:(NSString *)uri usingBlock:(void (^)(JSRequest *request))block;

@end
