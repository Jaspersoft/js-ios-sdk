//
//  JSRestKitManagerFactory.h
//  jaspersoft-sdk
//
//  Created by Volodya Sabadosh on 7/17/12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <Foundation/Foundation.h>

/** 
 @cond EXCLUDE_JS_REST_KIT_MANAGER_FACTORY

 Helps to create and set define mapping rules for RestKit's RKObjectManager class.
 The object manager is the primary interface for interacting with JasperReports 
 Server REST API resources via HTTP
 
 @author Volodya Sabadosh vsabadosh@jaspersoft.com
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.3
 */
@interface JSRestKitManagerFactory : NSObject

/** 
 Creates and configures RKObjectManager instance with mapping rules for specified 
 classes.
 
 Class mapping rule describes how returned HTTP response (in JSON, XML and other
 formats) should be mapped directly to this class.
 
 @param classes A list of classes for which mapping rules will be created
 @return A configured object manager
 */
+ (RKObjectManager *)createRestKitObjectManagerForClasses:(NSArray *)classes;

@end

/** @endcond */
