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
//  RKRequest+RKAdditions.m
//  Jaspersoft Corporation
//

#import <RestKit/RestKit.h>
#import "RKRequest+RKAdditions.h"

@implementation RKRequest (RKAdditions)

// Setup the NSURLRequest. The request must be prepared right before dispatching
- (BOOL)prepareURLRequestWithTimeoutInterval
{
    [self.URLRequest setHTTPMethod:[self HTTPMethod]];
    
    // Set timeout interval. Missed in version v0.10.3 (tags)
    [self.URLRequest setTimeoutInterval:self.timeoutInterval];
    
    if ([self.delegate respondsToSelector:@selector(requestWillPrepareForSend:)]) {
        [self.delegate requestWillPrepareForSend:self];
    }
    
    [self performSelector:@selector(setRequestBody)];
    [self performSelector:@selector(addHeadersToRequest)];
    
    NSString *body = [[NSString alloc] initWithData:[self.URLRequest HTTPBody] encoding:NSUTF8StringEncoding];
    RKLogTrace(@"Prepared %@ URLRequest '%@'. HTTP Headers: %@. HTTP Body: %@.", [self HTTPMethod], self.URLRequest, [self.URLRequest allHTTPHeaderFields], body);
    
    return YES;
}

@end
