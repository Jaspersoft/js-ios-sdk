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
//  JSScheduleJob.h
//  TIBCO JasperMobile
//


/**
@author Aleksandr Dakhno odahno@tibco.com
@since 2.3
*/

@class JSScheduleTrigger;

@interface JSScheduleJob : NSObject <JSSerializationDescriptorHolder>
@property (nonatomic, strong) NSString *reportUnitURI;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *baseOutputFilename;
@property (nonatomic, strong) NSArray *outputFormats;
@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, strong) NSString *folderURI;
@property (nonatomic, strong) NSString *outputTimeZone;
@property (nonatomic, strong) JSScheduleTrigger *trigger;

@property (nonatomic, strong) NSString *errorDescription;

- (instancetype)initWithReportURI:(NSString *)reportURI
                            label:(NSString *)label
                   outputFilename:(NSString *)outputFilename
                        folderURI:(NSString *)folderURI
                          formats:(NSArray *)format
                        startDate:(NSDate *)startDate;

+ (instancetype)jobWithReportURI:(NSString *)reportURI
                           label:(NSString *)label
                  outputFilename:(NSString *)outputFilename
                       folderURI:(NSString *)folderURI
                         formats:(NSArray *)format
                       startDate:(NSDate *)startDate;
- (NSData *)jobAsData;
@end