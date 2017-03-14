/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.6
 */

#import <Foundation/Foundation.h>
#import "JSDashboard.h"
#import "JSRESTBase.h"
#import "JSFileSaver.h"

typedef void(^JSSaveDashboardCompletion)(NSURL * _Nullable savedDashboardFolderURL, NSError * _Nullable error);


@interface JSDashboardSaver : JSFileSaver

@property (nonatomic, copy, readonly, nonnull) JSRESTBase *restClient;
@property (nonatomic, copy, readonly, nonnull) JSDashboard *dashboard;

- (nonnull instancetype)initWithDashboard:(nonnull JSDashboard *)dashboard restClient:(nonnull JSRESTBase *)restClient;
+ (nonnull instancetype)saverWithDashboard:(nonnull JSDashboard *)dashboard restClient:(nonnull JSRESTBase *)restClient;


- (void)saveDashboardWithName:(nonnull NSString *)name format:(nullable NSString *)format completion:(nonnull JSSaveDashboardCompletion)completionBlock;
- (void)cancel;

@end
