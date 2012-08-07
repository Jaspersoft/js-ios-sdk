/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2001 - 2011 Jaspersoft Corporation. All rights reserved.
 * http://www.jasperforge.org/projects/mobile
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is part of Jaspersoft Mobile SDK.
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
 * along with Jaspersoft Mobile SDK. If not, see <http://www.gnu.org/licenses/>.
 */

//
//  JSUtils.h
//  Jaspersoft
//
//  Created by Giulio Toffoli on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSResourceDescriptor.h"
#import "JSConstants.h"
#import "JSClient.h"


@interface JSUtils : NSObject {
    
}


/** 
 * Look inside a resource descriptor's children to find a valid data source resource.
 * If a data source resource is not found, it scans recursively for resource descriptors
 * of type reference. The first datasource found is returned.
 * 
 * This method is used to find a data source for an input control query.
 * 
 * @param rd (JSResourceDescriptor *) the resource descriptor in which look for data sources
 * @param client (JSClient *) a client used to get nested resources if required (i.e. resolve references). If null, it is ignore.
 * @return the datasource uri or nil if no datasource is found.
 *
 */
+(NSString *)findDataSourceUri:(JSResourceDescriptor *)rd withClient: (JSClient *)client;


/** 
 * There are many type of resources that are actually data sources.
 * This method look for the wsType of the resource descriptor and return true
 * if it is one of the following:
 *
 * JS_TYPE_DATASOURCE
 * JS_TYPE_DATASOURCE_BEAN
 * JS_TYPE_DATASOURCE_CUSTOM
 * JS_TYPE_DATASOURCE_JDBC
 * JS_TYPE_DATASOURCE_JNDI
 *
 * @param rd (JSResourceDescriptor *) the resource descriptor in which look for data sources
 * @return the datasource uri or nil if no datasource is found.
 *
 */
+(bool)isDataSourceResource:(JSResourceDescriptor *)rd;



+(bool)checkNetwork:(bool) showMessage client: (JSClient *)client;

@end
