//
//  RKURL+RKAdditions.h
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 31.10.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface RKURL (RKAdditions)

// Original method has an issue, it removing multiple params from URL if they have
// same name (similar issue https://github.com/RestKit/RestKit/issues/855 ).
// This is temp fix and it will be removed from SDK
- (id)initWithBaseURLFixed:(NSURL *)theBaseURL resourcePath:(NSString *)theResourcePath queryParameters:(NSDictionary *)theQueryParameters;

@end
