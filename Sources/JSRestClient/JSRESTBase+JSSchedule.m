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
#import "JSScheduleLookup.h"
#import "JSScheduleMetadata.h"


@implementation JSRESTBase (JSSchedule)

#pragma mark - Public API
- (void)fetchSchedulesForResourceWithURI:(NSString *)resourceURI completion:(JSRequestCompletionBlock)completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@", @"/jobs"];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.expectedModelClass = [JSScheduleLookup class];
    request.restVersion = JSRESTVersion_2;
    request.method = RKRequestMethodGET;

    if (resourceURI) {
        [request addParameter:@"reportUnitURI" withStringValue:resourceURI];
    }

    request.completionBlock = completion;
    [self sendRequest:request];
}

- (void)fetchScheduleMetadataWithId:(NSInteger)scheduleId completion:(JSRequestCompletionBlock)completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@/%@", @"/jobs", @(scheduleId)];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.expectedModelClass = [JSScheduleMetadata class];
    request.restVersion = JSRESTVersion_2;
    request.method = RKRequestMethodGET;

    request.completionBlock = completion;
    [self sendRequest:request];
}

- (void)createScheduleWithData:(JSScheduleMetadata *)data completion:(JSRequestCompletionBlock)completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@", @"/jobs"];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.expectedModelClass = [JSScheduleMetadata class];
    request.body = data;
    request.restVersion = JSRESTVersion_2;
    request.method = RKRequestMethodPUT;
    request.completionBlock = completion;
    [self sendRequest:request];
}



- (void)updateSchedule:(JSScheduleMetadata *)schedule completion:(JSRequestCompletionBlock)completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@/%@", @"/jobs", @(schedule.jobIdentifier)];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.expectedModelClass = [JSScheduleMetadata class];
    request.body = schedule;
    request.restVersion = JSRESTVersion_2;
    request.method = RKRequestMethodPOST;
    request.completionBlock = completion;
    [self sendRequest:request];
}

- (void)deleteScheduleWithId:(NSInteger)identifier completion:(JSRequestCompletionBlock)completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@/%@", @"/jobs", @(identifier)];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.restVersion = JSRESTVersion_2;
    request.method = RKRequestMethodDELETE;
    request.completionBlock = completion;
    request.responseAsObjects = NO;
    [self sendRequest:request];
}

@end