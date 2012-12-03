//
//  RKRequest+RKAdditions.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 03.12.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
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
