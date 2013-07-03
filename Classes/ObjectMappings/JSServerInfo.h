//
//  JSServerInfo.h
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 30.10.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.4
 */
@interface JSServerInfo : NSObject

@property (nonatomic, retain) NSString *build;
@property (nonatomic, retain) NSString *edition;
@property (nonatomic, retain) NSString *editionName;
@property (nonatomic, retain) NSString *expiration;
@property (nonatomic, retain) NSString *features;
@property (nonatomic, retain) NSString *licenseType;
@property (nonatomic, retain) NSString *version;

- (NSInteger)versionAsInteger;

@end
