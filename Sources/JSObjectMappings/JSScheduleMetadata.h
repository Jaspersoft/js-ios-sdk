/*
 * TIBCO JasperMobile for iOS
 * Copyright © 2005-2016 TIBCO Software, Inc. All rights reserved.
 * http://community.jaspersoft.com/project/jaspermobile-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/lgpl>.
 */


//
//  JSScheduleMetadata.h
//  TIBCO JasperMobile
//


/**
@author Aleksandr Dakhno odahno@tibco.com
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