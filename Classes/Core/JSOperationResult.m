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
//  JSOperationResult.m
//  Jaspersoft Corporation
//

#import "JSOperationResult.h"
#import "JSRequest.h"

@interface JSOperationResult()
@property (nonatomic, strong, readwrite) NSString *bodyAsString;

@end

@implementation JSOperationResult

- (id)initWithStatusCode:(NSInteger)statusCode allHeaderFields:(NSDictionary *)allHeaderFields
                MIMEType:(NSString *)MIMEType{
    if (self = [super init]) {
        _statusCode = statusCode;
        _allHeaderFields = allHeaderFields;
        _MIMEType = MIMEType;
    }
    
    return self;
}

- (id)init {
    return [self initWithStatusCode:-1 allHeaderFields:[NSDictionary dictionary] MIMEType:@""];
}

- (BOOL)isSuccessful {
    return self.statusCode >= 200 && self.statusCode < 300;
}

- (NSString *)bodyAsString {
    if (!_bodyAsString && self.body) {
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _bodyAsString = [[NSString alloc] initWithData:self.body encoding:NSUTF8StringEncoding];
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    }
    return _bodyAsString;
}
@end
