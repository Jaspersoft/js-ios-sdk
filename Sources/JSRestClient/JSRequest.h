/*
 * Copyright © 2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 1.3
 */


#import "JSOperationResult.h"
#import "AFURLRequestSerialization.h"
#import "JSMapping.h"

/**
 This block invoked when the request is complete.
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
 
 @see JSRESTBase#sendRequest:
 */
@interface JSRequest : NSObject

/**
 The URI this request is loading
 */
@property (nonatomic, retain, nonnull) NSString *uri;

/**
 The full URI with restVersion prefix
 
 @since 2.5
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
 
 @since 2.5
 */
@property (nonatomic, assign) JSRequestSerializationType serializationType;

/**
 Expected mapping for serialize responce
 
 @since 2.5
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
 
 @since 2.5
 */
+ (nonnull NSString *)httpMethodStringRepresentation:(JSRequestHTTPMethod)method;
@end
