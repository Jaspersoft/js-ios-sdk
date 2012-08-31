//
//  JSConstants.h
//  RestKitDemo
//
//  Created by Vlad Zavadskyi on 07.08.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides helping constants for different types of resources and API parts
 
 @author Vlad Zavadskyi vzavadskii@jaspersoft.com
 @since 1.0
 */
@interface JSConstants : NSObject

/**
 Returns the shared instance of the constants
 */
+ (JSConstants *)sharedInstance;

/**
 Get string representation for Boolean value
 
 @param aBool A Boolean value
 @return A new string @"true" or @"false" depends on provided Boolean value
 */
- (NSString *)stringFromBOOL:(BOOL)aBOOL;

/**
 @name WebService types
 @{
 */
@property (nonatomic, readonly) NSString *WS_TYPE_ACCESS_GRANT_SCHEMA;
@property (nonatomic, readonly) NSString *WS_TYPE_ADHOC_DATA_VIEW;
@property (nonatomic, readonly) NSString *WS_TYPE_ADHOC_REPORT;
@property (nonatomic, readonly) NSString *WS_TYPE_BEAN;
@property (nonatomic, readonly) NSString *WS_TYPE_CONTENT_RESOURCE;
@property (nonatomic, readonly) NSString *WS_TYPE_CSS;
@property (nonatomic, readonly) NSString *WS_TYPE_CUSTOM;
@property (nonatomic, readonly) NSString *WS_TYPE_DATASOURCE;
@property (nonatomic, readonly) NSString *WS_TYPE_DASHBOARD_STATE;
@property (nonatomic, readonly) NSString *WS_TYPE_DOMAIN;
@property (nonatomic, readonly) NSString *WS_TYPE_DOMAIN_TOPIC;
@property (nonatomic, readonly) NSString *WS_TYPE_FOLDER;
@property (nonatomic, readonly) NSString *WS_TYPE_FONT;
@property (nonatomic, readonly) NSString *WS_TYPE_IMG;
@property (nonatomic, readonly) NSString *WS_TYPE_INPUT_CONTROL;
@property (nonatomic, readonly) NSString *WS_TYPE_JAR;
@property (nonatomic, readonly) NSString *WS_TYPE_JDBC;
@property (nonatomic, readonly) NSString *WS_TYPE_JNDI;
@property (nonatomic, readonly) NSString *WS_TYPE_JRXML;
@property (nonatomic, readonly) NSString *WS_TYPE_LOV;
@property (nonatomic, readonly) NSString *WS_TYPE_OLAP_MONDRIAN_CON;
@property (nonatomic, readonly) NSString *WS_TYPE_OLAP_MONDRIAN_SCHEMA;
@property (nonatomic, readonly) NSString *WS_TYPE_OLAP_UNIT;
@property (nonatomic, readonly) NSString *WS_TYPE_OLAP_XMLA_CON;
@property (nonatomic, readonly) NSString *WS_TYPE_PROP;
@property (nonatomic, readonly) NSString *WS_TYPE_QUERY;
@property (nonatomic, readonly) NSString *WS_TYPE_REFERENCE;
@property (nonatomic, readonly) NSString *WS_TYPE_REPORT_OPTIONS;
@property (nonatomic, readonly) NSString *WS_TYPE_REPORT_UNIT;
@property (nonatomic, readonly) NSString *WS_TYPE_XML;
@property (nonatomic, readonly) NSString *WS_TYPE_XMLA_CONNECTION;
@property (nonatomic, readonly) NSString *WS_TYPE_UNKNOW;
/** @} */

/**
 @name Provided here from DataType for facility
 @{
 */
@property (nonatomic, readonly) NSInteger DT_TYPE_TEXT;
@property (nonatomic, readonly) NSInteger DT_TYPE_NUMBER;
@property (nonatomic, readonly) NSInteger DT_TYPE_DATE;
@property (nonatomic, readonly) NSInteger DT_TYPE_DATE_TIME;
/** @} */

/**
 @name Provided here from InputControl for facility
 @{
 */
@property (nonatomic, readonly) NSInteger IC_TYPE_BOOLEAN;
@property (nonatomic, readonly) NSInteger IC_TYPE_SINGLE_VALUE;
@property (nonatomic, readonly) NSInteger IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES;
@property (nonatomic, readonly) NSInteger IC_TYPE_SINGLE_SELECT_QUERY;
@property (nonatomic, readonly) NSInteger IC_TYPE_MULTI_VALUE;
@property (nonatomic, readonly) NSInteger IC_TYPE_MULTI_SELECT_LIST_OF_VALUES;
@property (nonatomic, readonly) NSInteger IC_TYPE_MULTI_SELECT_QUERY;
@property (nonatomic, readonly) NSInteger IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES_RADIO;
@property (nonatomic, readonly) NSInteger IC_TYPE_SINGLE_SELECT_QUERY_RADIO;
@property (nonatomic, readonly) NSInteger IC_TYPE_MULTI_SELECT_LIST_OF_VALUES_CHECKBOX;
@property (nonatomic, readonly) NSInteger IC_TYPE_MULTI_SELECT_QUERY_CHECKBOX;
/** @} */

/**
 @name General constants for resource properties
 @{
 */
@property (nonatomic, readonly) NSString *PROP_VERSION;
@property (nonatomic, readonly) NSString *PROP_PARENT_FOLDER;
@property (nonatomic, readonly) NSString *PROP_RESOURCE_TYPE;
@property (nonatomic, readonly) NSString *PROP_CREATION_DATE;
/** @} */

/**
 @name File resource properties
 @{
 */
