//
//  JSRESTReport.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 06.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSRESTBase.h"
#import "JSResourceDescriptor.h"
#import "JSReportDescriptor.h"
#import <Foundation/Foundation.h>

@interface JSRESTReport : JSRESTBase

/**
 Returns the shared instance of the rest report
 */
+ (JSRESTReport *)sharedInstance;

- (void)runReport:(NSString *)uri reportParams:(NSDictionary *)reportParams format:(NSString *)format delegate:(id<JSRequestDelegate>)delegate;
- (void)runReport:(NSString *)uri reportParams:(NSDictionary *)reportParams format:(NSString *)format usingBlock:(void (^)(JSRequest *request))block;
- (void)runReport:(JSResourceDescriptor *)resourceDescriptor format:(NSString *)format delegate:(id<JSRequestDelegate>)delegate;
- (void)runReport:(JSResourceDescriptor *)resourceDescriptor format:(NSString *)format usingBlock:(void (^)(JSRequest *request))block;
- (void)reportFile:(NSString *)uuid fileName:(NSString *)fileName path:(NSString *)path delegate:(id<JSRequestDelegate>)delegate;
- (void)reportFile:(NSString *)uuid fileName:(NSString *)fileName path:(NSString *)path usingBlock:(void (^)(JSRequest *request))block;

@end
