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

@implementation JSScheduleSearchParameters
@end

@implementation JSRESTBase (JSSchedule)

#pragma mark - Public API
- (void)fetchSchedulesWithSearchParameters:(JSScheduleSearchParameters *)parameters completion:(JSRequestCompletionBlock)completion
{
    if (!parameters) {
        NSString *reason = @"Parameters is absent";
        NSException* wrongActionxception = [NSException exceptionWithName:@"FetchScheduleException"
                                                                   reason:reason
                                                                 userInfo:nil];
        @throw wrongActionxception;
    }

    NSString *fullURL = [NSString stringWithFormat:@"%@", @"/jobs"];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.restVersion = JSRESTVersion_2;
    request.method = JSRequestHTTPMethodGET;
    request.completionBlock = completion;
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSScheduleLookup objectMappingForServerProfile:self.serverProfile]
                                                        keyPath:@"jobsummary"];

    if (parameters.reportUnitURI) {
        [request addParameter:@"reportUnitURI" withStringValue:parameters.reportUnitURI];
    }
    if (parameters.owner) {
        [request addParameter:@"owner" withStringValue:parameters.owner];
    }
    if (parameters.label) {
        [request addParameter:@"label" withStringValue:parameters.label];
    }
    if (parameters.startIndex) {
        [request addParameter:@"startIndex" withIntegerValue:parameters.startIndex.integerValue];
    }
    if (parameters.numberOfRows) {
        [request addParameter:@"numberOfRows" withIntegerValue:parameters.numberOfRows.integerValue];
    }
    if (parameters.isAscending) {
        BOOL isAscending = parameters.isAscending.boolValue;
        [request addParameter:@"isAscending" withStringValue:isAscending ? @"true": @"false"];
    }
    [request addParameter:@"sortType" withStringValue:[self sortTypeStringValueForSortType:parameters.sortType]];

    [self sendRequest:request];
}

- (void)fetchSchedulesForResourceWithURI:(NSString *)resourceURI completion:(JSRequestCompletionBlock)completion
{
    JSScheduleSearchParameters *parameters = [JSScheduleSearchParameters new];
    parameters.reportUnitURI = resourceURI;
    parameters.sortType = JSScheduleSearchSortTypeNone;
    [self fetchSchedulesWithSearchParameters:parameters
                                  completion:completion];
}

- (void)fetchScheduleMetadataWithId:(NSInteger)scheduleId completion:(JSRequestCompletionBlock)completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@/%@", @"/jobs", @(scheduleId)];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSScheduleMetadata objectMappingForServerProfile:self.serverProfile]
                                                        keyPath:nil];
    request.restVersion = JSRESTVersion_2;
    request.method = JSRequestHTTPMethodGET;

    request.completionBlock = completion;
    request.additionalHeaders = @{
            kJSRequestContentType  : @"application/job+json",
            kJSRequestResponceType : @"application/job+json"
    };
    [self sendRequest:request];
}

- (void)createScheduleWithData:(JSScheduleMetadata *)data completion:(JSRequestCompletionBlock)completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@", @"/jobs"];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSScheduleMetadata objectMappingForServerProfile:self.serverProfile]
                                                        keyPath:nil];
    request.body = data;
    request.restVersion = JSRESTVersion_2;
    request.method = JSRequestHTTPMethodPUT;
    request.completionBlock = completion;
    request.additionalHeaders = @{
            kJSRequestContentType  : @"application/job+json",
            kJSRequestResponceType : @"application/job+json"
    };
    [self sendRequest:request];
}



- (void)updateSchedule:(JSScheduleMetadata *)schedule completion:(JSRequestCompletionBlock)completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@/%@", @"/jobs", @(schedule.jobIdentifier)];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSScheduleMetadata objectMappingForServerProfile:self.serverProfile]
                                                        keyPath:nil];
    request.body = schedule;
    request.restVersion = JSRESTVersion_2;
    request.method = JSRequestHTTPMethodPOST;
    request.completionBlock = completion;
    request.additionalHeaders = @{
            kJSRequestContentType  : @"application/job+json",
            kJSRequestResponceType : @"application/job+json"
    };
    [self sendRequest:request];
}

- (void)deleteScheduleWithId:(NSInteger)identifier completion:(JSRequestCompletionBlock)completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@/%@", @"/jobs", @(identifier)];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.restVersion = JSRESTVersion_2;
    request.method = JSRequestHTTPMethodDELETE;
    request.completionBlock = completion;
    request.responseAsObjects = NO;
    request.additionalHeaders = @{
            kJSRequestContentType  : @"application/job+json",
            kJSRequestResponceType : @"application/job+json"
    };
    [self sendRequest:request];
}

#pragma mark - Helpers
- (NSString *)sortTypeStringValueForSortType:(JSScheduleSearchSortType)sortType
{
    NSString *stringValue;
    switch (sortType) {
        case JSScheduleSearchSortTypeNone: {
            stringValue = @"NONE";
            break;
        }
        case JSScheduleSearchSortTypeJobId: {
            stringValue = @"SORTBY_JOBID";
            break;
        }
        case JSScheduleSearchSortTypeJobName: {
            stringValue = @"SORTBY_JOBNAME";
            break;
        }
        case JSScheduleSearchSortTypeReportURI: {
            stringValue = @"SORTBY_REPORTURI";
            break;
        }
        case JSScheduleSearchSortTypeReportName: {
            stringValue = @"SORTBY_REPORTNAME";
            break;
        }
        case JSScheduleSearchSortTypeReportFolder: {
            stringValue = @"SORTBY_REPORTFOLDER";
            break;
        }
        case JSScheduleSearchSortTypeOwner: {
            stringValue = @"SORTBY_OWNER";
            break;
        }
        case JSScheduleSearchSortTypeStatus: {
            stringValue = @"SORTBY_STATUS";
            break;
        }
        case JSScheduleSearchSortTypeLastRun: {
            stringValue = @"SORTBY_LASTRUN";
            break;
        }
        case JSScheduleSearchSortTypeNextRun: {
            stringValue = @"SORTBY_NEXTRUN";
            break;
        }
    }
    return stringValue;
}

@end