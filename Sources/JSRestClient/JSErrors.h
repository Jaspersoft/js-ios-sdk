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
//  JSErrors.h
//  Jaspersoft Corporation
//

typedef NS_ENUM (NSInteger, JSErrorCode) {
    JSOtherErrorCode                    = 1000,         // All other errors
    JSServerNotReachableErrorCode       = 1001,         // Server not reachable error
    JSNetworkErrorCode                  = 1002,         // HTTP erorrs (status codes 404, 500).
    JSRequestTimeOutErrorCode           = 1003,         // Request TimeOut error
    JSInvalidCredentialsErrorCode       = 1004,         // Invalid Credentilas error
    JSSessionExpiredErrorCode           = 1005,         // Session expired error
    JSClientErrorCode                   = 1006,         // Client error code - when JSErrorDescriptor are received
    JSDataMappingErrorCode              = 1007,         // Data Mapping error code - when responce did load successfully, but can't be parsed
    JSFileSavingErrorCode               = 1008,         // Write to file and file saving error
    JSReportSavingErrorCode             = 1009          // Report saving error
};
