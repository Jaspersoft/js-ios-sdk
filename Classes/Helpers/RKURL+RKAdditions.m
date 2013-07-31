/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2013 Jaspersoft Corporation. All rights reserved.
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
//  RKURL+RKAdditions.m
//  Jaspersoft Corporation
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
