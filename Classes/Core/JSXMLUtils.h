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
//  JSXMLUtils.h
//  Jaspersoft Corporation
//

#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

/**
 * Provides methods for getting different parts of response returned in XML format
 *
 * @since 1.0
 */
@interface JSXMLUtils : NSObject {
}

// Return a string gived a node and an xpath query
+ (NSString *)getValueFromNode:(xmlDocPtr)doc xPathQuery:(NSString *)query;
+ (NSInteger)getIntValueFromNode:(xmlDocPtr)doc xPathQuery:(NSString *)query;
+ (NSString *)getNodeValue:(xmlNode *)node;
+ (NSString *)getAttribute:(const xmlChar *)name ofNode:(xmlNode *)node;

@end
