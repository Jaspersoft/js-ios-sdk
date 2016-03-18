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
//  JSRESTBase.m
//  Jaspersoft Corporation
//

#import "JSRESTBase.h"
#import "JSObjectMappingsProtocol.h"
#import "JSErrorDescriptor.h"
#import "JSRESTBase+JSRESTSession.h"
#import "JSErrorBuilder.h"
#import "AFNetworkActivityIndicatorManager.h"

#import "EKSerializer.h"
#import "EKMapper.h"

// Access key and value for content-type / charset
NSString * const kJSRequestContentType = @"Content-Type";
NSString * const kJSRequestResponceType = @"Accept";

NSString * const kJSSavedSessionServerProfileKey    = @"JSSavedSessionServerProfileKey";
NSString * const kJSSavedSessionTimeoutKey          = @"JSSavedSessionTimeoutKey";
NSString * const kJSSavedSessionKeepSessionKey      = @"JSSavedSessionKeepSessionKey";

// Default value for timeout interval
static NSTimeInterval const _defaultTimeoutInterval = 120;

// Helper template message indicates that request was finished successfully
NSString * const _requestFinishedTemplateMessage = @"Request finished: %@\nResponse: %@";


// Inner JSCallback class contains JSRequest and NSURLSessionTask instances.
// JSRequest class uses for setting additional parameters to JSOperationResult
// instance (i.e. downloadDestinationPath for files) which we want to associate
// with returned response (but it cannot be done in any other way).
@interface JSCallBack : NSObject

@property (nonatomic, retain) JSRequest *request;
@property (nonatomic, retain) NSURLSessionTask *dataTask;

- (id)initWithDataTask:(NSURLSessionTask *)restKitOpdataTaskeration request:(JSRequest *)request;

@end

@implementation JSCallBack
- (id)initWithDataTask:(NSURLSessionTask *)dataTask request:(JSRequest *)request {
    if (self = [super init]) {
        self.request = request;
        self.dataTask = dataTask;
    }
    return self;
}

@end


@interface JSRESTBase()

@property (nonatomic, strong, readwrite, nonnull) JSProfile *serverProfile;

// List of JSCallBack instances
@property (nonatomic, strong) NSMutableArray <JSCallBack *> *requestCallBacks;

@property (nonatomic, assign, readwrite) BOOL keepSession;

@property (nonatomic, strong) ServerReachability *serverReachability;

@end

@implementation JSRESTBase
@synthesize serverProfile = _serverProfile;
@synthesize requestCallBacks = _requestCallBacks;
@synthesize timeoutInterval = _timeoutInterval;

#pragma mark -
#pragma mark Initialization

+ (void)initialize {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

- (nonnull instancetype) initWithServerProfile:(nonnull JSProfile *)serverProfile keepLogged:(BOOL)keepLogged{
    self = [super initWithBaseURL:[NSURL URLWithString:serverProfile.serverUrl]];
    if (self) {
        // Delete cookies for current server profile. If don't do this old credentials will be used
        // instead new one
        [self deleteCookies];
        
        self.keepSession = keepLogged;
        self.timeoutInterval = _defaultTimeoutInterval;
        self.serverProfile = serverProfile;
        
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:[JSUtils usedMimeType] forHTTPHeaderField:kJSRequestResponceType];
        
        self.responseSerializer.acceptableStatusCodes = nil;
        self.responseSerializer.acceptableContentTypes = nil;
        
        self.securityPolicy.allowInvalidCertificates = YES;
        
        [self configureRequestRedirectionHandling];
    }
    return self;
}

- (void) configureRequestRedirectionHandling {
    __weak typeof(self) weakSelf = self;
    [self setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        if (response) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                JSRequest *jsRequest = [strongSelf callBackForDataTask:task].request;
                if (jsRequest.redirectAllowed) {
                    // we don't use the new request built for us, except for the URL
                    NSURL *newURL = [request URL];
                    // We rely on that here!
                    NSMutableURLRequest *newRequest = [request mutableCopy];
                    [newRequest setURL: newURL];
                    return newRequest;
                }
            }
            return nil;
        } else {
            return request;
        }
    }];
}

- (NSMutableArray<JSCallBack *> *)requestCallBacks {
    if (!_requestCallBacks) {
        _requestCallBacks = [NSMutableArray new];
    }
    return _requestCallBacks;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    if (_timeoutInterval != timeoutInterval) {
        _timeoutInterval = timeoutInterval;
        self.requestSerializer.timeoutInterval = timeoutInterval;
        self.session.configuration.timeoutIntervalForRequest = timeoutInterval;
    }
}

#pragma mark -
#pragma mark Public methods

