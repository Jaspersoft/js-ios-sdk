//
//  JSOperationResult.m
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 12.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSOperationResult.h"

@implementation JSOperationResult

@synthesize objects = _objects;
@synthesize body = _body;
@synthesize error = _error;
@synthesize statusCode = _statusCode;
@synthesize allHeaderFields = _allHeaderFields;
@synthesize MIMEType = _MIMEType;
@synthesize downloadDestinationPath = _downloadDestinationPath;

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

- (NSString *)description {
    return [NSString stringWithFormat:@"Status Code: %i; AllHeaderFields %@; MIMEType %@; Error: %@", 
            self.statusCode, self.allHeaderFields, self.MIMEType, self.error];
}

@end
