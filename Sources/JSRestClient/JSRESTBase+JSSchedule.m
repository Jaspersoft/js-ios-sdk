/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2016 Jaspersoft Corporation. All rights reserved.
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
//  JSRESTBase+JSSchedule.m
//  Jaspersoft Corporation
//


#import "JSRESTBase+JSSchedule.h"
#import "JSScheduleJobResource.h"
#import "JSScheduleJob.h"


@implementation JSRESTBase (JSSchedule)

#pragma mark - Public API
- (void)fetchScheduledJobResourcesWithCompletion:(JSRequestCompletionBlock)completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@", @"/jobs"];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.expectedModelClass = [JSScheduleJobResource class];
    request.restVersion = JSRESTVersion_2;
    request.method = RKRequestMethodGET;
    request.completionBlock = completion;
    [self sendRequest:request];
}

- (void)createScheduledJobWithJob:(JSScheduleJob *)job completion:(JSRequestCompletionBlock)completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@", @"/jobs"];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.expectedModelClass = [JSScheduleJob class];
    request.body = job;
    request.restVersion = JSRESTVersion_2;
    request.method = RKRequestMethodPUT;
    request.completionBlock = completion;
    [self sendRequest:request];
}

- (void)deleteScheduledJobWithIdentifier:(NSInteger)identifier completion:(JSRequestCompletionBlock)completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@/%@", @"/jobs", @(identifier)];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.restVersion = JSRESTVersion_2;
    request.method = RKRequestMethodDELETE;
    request.completionBlock = completion;
    [self sendRequest:request];
}

@end