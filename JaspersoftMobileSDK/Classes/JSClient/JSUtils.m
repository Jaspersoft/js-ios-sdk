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
//  JSUtils.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSUtils.h"
#import "JSConstants.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation JSUtils


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
+(NSString *)findDataSourceUri:(JSResourceDescriptor *)rd withClient: (JSClient *)client
{
    
    //NSLog(@"1. Looking for datasources in %@",[rd name]);
    
    // Scan the children...
    for (int i=0; i< [[rd resourceDescriptors] count]; ++i)
    {
        
        JSResourceDescriptor *dsrd = (JSResourceDescriptor *)[[rd resourceDescriptors] objectAtIndex:i];
        
        if ([JSUtils isDataSourceResource:dsrd]) 
        {
            //1.1. Found datasource, let's check if it is a reference or a real resource
            if ([dsrd resourcePropertyValue: JS_PROP_REFERENCE_URI] != nil) return  [dsrd resourcePropertyValue: JS_PROP_REFERENCE_URI];
            return [dsrd uri];
        }
    }
    
    //NSLog(@"2. No datasource found in %@", [rd name]);
    
    // If we reached this point, there is no ds resource in this resource descrioptor...
    // Let's look for referenced resources...
    for (int i=0; i< [[rd resourceDescriptors] count]; ++i)
    {
        JSResourceDescriptor *refrd = (JSResourceDescriptor *)[[rd resourceDescriptors] objectAtIndex:i];
        if ([[refrd wsType] isEqualToString: JS_TYPE_REFERENCE])
        {
            NSString *refUri = [refrd resourcePropertyValue:JS_PROP_REFERENCE_URI];
            
            //NSLog(@"3. Found reference %@", refUri);
            
            if (refUri != nil && client != nil)
            {
                // Load this resource descriptor....
                JSOperationResult *res = [client resourceInfo:refUri];
                
                if (res != nil && [[res resourceDescriptors] count] == 1)
                {
                    JSResourceDescriptor *cRes = (JSResourceDescriptor *)[[res resourceDescriptors] objectAtIndex:0];
                    if ([JSUtils isDataSourceResource:cRes])
                    {
                        //NSLog(@"4. The sub resoure is a datasource %@", [cRes name]);
                        return [cRes uri];
                    }
                    
                    //NSLog(@"5. Introspecting %@", [cRes name]);
                    NSString *uri = [JSUtils findDataSourceUri:cRes withClient:client];
                    
                    if (uri != nil) return uri;
                    
                    //NSLog(@"6. %@ does not contain any datasource", [cRes name]);
                    
                }
            }
        }
        
        
    }

    //NSLog(@"7. Datasource search failed in %@", rd);
    return nil;
    

}


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
+(bool)isDataSourceResource:(JSResourceDescriptor *)rd
{
    if (rd == nil) return NO;
    
    if ([[rd wsType] isEqualToString: JS_TYPE_DATASOURCE])        return YES;
    if ([[rd wsType] isEqualToString: JS_TYPE_DATASOURCE_BEAN])   return YES;
    if ([[rd wsType] isEqualToString: JS_TYPE_DATASOURCE_CUSTOM]) return YES;
    if ([[rd wsType] isEqualToString: JS_TYPE_DATASOURCE_JDBC])   return YES;
    if ([[rd wsType] isEqualToString: JS_TYPE_DATASOURCE_JNDI])   return YES;
    
    return false;
    
    
    
}

+(bool)checkNetwork:(bool) showMessage client: (JSClient *)client
{
        SCNetworkReachabilityFlags flags;
        
        if (client == nil) return false;
    
        NSURL *url = [NSURL URLWithString: [client baseUrl]];
        
        if (url == nil) return false;
        
        SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [[url host] UTF8String]);
    
        if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
        {
            
            if (flags & kSCNetworkReachabilityFlagsReachable)
            {
                //NSLog(@"server reachable");
                return true;   
            }
        }
    
        if (showMessage)
        {
            UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"Server Unreachable" message:@"Please check your network connection and the server URL." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
            [uiView show];
        }
    
        return false;
}







@end
