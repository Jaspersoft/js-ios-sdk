//
//  RKRequest+RKAdditions.h
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 03.12.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface RKRequest (RKAdditions)

// Setup the NSURLRequest. The request must be prepared right before dispatching
- (BOOL)prepareURLRequestWithTimeoutInterval;

@end
