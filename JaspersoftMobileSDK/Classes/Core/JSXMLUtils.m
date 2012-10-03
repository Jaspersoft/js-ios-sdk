/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2001 - 2011 Jaspersoft Corporation. All rights reserved.
 * http://community.jaspersoft.com/project/mobile-sdk-ios
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
//  JSXMLUtils.m
//  Jaspersoft Corporation
//

#import "JSXMLUtils.h"
#import "JSConstants.h"

@implementation JSXMLUtils

// Return a string gived a node and an xpath query
+ (NSString *)getValueFromNode:(xmlDocPtr)doc xPathQuery:(NSString *)query 
{
	NSString *value=nil;
	
    xmlXPathContextPtr xpathCtx; 
    xmlXPathObjectPtr xpathObj; 
	
    /* Create XPath evaluation context */
    xpathCtx = xmlXPathNewContext(doc);
	
    if(xpathCtx == NULL)
    {
        NSLog(@"Unable to create XPath context.");
        return nil;
    }
    
    /* Evaluate XPath expression */
    xmlChar *queryString = (xmlChar *)[query UTF8String];
	
    xpathObj = xmlXPathEvalExpression(queryString, xpathCtx);
    
	if(xpathObj != NULL) {
		
    	xmlNodeSetPtr nodes = xpathObj->nodesetval;
		if (nodes && nodes->nodeNr > 0)
		{
			xmlChar *valStr = xmlNodeGetContent(nodes->nodeTab[0]);
			if (valStr != NULL)
			{
				value = [NSString stringWithUTF8String:(const char *)valStr];
				xmlFree(valStr);
			}
		}
		xmlXPathFreeObject(xpathObj);
	}
	
    /* Cleanup */
    xmlXPathFreeContext(xpathCtx); 
    
    return value;
}

// Return the text value of the specified attribute of the node.
+ (NSString *)getAttribute:(const xmlChar *)attrName ofNode:(xmlNode *)node {

	NSString *val = nil;
	
	if (xmlHasProp(node, attrName )) { 
		xmlChar *attr = xmlGetProp(node, attrName);
		if (attr != NULL)
		{
			val = [NSString stringWithUTF8String: (const char *)attr];
			free(attr);
		}
	}
	
	return val;
	
}

// Return the text value of the specified node.
+ (NSString *)getNodeValue:(xmlNode *)node {
	
	NSString *value = nil;
	
	xmlChar *valStr = xmlNodeGetContent(node);
	if (valStr != NULL)
	{
		value = [NSString stringWithUTF8String:(const char *)valStr];
		xmlFree(valStr);
	}	
	return value;
}

+ (NSInteger)getIntValueFromNode:(xmlDocPtr)doc xPathQuery:(NSString *)query
{
	NSString *valStr = [JSXMLUtils getValueFromNode:doc xPathQuery:query];
	
	if (valStr != NULL)
	{
		return [valStr integerValue];
	}	
	return 0;
}


@end
