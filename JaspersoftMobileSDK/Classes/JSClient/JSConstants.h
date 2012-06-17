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


// Types of resources
#define JS_TYPE_FOLDER                   @"folder"
#define JS_TYPE_REPORTUNIT               @"reportUnit"
#define JS_TYPE_REPORTOPTIONS            @"ReportOptionsResource"
#define JS_TYPE_DATASOURCE               @"datasource"
#define JS_TYPE_DATASOURCE_JDBC          @"jdbc"
#define JS_TYPE_DATASOURCE_JNDI          @"jndi"
#define JS_TYPE_DATASOURCE_BEAN          @"bean"
#define JS_TYPE_DATASOURCE_CUSTOM        @"custom"
#define JS_TYPE_IMAGE                    @"img"
#define JS_TYPE_FONT                     @"font"
#define JS_TYPE_JRXML                    @"jrxml"
#define JS_TYPE_CLASS_JAR                @"jar"
#define JS_TYPE_RESOURCE_BUNDLE          @"prop"
#define JS_TYPE_REFERENCE                @"reference"
#define JS_TYPE_INPUT_CONTROL            @"inputControl"
#define JS_TYPE_DATA_TYPE                @"dataType"
#define JS_TYPE_OLAP_MONDRIAN_CONNECTION @"olapMondrianCon"
#define JS_TYPE_OLAP_XMLA_CONNECTION     @"olapXmlaCon"
#define JS_TYPE_MONDRIAN_SCHEMA          @"olapMondrianSchema"
#define JS_TYPE_ACCESS_GRANT_SCHEMA      @"accessGrantSchema"
#define JS_TYPE_UNKNOW                   @"unknow"
#define JS_TYPE_LOV                      @"lov"
#define JS_TYPE_QUERY                    @"query"
#define JS_TYPE_CONTENT_RESOURCE         @"contentResource"
#define JS_TYPE_STYLE_TEMPLATE           @"jrtx"
#define JS_TYPE_XML_FILE                 @"xml"
#define JS_TYPE_PDF                      @"pdf"
#define JS_TYPE_HTML                     @"html"
#define JS_TYPE_CSS                      @"css"

// Datatypes
#define JS_DT_TYPE_TEXT      @"1"
#define JS_DT_TYPE_NUMBER    @"2"
#define JS_DT_TYPE_DATE      @"3"
#define JS_DT_TYPE_DATE_TIME @"4"    

// Types of input controls
#define JS_IC_TYPE_BOOLEAN                              @"1"
#define JS_IC_TYPE_SINGLE_VALUE                         @"2"
#define JS_IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES         @"3"
#define JS_IC_TYPE_SINGLE_SELECT_QUERY                  @"4"
#define JS_IC_TYPE_MULTI_VALUE                          @"5"
#define JS_IC_TYPE_MULTI_SELECT_LIST_OF_VALUES          @"6"
#define JS_IC_TYPE_MULTI_SELECT_QUERY                   @"7"
#define JS_IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES_RADIO   @"8"
#define JS_IC_TYPE_SINGLE_SELECT_QUERY_RADIO            @"9"
#define JS_IC_TYPE_MULTI_SELECT_LIST_OF_VALUES_CHECKBOX @"10"
#define JS_IC_TYPE_MULTI_SELECT_QUERY_CHECKBOX          @"11"

