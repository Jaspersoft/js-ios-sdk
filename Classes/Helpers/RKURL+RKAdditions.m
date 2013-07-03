//
//  RKURL+RKAdditions.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 31.10.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "RKURL+RKAdditions.h"

@implementation RKURL (RKAdditions)

// Here are some black metamagic. Please watch carefuly...
// Notice: this is TEMP fix and will be removed as soon as new version of RestKit
// will be published
- (id)initWithBaseURLFixed:(NSURL *)theBaseURL resourcePath:(NSString *)theResourcePath queryParameters:(NSDictionary *)theQueryParameters {
    // Merge any existing query parameters with the incoming dictionary
    NSString *resourcePathQueryParameters = [NSString stringWithString:theResourcePath ?: @""];
    NSRange chopRange = [resourcePathQueryParameters rangeOfString:@"?"];
    if (chopRange.length > 0) {
        chopRange.location+=1; // we want inclusive chopping up *through* "?"
        if (chopRange.location < [resourcePathQueryParameters length]) {
            resourcePathQueryParameters = [resourcePathQueryParameters substringFromIndex:chopRange.location];
        }
    } else {
        resourcePathQueryParameters = nil;
    }
    
    NSMutableString *mergedQueryParameters = [[NSMutableString alloc] init];
    NSString *baseURLParams = [[theBaseURL queryParameters] URLEncodedString];
    if (baseURLParams.length > 0) {
        [mergedQueryParameters appendString:[[theBaseURL queryParameters] URLEncodedString]];
        [mergedQueryParameters appendString:@"&"];
    }
    if (resourcePathQueryParameters.length > 0) {
        [mergedQueryParameters appendString:resourcePathQueryParameters];
        [mergedQueryParameters appendString:@"&"];
    }
    NSString *queryParamsString = [theQueryParameters URLEncodedString];
    if (queryParamsString.length > 0) {
        [mergedQueryParameters appendString:[theQueryParameters URLEncodedString]];
    }
    
    if ([mergedQueryParameters hasSuffix:@"&"]) {
        [mergedQueryParameters deleteCharactersInRange:NSMakeRange(mergedQueryParameters.length - 1, 1)];
    }
    
    if (mergedQueryParameters.length > 0) {
        [mergedQueryParameters insertString:@"?" atIndex:0];
    }
    
    // Build the new URL path
    NSRange queryCharacterRange = [theResourcePath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
    NSString *resourcePathWithoutQueryString = (queryCharacterRange.location == NSNotFound) ? theResourcePath : [theResourcePath substringToIndex:queryCharacterRange.location];
    NSString *baseURLPath = [[theBaseURL path] isEqualToString:@"/"] ? @"" : [[theBaseURL path] stringByStandardizingPath];
    NSString *completePath = resourcePathWithoutQueryString ? [baseURLPath stringByAppendingString:resourcePathWithoutQueryString] : baseURLPath;
    NSString* completePathWithQuery = [completePath stringByAppendingString:mergedQueryParameters];
    
    // NOTE: You can't safely use initWithString:relativeToURL: in a NSURL subclass, see http://www.openradar.me/9729706
    // So we unfortunately convert into an NSURL before going back into an NSString -> RKURL
    NSURL* completeURL = [NSURL URLWithString:completePathWithQuery relativeToURL:theBaseURL];
    if (!completeURL) {
        RKLogError(@"Failed to build RKURL by appending resourcePath and query parameters '%@' to baseURL '%@'", theResourcePath, theBaseURL);
        return nil;
    }
    
    self = [self initWithString:[completeURL absoluteString]];
    if (self) {
        [self performSelector:@selector(setBaseURL:) withObject:theBaseURL];
        [self performSelector:@selector(setResourcePath:) withObject:theResourcePath];
    }
    
    return self;
}

@end