- (void)sendRequest:(nonnull JSRequest *)jsRequest {
    // Merge parameters with httpBody
    id parameters = [NSMutableDictionary dictionaryWithDictionary:jsRequest.params];
    if (jsRequest.body) {
        Class objectClass;
        EKObjectMapping *objectMapping;
        id serializedObject;
        
        if ([jsRequest.body isKindOfClass:[NSArray class]]) {
            objectClass = [[jsRequest.body lastObject] class];
            objectMapping = [objectClass objectMappingForServerProfile:self.serverProfile];
            serializedObject = [EKSerializer serializeCollection:jsRequest.body withMapping:objectMapping];
        } else {
            objectClass = [jsRequest.body class];
            objectMapping = [objectClass objectMappingForServerProfile:self.serverProfile];
            serializedObject = [EKSerializer serializeObject:jsRequest.body withMapping:objectMapping];
        }
        
        if (serializedObject) {
            if ([serializedObject isKindOfClass:[NSArray class]]) {
                parameters = serializedObject;
            } else {
                if ([objectClass respondsToSelector:@selector(requestObjectKeyPath)]) {
                    [parameters setObject:serializedObject forKey:[objectClass requestObjectKeyPath]];
                } else {
                    [parameters addEntriesFromDictionary:serializedObject];
                }
            }
        }
    }
    
    NSError *serializationError = nil;

    NSMutableURLRequest *request;
    switch(jsRequest.serializationType) {
        case JSRequestSerializationType_UrlEncoded: {
            request = [[AFHTTPRequestSerializer serializer] requestWithMethod:[JSRequest httpMethodStringRepresentation:jsRequest.method]
                                                                    URLString:[[NSURL URLWithString:jsRequest.fullURI relativeToURL:self.baseURL] absoluteString]
                                                                   parameters:parameters
                                                                        error:&serializationError];
            break;
        }
        case JSRequestSerializationType_JSON: {
            request = [self.requestSerializer requestWithMethod:[JSRequest httpMethodStringRepresentation:jsRequest.method]
                                                      URLString:[[NSURL URLWithString:jsRequest.fullURI relativeToURL:self.baseURL] absoluteString]
                                                     parameters:parameters
                                                          error:&serializationError];
            break;
        }
    }
    
    // Merge HTTP headers
    for (NSString *headerKey in [jsRequest.additionalHeaders allKeys]) {
        [request setValue:jsRequest.additionalHeaders[headerKey] forHTTPHeaderField:headerKey];
    }

    if (request.HTTPBody) {
        NSLog(@"BODY: %@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    }
    
    if (serializationError) {
        [self sendCallBackForRequest:jsRequest withOperationResult:[self operationResultForSerializationError:serializationError]];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request
                                                uploadProgress:nil
                                              downloadProgress:nil
                                             completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                                 __strong typeof(self) strongSelf = weakSelf;
                                                 if (strongSelf) {
                                                     JSOperationResult *operationResult = [strongSelf operationResultForRequest:jsRequest
                                                                                                                   withResponce:(NSHTTPURLResponse *)response
                                                                                                                 responseObject:responseObject
                                                                                                                          error:error];
                                                     [strongSelf sendCallBackForRequest:jsRequest withOperationResult:operationResult];
                                                 }
                                             }];
    // Creates bridge between RestKit's delegate and SDK delegate
    [self.requestCallBacks addObject:[[JSCallBack alloc] initWithDataTask:dataTask
                                                                  request:jsRequest]];
    [dataTask resume];
}

- (nullable JSServerInfo *)serverInfo {
    return self.serverProfile.serverInfo;
}

- (void)cancelAllRequests {
    for (JSCallBack *callback in self.requestCallBacks) {
        [callback.dataTask cancel];
    }
    
    [self.requestCallBacks removeAllObjects];
}

- (void)deleteCookies {
    [self updateCookiesWithCookies:nil];
}

- (void)updateCookiesWithCookies:(NSArray <NSHTTPCookie *>* __nullable)cookies
{
    _cookies = cookies;
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.serverProfile forKey:kJSSavedSessionServerProfileKey];
    [aCoder encodeBool:self.keepSession forKey:kJSSavedSessionKeepSessionKey];
    [aCoder encodeFloat:self.timeoutInterval forKey:kJSSavedSessionTimeoutKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    JSProfile *serverProfile = [aDecoder decodeObjectForKey:kJSSavedSessionServerProfileKey];
    if (serverProfile) {
        self = [super initWithCoder:aDecoder];
        if (self) {
            self.serverProfile = serverProfile;
            self.keepSession = [aDecoder decodeBoolForKey:kJSSavedSessionKeepSessionKey];
            self.timeoutInterval = [aDecoder decodeFloatForKey:kJSSavedSessionTimeoutKey];
            
            [self configureRequestRedirectionHandling];
        }
        return self;
    }
    return nil;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    JSRESTBase *newRestClient = [super copyWithZone:zone];
    newRestClient.timeoutInterval = self.timeoutInterval;
    newRestClient.keepSession = self.keepSession;
    newRestClient.serverProfile = self.serverProfile;
    [newRestClient configureRequestRedirectionHandling];
    return newRestClient;
}

#pragma mark -
#pragma mark Private methods

// Initializes result with helping properties: http status code,
// returned header fields and MIMEType
- (JSOperationResult *)operationResultForRequest:(JSRequest *)request withResponce:(NSHTTPURLResponse *)response responseObject:(id)responseObject error:(NSError *)error{
    JSOperationResult *result = [[JSOperationResult alloc] initWithStatusCode:response.statusCode
                                                              allHeaderFields:response.allHeaderFields
                                                                     MIMEType:response.MIMEType];
    
    result.request = request;
    
    if ([result.request.uri isEqualToString:kJS_REST_AUTHENTICATION_URI]) {
        BOOL isTokenFetchedSuccessful = YES;
        switch (response.statusCode) {
            case 401: // Unauthorized
            case 403: { // Forbidden
                isTokenFetchedSuccessful = NO;
                break;
            }
            case 302: { // redirect
                NSString *redirectURL = [response.allHeaderFields objectForKey:@"Location"];
                NSString *redirectUrlRegex = [NSString stringWithFormat:@"%@/login.html(;?)((jsessionid=.+)?)\\?error=1", self.serverProfile.serverUrl];
                NSPredicate *redirectUrlValidator = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", redirectUrlRegex];
                isTokenFetchedSuccessful = ![redirectUrlValidator evaluateWithObject:redirectURL];
                break;
            }
            default: {
                isTokenFetchedSuccessful = !error;
            }
        }
        if (!isTokenFetchedSuccessful) {
            result.error = [JSErrorBuilder errorWithCode:JSInvalidCredentialsErrorCode];
        } else if (error && [error.domain isEqualToString:NSURLErrorDomain]) {
            result.error = error;
        }
    } else {
        // Error handling
        if (![result isSuccessful] || error) {
            if (response.statusCode == 401) {
                result.error = [JSErrorBuilder httpErrorWithCode:JSSessionExpiredErrorCode
                                                        HTTPCode:response.statusCode];
            } else if (response.statusCode && !error) {
                result.error = [JSErrorBuilder httpErrorWithCode:JSHTTPErrorCode
                                                        HTTPCode:response.statusCode];
            } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
                switch (error.code) {
                    case NSURLErrorUserCancelledAuthentication:
                    case NSURLErrorUserAuthenticationRequired: {
                        result.error = [JSErrorBuilder errorWithCode:JSSessionExpiredErrorCode];
                        break;
                    }
                    case NSURLErrorTimedOut: {
                        result.error = [JSErrorBuilder errorWithCode:JSRequestTimeOutErrorCode];
                        break;
                    }
                    default: {
                        result.error = [JSErrorBuilder httpErrorWithCode:JSHTTPErrorCode
                                                                HTTPCode:response.statusCode];
                    }
                }
            } else if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
                result.body = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];

                if ([result.MIMEType isEqualToString:[JSUtils usedMimeType]]) {
                    result.error = [JSErrorBuilder errorWithCode:JSDataMappingErrorCode];
                } else {
                    result.error = [JSErrorBuilder errorWithCode:JSOtherErrorCode];
                }
            } else {
                result.error = [JSErrorBuilder errorWithCode:JSOtherErrorCode
                                                     message:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }

        // Save file if needed
        if (!result.request.responseAsObjects && [responseObject isKindOfClass:[NSURL class]]) {
            NSString *destinationFilePath = result.request.downloadDestinationPath;
            NSString *sourceFilePath = [(NSURL *)responseObject absoluteString];
            
            if (!result.error && sourceFilePath && destinationFilePath && [[NSFileManager defaultManager] fileExistsAtPath:sourceFilePath]) {
                NSError *fileSavingError = nil;
                [[NSFileManager defaultManager] moveItemAtPath:sourceFilePath toPath:destinationFilePath error:&fileSavingError];
                if (fileSavingError) {
                    result.error = [JSErrorBuilder errorWithCode:JSFileSavingErrorCode
                                                         message:fileSavingError.userInfo[NSLocalizedDescriptionKey]];
                }
            } else {
                result.error = [JSErrorBuilder errorWithCode:JSFileSavingErrorCode];
            }
            if (sourceFilePath && [[NSFileManager defaultManager] fileExistsAtPath:sourceFilePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:sourceFilePath error:nil];
            }
        } else if(result.request.responseAsObjects && responseObject) { // Response object maping
            NSError *convertingError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:&convertingError];
            if (!convertingError) {
                result.body = jsonData;
            }
            
            if (![result isSuccessful]) {
                JSMapping *mapping = [JSMapping mappingWithObjectMapping:[[JSErrorDescriptor class] objectMappingForServerProfile:self.serverProfile] keyPath:nil];
                result.objects = [self objectFromExternalRepresentation:responseObject
                                                            withMapping:mapping];
                
                NSString *message = @"";
                for (JSErrorDescriptor *errDescriptor in result.objects) {
                    if ([errDescriptor isKindOfClass:[errDescriptor class]]) {
                        NSString *formatString = message.length ? @",\n%@" : @"%@";
                        message = [message stringByAppendingFormat:formatString, errDescriptor.message];
                    }
                }
                if (message.length) {
                    result.error = [JSErrorBuilder errorWithCode:JSClientErrorCode message:message];
                }
            } else {
                result.objects = [self objectFromExternalRepresentation:responseObject
                                                            withMapping:request.objectMapping];
            }
        } else if (!result.request.responseAsObjects && responseObject) { // Return raw data
            NSError *convertingError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:&convertingError];
            if (!convertingError) {
                result.body = jsonData;
            }
        }
    }

    if (result.error.code == JSSessionExpiredErrorCode) {
        [self deleteCookies];
    }

    return result;
}

