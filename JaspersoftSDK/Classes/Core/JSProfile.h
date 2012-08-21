//
//  JSProfile.h
//  RestKitDemo
//
//  Created by Vlad Zavadskii on 03.07.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Class uses to store connection details to use the JasperReports Server REST API
 */
@interface JSProfile : NSObject <NSCopying>

@property (nonatomic, retain) NSString *alias;
@property (nonatomic, retain) NSString *serverUrl;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *organization;

- (id)initWithAlias:(NSString *)alias username:(NSString *)user password:(NSString *)pass 
      organization:(NSString *)org serverUrl:(NSString *)url;
- (NSString *)getUsenameWithOrganization;

@end
