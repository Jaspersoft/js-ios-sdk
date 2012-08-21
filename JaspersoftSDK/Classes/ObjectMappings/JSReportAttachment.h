//
//  JSReportAttachment.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 13.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSReportAttachment : NSObject

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *name;

- (NSString *)description;

@end