- (void) sendCallBackForRequest:(JSRequest *)request withOperationResult:(JSOperationResult *)result {
    JSCallBack *callBack = [self callBackForRequest:request];
    if (callBack) {
        [self.requestCallBacks removeObject:callBack];
#ifndef __RELEASE__
        NSLog(_requestFinishedTemplateMessage, [callBack.dataTask.originalRequest.URL absoluteString], [result bodyAsString]);
#endif
    }

    if (request.shouldResendRequestAfterSessionExpiration && result.error && result.error.code == JSSessionExpiredErrorCode && self.keepSession) {
        __weak typeof(self)weakSelf = self;
        [self verifyIsSessionAuthorizedWithCompletion:^(BOOL isSessionAuthorized) {
            __strong typeof(self)strongSelf = weakSelf;
            if (isSessionAuthorized) {
                request.shouldResendRequestAfterSessionExpiration = NO;
                [strongSelf sendRequest:request];
            } else {
                if (request.completionBlock) {
                    dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                        request.completionBlock(result);
                    });
                }
            }
        }];
    } else {
        if (request.completionBlock) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                request.completionBlock(result);
            });
        }
    }
}

- (JSCallBack *)callBackForDataTask:(NSURLSessionTask *)dataTask {
    for (JSCallBack *callBack in self.requestCallBacks) {
        if (callBack.dataTask == dataTask) {
            return callBack;
        }
    }
    return nil;
}

