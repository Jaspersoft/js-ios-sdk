/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2001 - 2011 Jaspersoft Corporation. All rights reserved.
 * http://community.jaspersoft.com/project/mobile-sdk-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is part of Jaspersoft Mobile SDK.
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
 * along with Jaspersoft Mobile SDK. If not, see <http://www.gnu.org/licenses/>.
 */

//
//  JSReportExecution.h
//  Jaspersoft Corporation
//

#import <Foundation/Foundation.h>

/**
 * Result of a call.
 * The JSReportExecution object holds data for report descriptor
 *
 * @since version 1.0
 */
@interface JSReportExecution : NSObject {
    NSMutableArray *fileNames;
    NSMutableArray *fileTypes;
}

/** The unique identified of this report execution
 */
@property(retain, nonatomic) NSString *uuid;

/** The uri of the report execution, used to retrieve the files
 */
@property(retain, nonatomic) NSString *uri;

/** The number of pages generated
 */
@property NSInteger totalPages;

/** The name of the files produced
 */
@property(retain, nonatomic) NSMutableArray *fileNames;

/** The content type of the produced files
 */
@property(retain, nonatomic) NSMutableArray *fileTypes;


@end
