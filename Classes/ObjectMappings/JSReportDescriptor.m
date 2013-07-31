/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2013 Jaspersoft Corporation. All rights reserved.
 * http://community.jaspersoft.com/project/mobile-sdk-ios
 * 
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 * 
 * This program is part of Jaspersoft Mobile SDK for iOS.
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
 * along with Jaspersoft Mobile SDK for iOS. If not, see 
 * <http://www.gnu.org/licenses/lgpl>.
 */

//
//  JSReportDescriptor.m
//  Jaspersoft Corporation
//

#import "JSReportDescriptor.h"

@implementation JSReportDescriptor

@synthesize uuid = _uuid;
@synthesize originalUri = _originalUri;
@synthesize totalPages = _totalPages;
@synthesize startPage = _startPage;
@synthesize endPage = _endPage;
@synthesize attachments = _attachments;

- (NSString *)description {
    return [NSString stringWithFormat:@"Report Descriptor - uuid: %@; Original URI: %@; Total Pages: %@; Start Page: %@; End Page: %@; Attachments Count: %lu", self.uuid, self.originalUri, self.totalPages, self.startPage, self.endPage, (unsigned long)self.attachments.count];
}

@end
