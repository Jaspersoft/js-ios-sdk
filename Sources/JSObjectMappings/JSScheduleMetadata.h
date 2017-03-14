/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Olexandr Dahno odahno@tibco.com
 @since 2.3
 */

#import "JSObjectMappingsProtocol.h"
@class JSScheduleTrigger;

@interface JSScheduleMetadata : NSObject <JSObjectMappingsProtocol>
@property (nonatomic, assign) NSInteger jobIdentifier;
@property (nonatomic, assign) NSInteger version;

@property (nonatomic, strong) NSString *scheduleDescription;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *outputTimeZone;
@property (nonatomic, strong) NSString *baseOutputFilename;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *reportUnitURI;
@property (nonatomic, strong) NSString *outputLocale;
@property (nonatomic, strong) NSString *folderURI;

@property (nonatomic, strong) NSDictionary *alert;
@property (nonatomic, strong) NSDictionary *mailNotification;

@property (nonatomic, strong) NSDictionary *source;
@property (nonatomic, strong) NSDictionary *repositoryDestination;

@property (nonatomic, strong) NSArray *outputFormats;
@property (nonatomic, strong) NSDate *creationDate;

@property (nonatomic, strong) JSScheduleTrigger *trigger;

@end