// Resource properties
#define JS_PROP_VERSION                         @"PROP_VERSION"
#define JS_PROP_PARENT_FOLDER                   @"PROP_PARENT_FOLDER"
#define JS_PROP_RESOURCE_TYPE                   @"PROP_RESOURCE_TYPE"
#define JS_PROP_CREATION_DATE                   @"PROP_CREATION_DATE"
#define JS_PROP_FILERESOURCE_HAS_DATA           @"PROP_HAS_DATA"
#define JS_PROP_FILERESOURCE_IS_REFERENCE       @"PROP_IS_REFERENCE"
#define JS_PROP_FILERESOURCE_REFERENCE_URI      @"PROP_REFERENCE_URI"
#define JS_PROP_FILERESOURCE_WSTYPE             @"PROP_WSTYPE"
#define JS_PROP_IS_REFERENCE       @"PROP_IS_REFERENCE"
#define JS_PROP_REFERENCE_URI      @"PROP_REFERENCE_URI"
#define JS_PROP_DATASOURCE_DRIVER_CLASS         @"PROP_DATASOURCE_DRIVER_CLASS"
#define JS_PROP_DATASOURCE_CONNECTION_URL       @"PROP_DATASOURCE_CONNECTION_URL"
#define JS_PROP_DATASOURCE_USERNAME             @"PROP_DATASOURCE_USERNAME"
#define JS_PROP_DATASOURCE_PASSWORD             @"PROP_DATASOURCE_PASSWORD"
#define JS_PROP_DATASOURCE_JNDI_NAME            @"PROP_DATASOURCE_JNDI_NAME"
#define JS_PROP_DATASOURCE_BEAN_NAME            @"PROP_DATASOURCE_BEAN_NAME"
#define JS_PROP_DATASOURCE_BEAN_METHOD          @"PROP_DATASOURCE_BEAN_METHOD"
#define JS_PROP_DATASOURCE_CUSTOM_SERVICE_CLASS @"PROP_DATASOURCE_CUSTOM_SERVICE_CLASS"
#define JS_PROP_DATASOURCE_CUSTOM_PROPERTY_MAP  @"PROP_DATASOURCE_CUSTOM_PROPERTY_MAP"
#define JS_PROP_RU_DATASOURCE_TYPE              @"PROP_RU_DATASOURCE_TYPE"
#define JS_PROP_RU_IS_MAIN_REPORT               @"PROP_RU_IS_MAIN_REPORT"
#define JS_PROP_RU_INPUTCONTROL_RENDERING_VIEW  @"PROP_RU_INPUTCONTROL_RENDERING_VIEW"
#define JS_PROP_RU_REPORT_RENDERING_VIEW        @"PROP_RU_REPORT_RENDERING_VIEW"
#define JS_PROP_RU_ALWAYS_PROPMT_CONTROLS       @"PROP_RU_ALWAYS_PROPMT_CONTROLS"
#define JS_PROP_RU_CONTROLS_LAYOUT              @"PROP_RU_CONTROLS_LAYOUT"
#define JS_PROP_DATATYPE_STRICT_MAX             @"PROP_DATATYPE_STRICT_MAX"
#define JS_PROP_DATATYPE_STRICT_MIN             @"PROP_DATATYPE_STRICT_MIN"
#define JS_PROP_DATATYPE_MIN_VALUE              @"PROP_DATATYPE_MIN_VALUE"
#define JS_PROP_DATATYPE_MAX_VALUE              @"PROP_DATATYPE_MAX_VALUE"
#define JS_PROP_DATATYPE_PATTERN                @"PROP_DATATYPE_PATTERN"
#define JS_PROP_DATATYPE_TYPE                   @"PROP_DATATYPE_TYPE"
#define JS_PROP_LOV                             @"PROP_LOV"
#define JS_PROP_LOV_LABEL                       @"PROP_LOV_LABEL"
#define JS_PROP_LOV_VALUE                       @"PROP_LOV_VALUE"
#define JS_PROP_INPUTCONTROL_TYPE               @"PROP_INPUTCONTROL_TYPE"
#define JS_PROP_INPUTCONTROL_IS_MANDATORY       @"PROP_INPUTCONTROL_IS_MANDATORY"
#define JS_PROP_INPUTCONTROL_IS_READONLY        @"PROP_INPUTCONTROL_IS_READONLY"
#define JS_PROP_INPUTCONTROL_IS_VISIBLE         @"PROP_INPUTCONTROL_IS_VISIBLE"
#define JS_PROP_QUERY                           @"PROP_QUERY"
#define JS_PROP_QUERY_VISIBLE_COLUMNS           @"PROP_QUERY_VISIBLE_COLUMNS"
#define JS_PROP_QUERY_VISIBLE_COLUMN_NAME       @"PROP_QUERY_VISIBLE_COLUMN_NAME"
#define JS_PROP_QUERY_VALUE_COLUMN              @"PROP_QUERY_VALUE_COLUMN"
#define JS_PROP_QUERY_LANGUAGE                  @"PROP_QUERY_LANGUAGE"
#define JS_PROP_QUERY_DATA                      @"PROP_QUERY_DATA"
#define JS_PROP_QUERY_DATA_ROW                  @"PROP_QUERY_DATA_ROW"
#define JS_PROP_QUERY_DATA_ROW_COLUMN           @"PROP_QUERY_DATA_ROW_COLUMN"
#define JS_PROP_XMLA_URI                        @"PROP_XMLA_URI"
#define JS_PROP_XMLA_CATALOG                    @"PROP_XMLA_CATALOG"
#define JS_PROP_XMLA_DATASOURCE                 @"PROP_XMLA_DATASOURCE"
#define JS_PROP_XMLA_USERNAME                   @"PROP_XMLA_USERNAME"
#define JS_PROP_XMLA_PASSWORD                   @"PROP_XMLA_PASSWORD"
#define JS_PROP_CONTENT_RESOURCE_TYPE           @"CONTENT_TYPE"
#define JS_PROP_DATA_ATTACHMENT_ID              @"DATA_ATTACHMENT_ID"

