/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2014 Jaspersoft Corporation. All rights reserved.
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
//  JSReportExecutionRequest.h
//  Jaspersoft Corporation
//

#import <Foundation/Foundation.h>
#import "JSObjectMappingsProtocol.h"
#import "JSReportParameter.h"

/**
 Represents a report execution request descriptor for convenient XML serialization process

 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Alexey Gubarev ogubarie@tibco.com
 @since 1.8
 */
@interface JSReportExecutionRequest : NSObject <JSObjectMappingsProtocol>

@property (nonatomic, retain, nonnull) NSString *reportUnitUri;
@property (nonatomic, retain, nonnull) NSString *async;
@property (nonatomic, retain, nonnull) NSString *outputFormat;
@property (nonatomic, retain, nonnull) NSString *interactive;
@property (nonatomic, retain, nonnull) NSString *freshData;
@property (nonatomic, retain, nonnull) NSString *saveDataSnapshot;
@property (nonatomic, retain, nonnull) NSString *ignorePagination;
@property (nonatomic, retain, nonnull) NSString *baseURL;
@property (nonatomic, retain, nullable) NSString *transformerKey;
@property (nonatomic, retain, nullable) NSString *pages;
@property (nonatomic, retain, nullable) NSString *attachmentsPrefix;
@property (nonatomic, assign) JSMarkupType markupType;
@property (nonatomic, retain, nullable) NSArray <JSReportParameter *> *parameters;

@end
