/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @since 2.3
 */

#import "JSRESTBase.h"

@class JSScheduleMetadata;

typedef NS_ENUM(NSInteger, JSScheduleSearchSortType) {
    JSScheduleSearchSortTypeNone,
    JSScheduleSearchSortTypeJobId,
    JSScheduleSearchSortTypeJobName,
    JSScheduleSearchSortTypeReportURI,
    JSScheduleSearchSortTypeReportName,
    JSScheduleSearchSortTypeReportFolder,
    JSScheduleSearchSortTypeOwner,
    JSScheduleSearchSortTypeStatus,
    JSScheduleSearchSortTypeLastRun,
    JSScheduleSearchSortTypeNextRun
};

@interface JSScheduleSearchParameters: NSObject
@property (nonatomic, strong) NSString *reportUnitURI;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *example; // not use yet
@property (nonatomic, strong) NSNumber *startIndex;
@property (nonatomic, strong) NSNumber *numberOfRows;
@property (nonatomic, assign) JSScheduleSearchSortType sortType;
@property (nonatomic, strong) NSNumber *isAscending;
@end

@interface JSRESTBase (JSSchedule)
- (void)fetchSchedulesWithSearchParameters:(JSScheduleSearchParameters *)parameters completion:(JSRequestCompletionBlock)completion;
- (void)fetchSchedulesForResourceWithURI:(NSString *)resourceURI completion:(JSRequestCompletionBlock)completion;
- (void)fetchScheduleMetadataWithId:(NSInteger)scheduleId completion:(JSRequestCompletionBlock)completion;
- (void)createScheduleWithData:(JSScheduleMetadata *)data completion:(JSRequestCompletionBlock)completion;
- (void)updateSchedule:(JSScheduleMetadata *)schedule completion:(JSRequestCompletionBlock)completion;
- (void)deleteScheduleWithId:(NSInteger)identifier completion:(JSRequestCompletionBlock)completion;
@end