// Type of ReportUnit layouts (for web presentation of input controls in JasperReports Server)
#define JS_RU_CONTROLS_LAYOUT_POPUP_SCREEN     @"1"
#define JS_RU_CONTROLS_LAYOUT_SEPARATE_PAGE    @"2"
#define JS_RU_CONTROLS_LAYOUT_TOP_OF_PAGE      @"3"
#define JS_RU_CONTROLS_LAYOUT_TOP_OF_PAGE_NEW  @"4"

// Output formats
#define JS_CONTENT_TYPE_PDF   @"pdf"
#define JS_CONTENT_TYPE_HTML  @"html"
#define JS_CONTENT_TYPE_XLS   @"xls"
#define JS_CONTENT_TYPE_RTF   @"rtf"
#define JS_CONTENT_TYPE_CSV   @"csv"
#define JS_CONTENT_TYPE_IMAGE @"img"

// C style strings to parse XML
#define JS_XML_RESOURCE_DESCRIPTOR (xmlChar *)"resourceDescriptor"
#define JS_XML_OPERATION_RESULT    (xmlChar *)"operationResult"
#define JS_XML_RESOURCE_PROPERTY   (xmlChar *)"resourceProperty"
#define JS_XML_NAME                (xmlChar *)"name"
#define JS_XML_VALUE               (xmlChar *)"value"
#define JS_XML_DESCRIPTION         (xmlChar *)"description"
#define JS_XML_LABEL               (xmlChar *)"label"
#define JS_XML_WSTYPE              (xmlChar *)"wsType"
#define JS_XML_URI_STRING          (xmlChar *)"uriString"
#define JS_XML_RESOURCE_PARAMETER  (xmlChar *)"parameter"

// NSString string to create XML
#define JS_NSXML_RESOURCE_DESCRIPTOR @"resourceDescriptor"
#define JS_NSXML_OPERATION_RESULT    @"operationResult"
#define JS_NSXML_RESOURCE_PROPERTY   @"resourceProperty"
#define JS_NSXML_NAME                @"name"
#define JS_NSXML_VALUE               @"value"
#define JS_NSXML_DESCRIPTION         @"description"
#define JS_NSXML_LABEL               @"label"
#define JS_NSXML_WSTYPE              @"wsType"
#define JS_NSXML_URI_STRING          @"uriString"
#define JS_NSXML_RESOURCE_PARAMETER  @"parameter"

// Report Execution xml tags and attributes
#define JS_XML_RE_REPORT          (xmlChar *)"report"
#define JS_XML_RE_FILE            (xmlChar *)"file"
#define JS_XML_RE_TYPE            (xmlChar *)"type"
