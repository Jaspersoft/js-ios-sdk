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
//  JSDashboardSaver.m
//  Jaspersoft Corporation
//

#import "JSDashboardSaver.h"
#import "JSRESTBase+JSRESTDashboard.h"
#import "JSDashboardExportExecutionResource.h"
#import "JSDashboardExportExecutionStatus.h"


@interface JSDashboardSaver ()
@property (nonatomic, copy, readwrite, nonnull) JSRESTBase *restClient;
@property (nonatomic, copy, readwrite, nonnull) JSDashboard *dashboard;
@property (nonatomic, strong, nonnull) JSDashboardExportExecutionResource *dashboardResource;

@property (nonatomic, copy, nonnull) NSString *name;
@property (nonatomic, copy, nonnull) NSString *format;

@property (nonatomic, copy, nullable) JSSaveDashboardCompletion executeCompletion;
@property (nonatomic, strong, nullable) NSString *tempDashboardDirectory;

@end

@implementation JSDashboardSaver
- (instancetype)initWithDashboard:(JSDashboard *)dashboard restClient:(nonnull JSRESTBase *)restClient {
    self = [super init];
    if (self) {
        self.dashboard = dashboard;
        self.restClient = restClient;
    }
    return self;
}

+ (instancetype)saverWithDashboard:(JSDashboard *)dashboard restClient:(nonnull JSRESTBase *)restClient{
    return [[self alloc] initWithDashboard:dashboard restClient:restClient];
}

- (void)saveDashboardWithName:(nonnull NSString *)name format:(nullable NSString *)format completion:(nonnull JSSaveDashboardCompletion)completionBlock
{
    self.executeCompletion = completionBlock;
    self.name = name;
    self.format = format;

#warning NEED CHECK PARAMETERS APPLYING!!!
    NSMutableArray <JSDashboardParameter *>* parameters = [NSMutableArray array];
    for (JSInputControlDescriptor *inputControlDescriptor in self.dashboard.inputControls) {
        JSDashboardParameter *dashboardParameter = [[JSDashboardParameter alloc] initWithName:inputControlDescriptor.uuid
                                                                                        value:inputControlDescriptor.selectedValues];
        [parameters addObject:dashboardParameter];
    }
    __weak typeof(self) weakSelf = self;
    [self.restClient runDashboardExportExecutionWithURI:self.dashboard.resourceURI toFormat:format parameters:parameters completion:^(JSOperationResult * _Nullable result) {
        if (result.error) {
            if (completionBlock) {
                completionBlock(nil, result.error);
            }
        } else {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.dashboardResource = result.objects.firstObject;
            [strongSelf checkingExecutionStatus];
        }
    }];
}

#pragma mark - Execution Status Checking
- (void) checkingExecutionStatus {
    [self performSelector:@selector(executionStatusChecking) withObject:nil afterDelay:kJSExecutionStatusCheckingInterval];
}

- (void)executionStatusChecking {
    __weak typeof(self) weakSelf = self;
    [self.restClient dashboardExportExecutionStatusWithJobID:self.dashboardResource.identifier
                                                  completion:^(JSOperationResult * _Nullable result) {
                                                      __strong typeof(self) strongSelf = weakSelf;
                                                      if (result.error) {
                                                          if (strongSelf.executeCompletion) {
                                                              strongSelf.executeCompletion(nil, result.error);
                                                          }
                                                      } else {
                                                          JSDashboardExportExecutionStatus *executionStatus = result.objects.firstObject;
                                                          if (executionStatus.status.status == kJS_EXECUTION_STATUS_READY) {
                                                              [strongSelf loadOutputResource];
                                                          } else if (executionStatus.status.status == kJS_EXECUTION_STATUS_QUEUED ||
                                                                     executionStatus.status.status == kJS_EXECUTION_STATUS_EXECUTION) {
                                                              [strongSelf checkingExecutionStatus];
                                                          } else if (strongSelf.executeCompletion) {
                                                              strongSelf.executeCompletion(nil, result.error);
                                                          }
                                                      }
                                                  }];
}

- (void) loadOutputResource {
    // save dashboard to disk
    NSString *outputResourceURLString = [self.restClient generateDashboardOutputUrl:self.dashboardResource.identifier];
    
    NSString *tempAppDirectory = NSTemporaryDirectory();
    self.tempDashboardDirectory = [tempAppDirectory stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]];
    NSString *tempDashboardPath = [[self.tempDashboardDirectory stringByAppendingPathComponent:self.name] stringByAppendingPathExtension:self.format];
    
    __weak typeof(self)weakSelf = self;
    [JSDashboardSaver downloadResourceWithRestClient:self.restClient fromURLString:outputResourceURLString destinationPath:tempDashboardPath completion:^(NSError *error) {
        __strong typeof(self)strongSelf = weakSelf;
        if (strongSelf.executeCompletion) {
            NSURL *dashboardURL = [NSURL fileURLWithPath:strongSelf.tempDashboardDirectory isDirectory:YES];
            strongSelf.executeCompletion(dashboardURL, error);
        }
    }];
}

- (void)cancel {
    self.executeCompletion = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self.restClient cancelAllRequests];

    [self.restClient cancelDashboardExportExecutionWithJobID:self.dashboardResource.identifier completion:nil];
    
    [self removeTempDirectory];
}

- (void) removeTempDirectory {
    [[NSFileManager defaultManager] removeItemAtPath:self.tempDashboardDirectory error:nil];
}

@end
