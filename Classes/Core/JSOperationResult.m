//
//  JSOperationResult.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 12.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSOperationResult.h"
#import "JSRequest.h"

@implementation JSOperationResult

@synthesize objects = _objects;
@synthesize body = _body;
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

- (NSString *)description {
    return [NSString stringWithFormat:@"Status Code: %lu; AllHeaderFields %@; MIMEType %@; Error: %@", 
            (unsigned long)self.statusCode, self.allHeaderFields, self.MIMEType, self.error];
}

@end
