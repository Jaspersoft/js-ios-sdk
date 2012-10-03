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
//  JSResourceProperty.h
//  Jaspersoft Corporation
//

/**
 * The JSResourceProperty object holds property value for resource descriptor
 *
 * @since version 1.0
 */
@interface JSResourceProperty : NSObject {
}

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *value;
@property(nonatomic, retain) NSMutableArray *resourceProperties;

+ (id)resourceProperty;
- (NSString *)getPropertyValue:(NSString *)pname;
- (JSResourceProperty *)getPropertyByName:(NSString *)pname;

@end