@property (nonatomic, readonly) NSString *PROP_FILERESOURCE_HAS_DATA;
@property (nonatomic, readonly) NSString *PROP_FILERESOURCE_IS_REFERENCE;
@property (nonatomic, readonly) NSString *PROP_FILERESOURCE_REFERENCE_URI;
@property (nonatomic, readonly) NSString *PROP_FILERESOURCE_WSTYPE;
@property (nonatomic, readonly) NSString *PROP_DATA;
@property (nonatomic, readonly) NSString *PROP_DATASOURCE_MAPPING;
/** @} */

/**
 @name Datasource properties
 @{
 */
@property (nonatomic, readonly) NSString *PROP_DATASOURCE_DRIVER_CLASS;
@property (nonatomic, readonly) NSString *PROP_DATASOURCE_CONNECTION_URL;
@property (nonatomic, readonly) NSString *PROP_DATASOURCE_USERNAME;
@property (nonatomic, readonly) NSString *PROP_DATASOURCE_PASSWORD;
@property (nonatomic, readonly) NSString *PROP_DATASOURCE_JNDI_NAME;
@property (nonatomic, readonly) NSString *PROP_DATASOURCE_BEAN_NAME;
@property (nonatomic, readonly) NSString *PROP_DATASOURCE_BEAN_METHOD;
@property (nonatomic, readonly) NSString *PROP_DATASOURCE_CUSTOM_SERVICE_CLASS;
@property (nonatomic, readonly) NSString *PROP_DATASOURCE_CUSTOM_PROPERTY_MAP;
/** @} */

/**
 @name ReportUnit resource properties
 @{
 */
@property (nonatomic, readonly) NSString *PROP_RU_DATASOURCE_TYPE;
@property (nonatomic, readonly) NSString *PROP_RU_IS_MAIN_REPORT;
@property (nonatomic, readonly) NSString *PROP_RU_INPUTCONTROL_RENDERING_VIEW;
@property (nonatomic, readonly) NSString *PROP_RU_REPORT_RENDERING_VIEW;
@property (nonatomic, readonly) NSString *PROP_RU_ALWAYS_PROPMT_CONTROLS;
@property (nonatomic, readonly) NSString *PROP_RU_CONTROLS_LAYOUT;
/** @} */

/**
 @name DataType resource properties
 @{
 */
@property (nonatomic, readonly) NSString *PROP_DATATYPE_STRICT_MAX;
@property (nonatomic, readonly) NSString *PROP_DATATYPE_STRICT_MIN;
@property (nonatomic, readonly) NSString *PROP_DATATYPE_MIN_VALUE;
@property (nonatomic, readonly) NSString *PROP_DATATYPE_MAX_VALUE;
@property (nonatomic, readonly) NSString *PROP_DATATYPE_PATTERN;
@property (nonatomic, readonly) NSString *PROP_DATATYPE_TYPE;
/** @} */

/**
 @name ListOfValues resource properties
 @{
 */
@property (nonatomic, readonly) NSString *PROP_LOV;
@property (nonatomic, readonly) NSString *PROP_LOV_LABEL;
@property (nonatomic, readonly) NSString *PROP_LOV_VALUE;
/** @} */

/**
 @name InputControl resource properties
 @{
 */
@property (nonatomic, readonly) NSString *PROP_INPUTCONTROL_TYPE;
@property (nonatomic, readonly) NSString *PROP_INPUTCONTROL_IS_MANDATORY;
@property (nonatomic, readonly) NSString *PROP_INPUTCONTROL_IS_READONLY;
@property (nonatomic, readonly) NSString *PROP_INPUTCONTROL_IS_VISIBLE;
/** @} */

/**
 @name SQL resource properties
 @{
 */
@property (nonatomic, readonly) NSString *PROP_QUERY;
@property (nonatomic, readonly) NSString *PROP_QUERY_VISIBLE_COLUMNS;
@property (nonatomic, readonly) NSString *PROP_QUERY_VISIBLE_COLUMN_NAME;
@property (nonatomic, readonly) NSString *PROP_QUERY_VALUE_COLUMN;
@property (nonatomic, readonly) NSString *PROP_QUERY_LANGUAGE;
/** @} */

/**
 @name SQL resource properties
 @{
 */
@property (nonatomic, readonly) NSString *PROP_QUERY_DATA;
@property (nonatomic, readonly) NSString *PROP_QUERY_DATA_ROW;
@property (nonatomic, readonly) NSString *PROP_QUERY_DATA_ROW_COLUMN;
/** @} */

/**
 @name OLAP XMLA Connection
 @{
 */
@property (nonatomic, readonly) NSString *PROP_XMLA_URI;
@property (nonatomic, readonly) NSString *PROP_XMLA_CATALOG;
@property (nonatomic, readonly) NSString *PROP_XMLA_DATASOURCE;
@property (nonatomic, readonly) NSString *PROP_XMLA_USERNAME;
@property (nonatomic, readonly) NSString *PROP_XMLA_PASSWORD;
/** @} */

/**
 @name OLAP Unit
 @{
 */
@property (nonatomic, readonly) NSString *PROP_MDX_QUERY;
/** @} */

/**
 @name Output formats
 @{
 */
@property (nonatomic, readonly) NSString *CONTENT_TYPE_PDF;
@property (nonatomic, readonly) NSString *CONTENT_TYPE_HTML;
@property (nonatomic, readonly) NSString *CONTENT_TYPE_XLS;
@property (nonatomic, readonly) NSString *CONTENT_TYPE_RTF;
@property (nonatomic, readonly) NSString *CONTENT_TYPE_CSV;
@property (nonatomic, readonly) NSString *CONTENT_TYPE_IMG;
/** @} */

@end
