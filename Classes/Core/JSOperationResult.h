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
//  JSOperationResult.h
//  Jaspersoft Corporation
//

#import <Foundation/Foundation.h>
#import "JSErrors.h"


@class JSRequest;

/**
 Uses to hold the different results of a REST call to JasperReports server. Result
 can be a list of object (single object represents as list with one object) or
 binary data (downloaded file)
 
 @author Giulio Toffoli giulio@jaspersoft.com
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Alexey Gubarev ogubarie@tibco.com
 @since 1.0
 */
@interface JSOperationResult : NSObject

/**
 A list of objects coming from the call
 */
@property (nonatomic, strong) NSArray *objects;

/**
 The downloaded response as binary data
 */
@property (nonatomic, strong) NSData *body;

/**
 The downloaded response as string
 */
@property (nonatomic, strong) NSString *bodyAsString;

/**
 The sent request associated with this result. This is an additional parameter
 which helps to determine which request was sent (because all they are asynchronous).
 */
@property (nonatomic, strong) JSRequest *request;

/**
 The error returned from the request call, if any.
 */
@property (nonatomic, strong) NSError *error;

/**
 The response HTTP code. This is a standard HTTP protocol code. Codes like 2xx are all ok.
 4xx are client errors, 5xx are server errors (even if sometimes these errors may
 happen due to a wrong request)
 */
@property (nonatomic, readonly) NSInteger statusCode;

/**
 A dictionary of the response's headers.
 */
@property (nonatomic, readonly) NSDictionary *allHeaderFields;

/**
 The MIME Type of the response body
 */
@property (nonatomic, readonly) NSString *MIMEType;

/**
 Returns a result with the specified request parameters
 
 @param statusCode The response HTTP code
 @param allHeaderFields A dictionary of the response's headers
 @param MIMEType The MIME Type of the response body
 @param error The error returned from the request call, if any.
 @return A configured JSOperationResult instance
 */
- (id)initWithStatusCode:(NSInteger)statusCode allHeaderFields:(NSDictionary *)allHeaderFields MIMEType:(NSString *)MIMEType;

/**
 Indicates an HTTP response code between 200 and 299
 
 @return YES if the HTTP response code is between 200 and 299
 */
- (BOOL)isSuccessful;

/**
 Indicates an HTTP response code between 400 and 599
 
 @return YES if the HTTP response code is between 400 and 599
 */
- (BOOL)isError;

/**
 Indicates an invalid HTTP response code less than 100 or greater than 600
 
 @return YES if the HTTP response code is less than 100 or greater than 600
 */
- (BOOL)isInvalid;

/**
 Indicates an HTTP response code between 100 and 199
 
 @return YES if the HTTP response code is between 100 and 199
 */
- (BOOL)isInformational;

/**
 Indicates an HTTP response code between 300 and 399
 
 @return YES if the HTTP response code is between 300 and 399
 */
- (BOOL)isRedirection;

@end
