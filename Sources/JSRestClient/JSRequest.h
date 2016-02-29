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
#import "AFURLRequestSerialization.h"
#import "JSMapping.h"
/**
 This block invoked when the request is complete.
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Alexey Gubarev ogubarie@tibco.com
*/
typedef void(^JSRequestCompletionBlock)(JSOperationResult *_Nullable result);

/**
 Supported REST versions
 
 Tells what REST service URI prefix should be used to send request (i.e. for
 JSRESTVersion_1 URI could look like http://host:port/jasperserver-pro/rest/serverInfo/version
 while for JSRESTVersion_2: http://host:port/jasperserver-pro/rest_v2/serverInfo/version )
 */
typedef enum {
    JSRESTVersion_None,
    JSRESTVersion_1,            // Unsupported. Use JSRESTVersion_2 version instead
    JSRESTVersion_2
} JSRESTVersion;

/**
 Supported HTTP methods for requests
 */
typedef NS_OPTIONS(NSInteger, JSRequestHTTPMethod) {
    JSRequestHTTPMethodGET          = 1 << 0,
    JSRequestHTTPMethodPOST         = 1 << 1,
    JSRequestHTTPMethodPUT          = 1 << 2,
    JSRequestHTTPMethodDELETE       = 1 << 3,
    JSRequestHTTPMethodPATCH        = 1 << 4,
    JSRequestHTTPMethodHEAD         = 1 << 5
};

/**
 Supported HTTP methods for requests
 */
typedef NS_OPTIONS(NSInteger, JSRequestSerializationType) {
    JSRequestSerializationType_JSON         = 1 << 0,
    JSRequestSerializationType_UrlEncoded   = 1 << 1
};

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
@property (nonatomic, retain, nonnull) NSString *uri;

/**
 The full URI with restVersion prefix
 
 @since 2.4
 */
@property (nonatomic, readonly, nonnull) NSString *fullURI;

/**
 The HTTP body used for this request. Uses only for POST and PUT HTTP methods.
 Automatically will be serialized as string in the format (i.e XML, JSON, etc.) provided
 by the serializer
*/
@property (nonatomic, retain, nullable) id body;

/**
 A collection of parameters of the request. Automatically will be added to URL
 */
@property (nonatomic, strong, readonly, null_unspecified) NSDictionary *params;

/**
 A collection of additional header parameters of the request
 */
@property (nonatomic, strong, null_unspecified) NSDictionary *additionalHeaders;

/**
 The HTTP method
 */
@property (nonatomic, assign) JSRequestHTTPMethod method;

/**
 The serialization type
 
 @since 2.4
 */
@property (nonatomic, assign) JSRequestSerializationType serializationType;

/**
 Expected mapping for serialize responce
 
 @since 2.4
 */
@property (nonatomic, strong, nonnull) JSMapping *objectMapping;

/**
 A completionBlock invoke when the request is completed. If block is not
 <code>nil</code>, it will receive request result (instance of
 <code>JSOperationResult</code> class).
 */
@property (nonatomic, copy, nullable) JSRequestCompletionBlock completionBlock;

/**
 The responseAsObjects indicates if response result should be serialized and
 returned as a list of objects instead plain text
 */
@property (nonatomic, assign) BOOL responseAsObjects;

/**
 The save path of downloaded file. This is an additional parameter which helps
 to determine which file will be downloaded (because all requests are asynchronous)
 */
@property (nonatomic, retain, nullable) NSString *downloadDestinationPath;

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
 The shouldResendRequestAfterSessionExpiration indicates if request can be resend after session was exired and recreated
 
 **Default**: YES
 
 @since 2.3
 */
@property (nonatomic, assign) BOOL shouldResendRequestAfterSessionExpiration;

/**
 Returns a request instance with predefined uri.
 
 @param uri A request uri
 @return A fully configured JSRequest instance
 */
- (nonnull instancetype)initWithUri:(nonnull NSString *)uri;

/**
 Adds a parameter with a specified string value only if value is not nil or empty
 
 @param parameter Parameter name
 @param value Parameter value
 */
- (void)addParameter:(nonnull NSString *)parameter withStringValue:(nonnull NSString *)value;

/**
 Adds a parameter with a specified integer value only if value is bigger then 0
 
 @param parameter Parameter name
 @param value Parameter value
 */
- (void)addParameter:(nonnull NSString *)parameter withIntegerValue:(NSInteger)value;

/**
 Adds a parameter with a specified array value only if value is not nil or empty
 
 @param parameter Parameter name
 @param value Parameter value
 */
- (void)addParameter:(nonnull NSString *)parameter withArrayValue:(nonnull NSArray *)value;

/**
 The string representation of HTTP method
 
 @since 2.4
 */
+ (nonnull NSString *)httpMethodStringRepresentation:(JSRequestHTTPMethod)method;
@end
