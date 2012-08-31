//
//  JSReportAttachment.h
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 13.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents a report attachment entity for convenient XML serialization process
 
 @author Vlad Zavadskyi vzavadskii@jaspersoft.com
 @version 1.0
 */
@interface JSReportAttachment : NSObject

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *name;

- (NSString *)description;

@end
