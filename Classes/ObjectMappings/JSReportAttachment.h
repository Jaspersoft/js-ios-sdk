//
//  JSReportAttachment.h
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 13.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents a report attachment entity for convenient XML serialization process
 
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.3
 */
@interface JSReportAttachment : NSObject

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *name;

- (NSString *)description;

@end
