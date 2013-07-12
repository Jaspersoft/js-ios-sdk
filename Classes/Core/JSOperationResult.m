//
//  JSOperationResult.m
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 12.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSOperationResult.h"
#import "JSRequest.h"

@implementation JSOperationResult

@synthesize objects = _objects;
@synthesize body = _body;
@synthesize bodyAsString = _bodyAsString;
@synthesize downloadDestinationPath = _downloadDestinationPath;
@synthesize request = _request;
@synthesize error = _error;
@synthesize statusCode = _statusCode;
@synthesize allHeaderFields = _allHeaderFields;
@synthesize MIMEType = _MIMEType;

- (id)initWithStatusCode:(NSInteger)statusCode allHeaderFields:(NSDictionary *)allHeaderFields
                MIMEType:(NSString *)MIMEType error:(NSError *)error {
    if (self = [super init]) {
        _statusCode = statusCode;
        _allHeaderFields = allHeaderFields;
        _MIMEType = MIMEType;
        _error = error;
    }
    
    return self;
}

- (id)init {
    return [self initWithStatusCode:-1 allHeaderFields:[NSDictionary dictionary] MIMEType:@"" error: nil];
}

- (NSString *)downloadDestinationPath {
    return self.request.downloadDestinationPath;
}

- (BOOL)isInvalid {
    return self.statusCode < 100 || self.statusCode > 600;
}

- (BOOL)isInformational {
    return self.statusCode >= 100 && self.statusCode < 200;
}

- (BOOL)isSuccessful {
    return self.statusCode >= 200 && self.statusCode < 300;
}

- (BOOL)isRedirection {
    return self.statusCode >= 300 && self.statusCode < 400;
}

- (BOOL)isError {
    return self.statusCode >= 400 && self.statusCode < 600;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Status Code: %lu; AllHeaderFields %@; MIMEType %@; Error: %@", 
            (unsigned long)self.statusCode, self.allHeaderFields, self.MIMEType, self.error];
}

@end
