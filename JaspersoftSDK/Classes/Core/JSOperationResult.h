//
//  JSOperationResult.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSOperationResult : NSObject

// Different results
@property (nonatomic, retain) NSArray *objects;
// Used for downloading files
@property (nonatomic, retain) NSData *body;
@property (nonatomic, retain) NSString *downloadDestinationPath;

// Informational properties
@property (nonatomic, readonly) NSError *error;
@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, readonly) NSDictionary *allHeaderFields;
@property (nonatomic, readonly) NSString *MIMEType;

- (id)initWithStatusCode:(NSInteger)statusCode allHeaderFields:(NSDictionary *)allHeaderFields MIMEType:(NSString *)MIMEType error:(NSError *)error;

@end
