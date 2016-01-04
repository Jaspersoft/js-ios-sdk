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
//  JSConstants.h
//  Jaspersoft Corporation
//

/**
 Provides helping constants for different types of resources and API parts
 
 @author Giulio Toffoli giulio@jaspersoft.com
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @author Alexey Gubarev ogubarie@tibco.com

 @since 1.0
 */

/**
 @name Error Codes
 @{
 */
typedef NS_ENUM (NSInteger, JSErrorCode) {
    JSOtherErrorCode                = 1000, // All other errors
    JSServerNotReachableErrorCode,          // Server not reachable error
    JSRequestTimeOutErrorCode,              // Request TimeOut error
    
    JSHTTPErrorCode,                        // HTTP erorrs (status codes 404, 500).
    
    JSInvalidCredentialsErrorCode,          // Invalid Credentilas error
    JSSessionExpiredErrorCode,              // Session expired error
    
    JSClientErrorCode,                      // Client error code - when JSErrorDescriptor are received
    
    JSDataMappingErrorCode,                 // Data Mapping error code - when responce did load successfully, but can't be parsed
    
    JSFileSavingErrorCode,                  // Write to file and file saving error
};
/** @} */

/**
 @name JS Version Codes
 @{
 */
extern NSString * const JSErrorDomain;
extern NSString * const JSHTTPErrorDomain;
extern NSString * const JSAuthErrorDomain;

/** @} */


/**
 @name JS Version Codes
 @{
 */
extern float const kJS_SERVER_VERSION_CODE_UNKNOWN;
extern float const kJS_SERVER_VERSION_CODE_EMERALD_5_5_0;
extern float const kJS_SERVER_VERSION_CODE_EMERALD_5_6_0;
extern float const kJS_SERVER_VERSION_CODE_AMBER_6_0_0;
extern float const kJS_SERVER_VERSION_CODE_AMBER_6_1_0;
extern float const kJS_SERVER_VERSION_CODE_JADE_6_2_0;
/** @} */

/**
 @name JS Editions
 @{
 */
extern NSString *const kJS_SERVER_EDITION_CE;
extern NSString *const kJS_SERVER_EDITION_PRO;
/** @} */

/**
 @name Provided here from InputControl for facility
 @{
 */
typedef NS_ENUM (NSInteger, kJS_IC_TYPE) {
    kJS_IC_TYPE_UNKNOWN = 0,
    kJS_IC_TYPE_BOOLEAN = 1,
    kJS_IC_TYPE_SINGLE_VALUE = 2,
    kJS_IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES = 3,
    kJS_IC_TYPE_SINGLE_SELECT_QUERY = 4,
    kJS_IC_TYPE_MULTI_VALUE = 5,
    kJS_IC_TYPE_MULTI_SELECT_LIST_OF_VALUES = 6,
    kJS_IC_TYPE_MULTI_SELECT_QUERY = 7,
    kJS_IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES_RADIO = 8,
    kJS_IC_TYPE_SINGLE_SELECT_QUERY_RADIO = 9,
    kJS_IC_TYPE_MULTI_SELECT_LIST_OF_VALUES_CHECKBOX = 10,
    kJS_IC_TYPE_MULTI_SELECT_QUERY_CHECKBOX = 11
};
/** @} */

/**
 @name Provided here from DataType for facility
 @{
 */
typedef NS_ENUM(NSInteger, kJS_DT_TYPE) {
    kJS_DT_TYPE_UNKNOWN = 0,
    kJS_DT_TYPE_TEXT = 1,
    kJS_DT_TYPE_NUMBER = 2,
    kJS_DT_TYPE_DATE = 3,
    kJS_DT_TYPE_DATE_TIME = 4,
    kJS_DT_TYPE_TIME = 5
};
/** @} */

/**
 @name WebService types
 @{
 */
extern NSString *const kJS_WS_TYPE_ACCESS_GRANT_SCHEMA;
extern NSString *const kJS_WS_TYPE_ADHOC_DATA_VIEW;
extern NSString *const kJS_WS_TYPE_ADHOC_REPORT;
extern NSString *const kJS_WS_TYPE_BEAN;
extern NSString *const kJS_WS_TYPE_CONTENT_RESOURCE;
extern NSString *const kJS_WS_TYPE_CSS;
extern NSString *const kJS_WS_TYPE_CUSTOM;
extern NSString *const kJS_WS_TYPE_DATASOURCE;
extern NSString *const kJS_WS_TYPE_DATATYPE;
extern NSString *const kJS_WS_TYPE_DASHBOARD;
extern NSString *const kJS_WS_TYPE_DASHBOARD_LEGACY;
extern NSString *const kJS_WS_TYPE_DASHBOARD_STATE;
extern NSString *const kJS_WS_TYPE_DOMAIN;
extern NSString *const kJS_WS_TYPE_DOMAIN_TOPIC;
extern NSString *const kJS_WS_TYPE_FILE;
extern NSString *const kJS_WS_TYPE_FOLDER;
extern NSString *const kJS_WS_TYPE_FONT;
extern NSString *const kJS_WS_TYPE_IMG;
extern NSString *const kJS_WS_TYPE_INPUT_CONTROL;
extern NSString *const kJS_WS_TYPE_JAR;
extern NSString *const kJS_WS_TYPE_JDBC;
extern NSString *const kJS_WS_TYPE_JNDI;
extern NSString *const kJS_WS_TYPE_JRXML;
extern NSString *const kJS_WS_TYPE_LOV;
extern NSString *const kJS_WS_TYPE_OLAP_MONDRIAN_CON;
extern NSString *const kJS_WS_TYPE_OLAP_MONDRIAN_SCHEMA;
extern NSString *const kJS_WS_TYPE_OLAP_UNIT;
extern NSString *const kJS_WS_TYPE_OLAP_XMLA_CON;
extern NSString *const kJS_WS_TYPE_PROP;
extern NSString *const kJS_WS_TYPE_QUERY;
extern NSString *const kJS_WS_TYPE_REFERENCE;
extern NSString *const kJS_WS_TYPE_REPORT_OPTIONS;
extern NSString *const kJS_WS_TYPE_REPORT_UNIT;
extern NSString *const kJS_WS_TYPE_XML;
extern NSString *const kJS_WS_TYPE_XMLA_CONNECTION;
extern NSString *const kJS_WS_TYPE_UNKNOW;
/** @} */

