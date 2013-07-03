//
//  JSOperationResult.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 12.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSRequest;

/**
 Uses to hold the different results of a REST call to JasperReports server. Result 
 can be a list of object (single object represents as list with one object) or 
 binary data (downloaded file)
 
 @author Giulio Toffoli giulio@jaspersoft.com 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.0
 */
@interface JSOperationResult : NSObject

/**
 A list of objects coming from the call (i.e. if the call is of type GET /resource 
 or GET /resources, this list contains the JSResourceDescriptor objects returned
 from the call)
 */
@property (nonatomic, retain) NSArray *objects;

/**
 The downloaded response as binary data
 */
@property (nonatomic, retain) NSData *body;

/**
 The downloaded response as string
 */
@property (nonatomic, retain) NSString *bodyAsString;

/**
 The sent request associated with this result. This is an additional parameter 
 which helps to determine which request was sent (because all they are asynchronous).
 */
@property (nonatomic, retain) JSRequest *request;

/**
 The save path of downloaded file. This is an additional parameter which helps
 to determine which file was downloaded (because all requests are asynchronous).
 Gets from request instance (this is the short way)
 */
@property (nonatomic, readonly) NSString *downloadDestinationPath;

/**
 The error returned from the request call, if any.
 */
@property (nonatomic, readonly) NSError *error;

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
- (id)initWithStatusCode:(NSInteger)statusCode allHeaderFields:(NSDictionary *)allHeaderFields MIMEType:(NSString *)MIMEType error:(NSError *)error;

@end