- (JSCallBack *)callBackForRequest:(JSRequest *)request {
    for (JSCallBack *callBack in self.requestCallBacks) {
        if (callBack.request == request) {
            return callBack;
        }
    }
    return nil;
}

- (NSArray *)objectFromExternalRepresentation:(id)responceObject withMapping:(JSMapping *)mapping {
    id nestedRepresentation = nil;
    if ([mapping.keyPath length]) {
        nestedRepresentation = [responceObject valueForKeyPath:mapping.keyPath];
    } else {
        nestedRepresentation = responceObject;
    }
    
    if (nestedRepresentation && nestedRepresentation != [NSNull null]) {
        // Found something to map
        if ([nestedRepresentation isKindOfClass:[NSArray class]]) {
            id mappingResult = [EKMapper arrayOfObjectsFromExternalRepresentation:nestedRepresentation withMapping:mapping.objectMapping];
            if (mappingResult) {
                return mappingResult;
            }
        } else {
            id mappingResult = [EKMapper objectFromExternalRepresentation:nestedRepresentation withMapping:mapping.objectMapping];
            if (mappingResult) {
                return @[mappingResult];
            }
        }
    } else { // Handle value not found case
#ifndef __RELEASE__
        NSLog(@"Value cann't be mapped for mapping: %@", mapping);
#endif
    }
    return nil;
}

- (JSOperationResult *) operationResultForSerializationError:(NSError *)serializationError {
    JSOperationResult *result = [JSOperationResult new];
    result.error = [NSError errorWithDomain:JSErrorDomain code:JSOtherErrorCode userInfo:serializationError.userInfo];
    return result;
}

@end
