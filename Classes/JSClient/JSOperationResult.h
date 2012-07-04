/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2001 - 2011 Jaspersoft Corporation. All rights reserved.
 * http://www.jasperforge.org/projects/mobile
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
//  OperationResult.h
//  Jaspersoft
//
//  Created by Giulio Toffoli on 4/9/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSResourceDescriptor.h"
#import "JSReportExecution.h"

/** 
 * Result of a call.
 * The JSOperationResult object holds the result of a REST call to JasperReports Server.
 * 
 */
@interface JSOperationResult : NSObject {
	
	

}

/** The HTTP code returned by this call.
 *  This is a standard HTTP protocol code. Codes like 2xx are all ok. 4xx are client errors, 5xx are server errors (even if sometimes these errors may happen due to a wrong request).
 */
@property(nonatomic, readwrite) int returnCode;

/** Optional error message returned from the call
 *  This is usually the message tied to the error code (in other words a standard HTTP error message). Sometimes the server is more specific, and puts a more detailed message in the body.
 *  In this case the message displays the mode detailed message.
 */
@property(nonatomic, retain) NSString *message;

/** List of Resources coming from the call.
 * If the call is of type GET /resource or GET /resources, this list contains the resources returned from the call.
 *
 */
@property(nonatomic, retain) NSMutableArray *resourceDescriptors;


/** The desriptor of a report execution
 *
 */
@property(nonatomic, retain) JSReportExecution *reportExecution;


/** The error coming from the ASIHttp request (if any)
 */
@property(nonatomic, retain) NSError *error;

+ (id)operationResultWithReturnCode:(int)code message:(NSString *)msg;

@end