/**
 @name Output formats
 @{
 */
extern NSString *const kJS_CONTENT_TYPE_PDF;
extern NSString *const kJS_CONTENT_TYPE_HTML;
extern NSString *const kJS_CONTENT_TYPE_XLS;
extern NSString *const kJS_CONTENT_TYPE_XLSX;
extern NSString *const kJS_CONTENT_TYPE_RTF;
extern NSString *const kJS_CONTENT_TYPE_CSV;
extern NSString *const kJS_CONTENT_TYPE_IMG;
extern NSString *const kJS_CONTENT_TYPE_ODT;
extern NSString *const kJS_CONTENT_TYPE_ODS;
extern NSString *const kJS_CONTENT_TYPE_JSON;
extern NSString *const kJS_CONTENT_TYPE_PPT;
extern NSString *const kJS_CONTENT_TYPE_PPTX;
extern NSString *const kJS_CONTENT_TYPE_DOC;
extern NSString *const kJS_CONTENT_TYPE_DOCX;

/** @} */

/**
 @name REST URI Prefixes
 @{
 */
extern NSString *const kJS_REST_AUTHENTICATION_URI;
extern NSString *const kJS_REST_SERVICES_URI;
extern NSString *const kJS_REST_SERVICES_V2_URI;
extern NSString *const kJS_REST_RESOURCE_URI;
extern NSString *const kJS_REST_RESOURCES_URI;
extern NSString *const kJS_REST_RESOURCE_THUMBNAIL_URI;
extern NSString *const kJS_REST_REPORT_URI;
extern NSString *const kJS_REST_REPORTS_URI;
extern NSString *const kJS_REST_REPORT_OPTIONS_URI;
extern NSString *const kJS_REST_INPUT_CONTROLS_URI;
extern NSString *const kJS_REST_VALUES_URI;
extern NSString *const kJS_REST_SERVER_INFO_URI;
extern NSString *const kJS_REST_REPORT_EXECUTION_URI;
extern NSString *const kJS_REST_REPORT_EXECUTION_STATUS_URI;
extern NSString *const kJS_REST_EXPORT_EXECUTION_URI;
extern NSString *const kJS_REST_EXPORT_EXECUTION_ATTACHMENTS_PREFIX_URI;
/** @} */

/**
 @name Input Control Descriptor Types
 @{
 */
extern NSString *const kJS_ICD_TYPE_BOOL;
extern NSString *const kJS_ICD_TYPE_SINGLE_VALUE_TEXT;
extern NSString *const kJS_ICD_TYPE_SINGLE_VALUE_NUMBER;
extern NSString *const kJS_ICD_TYPE_SINGLE_VALUE_DATE;
extern NSString *const kJS_ICD_TYPE_SINGLE_VALUE_TIME;
extern NSString *const kJS_ICD_TYPE_SINGLE_VALUE_DATETIME;
extern NSString *const kJS_ICD_TYPE_SINGLE_SELECT;
extern NSString *const kJS_ICD_TYPE_SINGLE_SELECT_RADIO;
extern NSString *const kJS_ICD_TYPE_MULTI_SELECT;
extern NSString *const kJS_ICD_TYPE_MULTI_SELECT_CHECKBOX;
/** @} */


/**
 @name Execution status checking
 @{
 */
extern NSTimeInterval const kJSExecutionStatusCheckingInterval;

typedef NS_ENUM(NSInteger, kJS_EXECUTION_STATUS) {
    kJS_EXECUTION_STATUS_UNKNOWN = 0,
    kJS_EXECUTION_STATUS_READY,
    kJS_EXECUTION_STATUS_QUEUED,
    kJS_EXECUTION_STATUS_EXECUTION,
    kJS_EXECUTION_STATUS_CANCELED,
    kJS_EXECUTION_STATUS_FAILED
};

/** @} */
