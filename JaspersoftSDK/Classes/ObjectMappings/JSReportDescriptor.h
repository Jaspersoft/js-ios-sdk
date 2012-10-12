//
//  JSReportDescriptor.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 06.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents a report descriptor entity for convenient XML serialization process
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @version 1.0
 */
@interface JSReportDescriptor : NSObject

@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *originalUri;
@property (nonatomic, retain) NSNumber *totalPages;
@property (nonatomic, retain) NSNumber *startPage;
@property (nonatomic, retain) NSNumber *endPage;
@property (nonatomic, retain) NSArray *attachments;

- (NSString *)description;

@end
