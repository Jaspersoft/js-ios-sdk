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
//  JSRequest.h
//  Jaspersoft Corporation
//

#import "JSOperationResult.h"
#import "RKHTTPUtilities.h"
#import "JSSerializationDescriptorHolder.h"

/**
 This block invoked when the request is complete.
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Alexey Gubarev ogubarie@tibco.com
*/
typedef void(^JSRequestCompletionBlock)(JSOperationResult *result);

/**
 Supported REST versions
 
 Tells what REST service URI prefix should be used to send request (i.e. for
 JSRESTVersion_1 URI could look like http://host:port/jasperserver-pro/rest/serverInfo/version
 while for JSRESTVersion_2: http://host:port/jasperserver-pro/rest_v2/serverInfo/version )
 */
typedef enum {
    JSRESTVersion_None,
    JSRESTVersion_1,
    JSRESTVersion_2
} JSRESTVersion;

/**
 Models the request portion of an HTTP request/response cycle. Used by
 <code>JSRESTBase</code> class to send requests
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.3
 @see JSRESTBase#sendRequest:
 */
@interface JSRequest : NSObject

/**
 The URI this request is loading
 */
@property (nonatomic, retain) NSString *uri;

/**
 The HTTP body used for this request. Uses only for POST and PUT HTTP methods.
 Automatically will be serialized as string in the format (i.e XML, JSON, etc.) provided
 by the serializer
*/
@property (nonatomic, retain) id body;

/**
 Expected model class for mapping responce
 */
@property (nonatomic, strong) Class <JSSerializationDescriptorHolder> expectedModelClass;

/**
 A collection of parameters of the request. Automatically will be added to URL
 */
@property (nonatomic, strong, readonly) NSDictionary *params;

/**
 The HTTP method
 */
@property (nonatomic, assign) RKRequestMethod method;

/**
 A completionBlock invoke when the request is completed. If block is not
 <code>nil</code>, it will receive request result (instance of
 <code>JSOperationResult</code> class).
 */
@property (nonatomic, copy) JSRequestCompletionBlock completionBlock;

/**
 The responseAsObjects indicates if response result should be serialized and
 returned as a list of objects instead plain text
 */
@property (nonatomic, assign) BOOL responseAsObjects;

/**
 The save path of downloaded file. This is an additional parameter which helps
 to determine which file will be downloaded (because all requests are asynchronous)
 */
@property (nonatomic, retain) NSString *downloadDestinationPath;

/**
 Determine asynchronous nature of request
 
 **Default**: YES
 */
@property (nonatomic, assign) BOOL asynchronous;

/**
 The rest version of JasperReports server (affects for URI part)
 
 **Default**: JSRESTVersion_1
 */
@property (nonatomic, assign) JSRESTVersion restVersion;

/**
 The redirectAllowed indicates if request can be redirected 

 **Default**: YES

 @since 1.9
 */
@property (nonatomic, assign) BOOL redirectAllowed;

/**
 Allow construct mulpipart body

 @since 2.1.2
 */
@property (nonatomic, copy) void(^multipartFormConstructingBodyBlock)(id <AFMultipartFormData> formData);

/**
 Returns a request instance with predefined uri.
 
 @param uri A request uri
 @return A fully configured JSRequest instance
 */
- (id)initWithUri:(NSString *)uri;

/**
 Adds a parameter with a specified string value only if value is not nil or empty
 
 @param parameter Parameter name
 @param value Parameter value
 */
- (void)addParameter:(NSString *)parameter withStringValue:(NSString *)value;

/**
 Adds a parameter with a specified integer value only if value is bigger then 0
 
 @param parameter Parameter name
 @param value Parameter value
 */
- (void)addParameter:(NSString *)parameter withIntegerValue:(NSInteger)value;

/**
 Adds a parameter with a specified array value only if value is not nil or empty
 
 @param parameter Parameter name
 @param value Parameter value
 */
- (void)addParameter:(NSString *)parameter withArrayValue:(NSArray *)value;

@end
