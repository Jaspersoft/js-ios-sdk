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
//  JSConstants.m
//  Jaspersoft Corporation
//

#import "JSConstants.h"
/**
 @name Error Domains
 @{
 */
NSString * const JSErrorDomain = @"JSErrorDomain";
NSString * const JSHTTPErrorDomain = @"JSHTTPErrorDomain";
NSString * const JSAuthErrorDomain = @"JSAuthErrorDomain";
/** @} */

/**
 @name JS Version Codes
 @{
 */
float const kJS_SERVER_VERSION_CODE_UNKNOWN         = 0;
float const kJS_SERVER_VERSION_CODE_EMERALD_5_5_0   = 5.5;
float const kJS_SERVER_VERSION_CODE_EMERALD_5_6_0   = 5.6;
float const kJS_SERVER_VERSION_CODE_AMBER_6_0_0     = 6.0;
float const kJS_SERVER_VERSION_CODE_AMBER_6_1_0     = 6.1;
float const kJS_SERVER_VERSION_CODE_JADE_6_2_0      = 6.2;
/** @} */

/**
 @name JS Editions
 @{
 */
NSString *const kJS_SERVER_EDITION_CE = @"CE";
NSString *const kJS_SERVER_EDITION_PRO = @"PRO";
/** @} */

/**
 @name WebService types
 @{
 */
NSString *const kJS_WS_TYPE_ACCESS_GRANT_SCHEMA = @"accessGrantSchema";
NSString *const kJS_WS_TYPE_ADHOC_DATA_VIEW = @"adhocDataView";
NSString *const kJS_WS_TYPE_ADHOC_REPORT = @"adhocReport";
NSString *const kJS_WS_TYPE_BEAN = @"bean";
NSString *const kJS_WS_TYPE_CONTENT_RESOURCE = @"contentResource";
NSString *const kJS_WS_TYPE_CSS = @"css";
NSString *const kJS_WS_TYPE_CUSTOM = @"custom";
NSString *const kJS_WS_TYPE_DATASOURCE = @"datasource";
NSString *const kJS_WS_TYPE_DATATYPE = @"dataType";
NSString *const kJS_WS_TYPE_DASHBOARD = @"dashboard";
NSString *const kJS_WS_TYPE_DASHBOARD_LEGACY = @"legacyDashboard";
NSString *const kJS_WS_TYPE_DASHBOARD_STATE = @"dashboardState";
NSString *const kJS_WS_TYPE_DOMAIN = @"domain";
NSString *const kJS_WS_TYPE_DOMAIN_TOPIC = @"domainTopic";
NSString *const kJS_WS_TYPE_FILE = @"file";
NSString *const kJS_WS_TYPE_FOLDER = @"folder";
NSString *const kJS_WS_TYPE_FONT = @"font";
NSString *const kJS_WS_TYPE_IMG = @"img";
NSString *const kJS_WS_TYPE_INPUT_CONTROL = @"inputControl";
NSString *const kJS_WS_TYPE_JAR = @"jar";
NSString *const kJS_WS_TYPE_JDBC = @"jdbc";
NSString *const kJS_WS_TYPE_JNDI = @"jndi";
NSString *const kJS_WS_TYPE_JRXML = @"jrxml";
NSString *const kJS_WS_TYPE_LOV = @"lov";
NSString *const kJS_WS_TYPE_OLAP_MONDRIAN_CON = @"olapMondrianCon";
NSString *const kJS_WS_TYPE_OLAP_MONDRIAN_SCHEMA = @"olapMondrianSchema";
NSString *const kJS_WS_TYPE_OLAP_UNIT = @"olapUnit";
NSString *const kJS_WS_TYPE_OLAP_XMLA_CON = @"olapXmlaCon";
NSString *const kJS_WS_TYPE_PROP = @"prop";
NSString *const kJS_WS_TYPE_QUERY = @"query";
NSString *const kJS_WS_TYPE_REFERENCE = @"reference";
NSString *const kJS_WS_TYPE_REPORT_OPTIONS = @"reportOptions";
NSString *const kJS_WS_TYPE_REPORT_UNIT = @"reportUnit";
NSString *const kJS_WS_TYPE_XML = @"xml";
NSString *const kJS_WS_TYPE_XMLA_CONNECTION = @"xmlaConnection";
NSString *const kJS_WS_TYPE_UNKNOW = @"unknow";
/** @} */

/**
 @name Output formats
 @{
 */
NSString *const kJS_CONTENT_TYPE_PDF = @"pdf";
NSString *const kJS_CONTENT_TYPE_HTML = @"html";
NSString *const kJS_CONTENT_TYPE_XLS = @"xls";
NSString *const kJS_CONTENT_TYPE_XLSX = @"xlsx";
NSString *const kJS_CONTENT_TYPE_RTF = @"rtf";
NSString *const kJS_CONTENT_TYPE_CSV = @"csv";
NSString *const kJS_CONTENT_TYPE_IMG = @"img";
NSString *const kJS_CONTENT_TYPE_ODT = @"odt";
NSString *const kJS_CONTENT_TYPE_ODS = @"ods";
NSString *const kJS_CONTENT_TYPE_JSON = @"json";
NSString *const kJS_CONTENT_TYPE_PPT = @"ppt";
NSString *const kJS_CONTENT_TYPE_PPTX = @"pptx";
NSString *const kJS_CONTENT_TYPE_DOC = @"doc";
NSString *const kJS_CONTENT_TYPE_DOCX = @"docx";

/** @} */

/**
 @name REST URI Prefixes
 @{
 */
NSString *const kJS_REST_ENCRYPTION_KEY_URI = @"GetEncryptionKey";
NSString *const kJS_REST_AUTHENTICATION_URI = @"j_spring_security_check";
NSString *const kJS_REST_SERVICES_URI = @"rest";
NSString *const kJS_REST_SERVICES_V2_URI = @"rest_v2";
NSString *const kJS_REST_RESOURCE_URI = @"/resource";
NSString *const kJS_REST_RESOURCES_URI = @"/resources";
NSString *const kJS_REST_RESOURCE_THUMBNAIL_URI = @"/thumbnails";
NSString *const kJS_REST_REPORT_URI = @"/report";
NSString *const kJS_REST_REPORT_OPTIONS_URI = @"/options";
NSString *const kJS_REST_REPORTS_URI = @"/reports";
NSString *const kJS_REST_INPUT_CONTROLS_URI = @"/inputControls";
NSString *const kJS_REST_VALUES_URI = @"/values";
NSString *const kJS_REST_SERVER_INFO_URI = @"/serverInfo";
NSString *const kJS_REST_REPORT_EXECUTION_URI = @"/reportExecutions";
NSString *const kJS_REST_REPORT_EXECUTION_STATUS_URI = @"/status";
NSString *const kJS_REST_EXPORT_EXECUTION_URI = @"/exports";
NSString *const kJS_REST_EXPORT_EXECUTION_ATTACHMENTS_PREFIX_URI = @"/reportExecutions/{reportExecutionId}/exports/{exportExecutionId}/attachments/";
/** @} */

/**
 @name Execution status checking
 @{
 */
NSTimeInterval const kJSExecutionStatusCheckingInterval = 1.f;
/** @} */
