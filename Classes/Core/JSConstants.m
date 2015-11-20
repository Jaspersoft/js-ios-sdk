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
#import "RKMIMETypes.h"

// Shared constants instance. This is a singleton
static JSConstants *_sharedInstance;

@implementation JSConstants

+ (nonnull JSConstants *)sharedInstance {
    @synchronized([JSConstants class]) {
		if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
        }
        
		return _sharedInstance;
	}
}

+ (instancetype)alloc {
	@synchronized([JSConstants class]) {
        return [super alloc];
	}
}

- (instancetype)init {
	if (self = [super init]) {
        // Initialize constants
        [self setWSConstants];
        [self setDTConstants];
        [self setICConstants];
        [self setGeneralPROPConstants];
        [self setFileResourcePROPConstants];
        [self setDatasourcePROPConstants];
        [self setReportUnitPROPConstants];
        [self setDataTypePROPConstants];
        [self setListOfValuesPROPConstants];
        [self setInputControlPROPConstants];
        [self setQueryPROPConstants];
        [self setOLAPPROPConstants];
        [self setContentTypeConstants];
        [self setRESTAPIPreferences];
        [self setRESTURIPrefixes];
        [self setUPVersionCodes];
        [self setUPServerEditions];
        [self setUPInputControlDescriptorTypes];
	}
    
	return self;
}

+ (nonnull NSString *)stringFromBOOL:(BOOL)aBOOL {
    return aBOOL ? @"true" : @"false";
}

+ (BOOL)BOOLFromString:(nonnull NSString *)aString {
    NSComparisonResult result = [aString caseInsensitiveCompare:@"true"];
    return (result == NSOrderedSame);
}

+ (nonnull NSString *)keychainIdentifier {
    return [NSString stringWithFormat:@"%@.GenericKeychainSuite", [NSBundle mainBundle].bundleIdentifier];
}


#pragma mark -
#pragma mark Constants initialization

- (void)setWSConstants {
    _WS_TYPE_ACCESS_GRANT_SCHEMA = @"accessGrantSchema";
    _WS_TYPE_ADHOC_DATA_VIEW = @"adhocDataView";
    _WS_TYPE_ADHOC_REPORT = @"adhocReport";
    _WS_TYPE_BEAN = @"bean";
    _WS_TYPE_CONTENT_RESOURCE = @"contentResource";
    _WS_TYPE_CSS = @"css";
    _WS_TYPE_CUSTOM = @"custom";
    _WS_TYPE_DATASOURCE = @"datasource";
    _WS_TYPE_DATATYPE = @"dataType";
    _WS_TYPE_DASHBOARD = @"dashboard";
    _WS_TYPE_DASHBOARD_LEGACY = @"legacyDashboard";
    _WS_TYPE_DASHBOARD_STATE = @"dashboardState";
    _WS_TYPE_DOMAIN = @"domain";
    _WS_TYPE_DOMAIN_TOPIC = @"domainTopic";
    _WS_TYPE_FOLDER = @"folder";
    _WS_TYPE_FONT = @"font";
    _WS_TYPE_IMG = @"img";
    _WS_TYPE_INPUT_CONTROL = @"inputControl";
    _WS_TYPE_JAR = @"jar";
    _WS_TYPE_JDBC = @"jdbc";
    _WS_TYPE_JNDI = @"jndi";
    _WS_TYPE_JRXML = @"jrxml";
    _WS_TYPE_LOV = @"lov";
    _WS_TYPE_OLAP_MONDRIAN_CON = @"olapMondrianCon";
    _WS_TYPE_OLAP_MONDRIAN_SCHEMA = @"olapMondrianSchema";
    _WS_TYPE_OLAP_UNIT = @"olapUnit";
    _WS_TYPE_OLAP_XMLA_CON = @"olapXmlaCon";
    _WS_TYPE_PROP = @"prop";
    _WS_TYPE_QUERY = @"query";
    _WS_TYPE_REFERENCE = @"reference";
    _WS_TYPE_REPORT_OPTIONS = @"reportOptions";
    _WS_TYPE_REPORT_UNIT = @"reportUnit";
    _WS_TYPE_XML = @"xml";
    _WS_TYPE_XMLA_CONNECTION = @"xmlaConnection";
    _WS_TYPE_UNKNOW = @"unknow";
}

- (void)setDTConstants {
    _DT_TYPE_TEXT = 1;
    _DT_TYPE_NUMBER = 2;
    _DT_TYPE_DATE = 3;
    _DT_TYPE_DATE_TIME = 4;
}

- (void)setICConstants {
    _IC_TYPE_BOOLEAN = 1;
    _IC_TYPE_SINGLE_VALUE = 2;
    _IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES = 3;
    _IC_TYPE_SINGLE_SELECT_QUERY = 4;
    _IC_TYPE_MULTI_VALUE = 5;
    _IC_TYPE_MULTI_SELECT_LIST_OF_VALUES = 6;
    _IC_TYPE_MULTI_SELECT_QUERY = 7;
    _IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES_RADIO = 8;
    _IC_TYPE_SINGLE_SELECT_QUERY_RADIO = 9;
    _IC_TYPE_MULTI_SELECT_LIST_OF_VALUES_CHECKBOX = 10;
    _IC_TYPE_MULTI_SELECT_QUERY_CHECKBOX = 11;
}

- (void)setGeneralPROPConstants {
    _PROP_VERSION = @"PROP_VERSION";
    _PROP_PARENT_FOLDER = @"PROP_PARENT_FOLDER";
    _PROP_RESOURCE_TYPE = @"PROP_RESOURCE_TYPE";
    _PROP_CREATION_DATE = @"PROP_CREATION_DATE";
}

- (void)setFileResourcePROPConstants {
    _PROP_FILERESOURCE_HAS_DATA = @"PROP_HAS_DATA";
    _PROP_FILERESOURCE_IS_REFERENCE = @"PROP_IS_REFERENCE";
    _PROP_FILERESOURCE_REFERENCE_URI = @"PROP_REFERENCE_URI";
    _PROP_FILERESOURCE_WSTYPE = @"PROP_WSTYPE";
    _PROP_DATA = @"PROP_DATA";
    _PROP_DATASOURCE_MAPPING = @"DATASOURCE_MAPPING";
}

- (void)setDatasourcePROPConstants {
    _PROP_DATASOURCE_DRIVER_CLASS = @"PROP_DATASOURCE_DRIVER_CLASS";
    _PROP_DATASOURCE_CONNECTION_URL = @"PROP_DATASOURCE_CONNECTION_URL";
    _PROP_DATASOURCE_USERNAME = @"PROP_DATASOURCE_USERNAME";
    _PROP_DATASOURCE_PASSWORD = @"PROP_DATASOURCE_PASSWORD";
    _PROP_DATASOURCE_JNDI_NAME = @"PROP_DATASOURCE_JNDI_NAME";
    _PROP_DATASOURCE_BEAN_NAME = @"PROP_DATASOURCE_BEAN_NAME";
    _PROP_DATASOURCE_BEAN_METHOD = @"PROP_DATASOURCE_BEAN_METHOD";
    _PROP_DATASOURCE_CUSTOM_SERVICE_CLASS = @"PROP_DATASOURCE_CUSTOM_SERVICE_CLASS";
    _PROP_DATASOURCE_CUSTOM_PROPERTY_MAP = @"PROP_DATASOURCE_CUSTOM_PROPERTY_MAP";
}

- (void)setReportUnitPROPConstants {
    _PROP_RU_DATASOURCE_TYPE = @"PROP_RU_DATASOURCE_TYPE";
    _PROP_RU_IS_MAIN_REPORT = @"PROP_RU_IS_MAIN_REPORT";
    _PROP_RU_INPUTCONTROL_RENDERING_VIEW = @"PROP_RU_INPUTCONTROL_RENDERING_VIEW";
    _PROP_RU_REPORT_RENDERING_VIEW = @"PROP_RU_REPORT_RENDERING_VIEW";
    _PROP_RU_ALWAYS_PROPMT_CONTROLS = @"PROP_RU_ALWAYS_PROPMT_CONTROLS";
    _PROP_RU_CONTROLS_LAYOUT = @"PROP_RU_CONTROLS_LAYOUT";
}

- (void)setDataTypePROPConstants {
    _PROP_DATATYPE_STRICT_MAX = @"PROP_DATATYPE_STRICT_MAX";
    _PROP_DATATYPE_STRICT_MIN = @"PROP_DATATYPE_STRICT_MIN";
    _PROP_DATATYPE_MIN_VALUE = @"PROP_DATATYPE_MIN_VALUE";
    _PROP_DATATYPE_MAX_VALUE = @"PROP_DATATYPE_MAX_VALUE";
    _PROP_DATATYPE_PATTERN = @"PROP_DATATYPE_PATTERN";
    _PROP_DATATYPE_TYPE = @"PROP_DATATYPE_TYPE";
}

- (void)setListOfValuesPROPConstants {
    _PROP_LOV = @"PROP_LOV";
    _PROP_LOV_LABEL = @"PROP_LOV_LABEL";
    _PROP_LOV_VALUE = @"PROP_LOV_VALUE";
}

- (void)setInputControlPROPConstants {
    _PROP_INPUTCONTROL_TYPE = @"PROP_INPUTCONTROL_TYPE";
    _PROP_INPUTCONTROL_IS_MANDATORY = @"PROP_INPUTCONTROL_IS_MANDATORY";
    _PROP_INPUTCONTROL_IS_READONLY = @"PROP_INPUTCONTROL_IS_READONLY";
    _PROP_INPUTCONTROL_IS_VISIBLE = @"PROP_INPUTCONTROL_IS_VISIBLE";
}

- (void)setQueryPROPConstants {
    _PROP_QUERY = @"PROP_QUERY";
    _PROP_QUERY_DATA = @"PROP_QUERY_DATA";
    _PROP_QUERY_DATA_ROW = @"PROP_QUERY_DATA_ROW";
    _PROP_QUERY_DATA_ROW_COLUMN = @"PROP_QUERY_DATA_ROW_COLUMN";
    _PROP_QUERY_VISIBLE_COLUMNS = @"PROP_QUERY_VISIBLE_COLUMNS";
    _PROP_QUERY_VISIBLE_COLUMN_NAME = @"PROP_QUERY_VISIBLE_COLUMN_NAME";
    _PROP_QUERY_VALUE_COLUMN = @"PROP_QUERY_VALUE_COLUMN";
    _PROP_QUERY_LANGUAGE = @"PROP_QUERY_LANGUAGE";
}

- (void)setOLAPPROPConstants {
    _PROP_XMLA_URI = @"PROP_XMLA_URI";
    _PROP_XMLA_CATALOG = @"PROP_XMLA_CATALOG";
    _PROP_XMLA_DATASOURCE = @"PROP_XMLA_DATASOURCE";
    _PROP_XMLA_USERNAME = @"PROP_XMLA_USERNAME";
    _PROP_XMLA_PASSWORD = @"PROP_XMLA_PASSWORD";
    _PROP_MDX_QUERY = @"PROP_MDX_QUERY";
}

- (void)setContentTypeConstants {
    _CONTENT_TYPE_PDF = @"pdf";
    _CONTENT_TYPE_HTML = @"html";
    _CONTENT_TYPE_XLS = @"xls";
    _CONTENT_TYPE_RTF = @"rtf";
    _CONTENT_TYPE_CSV = @"csv";
    _CONTENT_TYPE_IMG = @"img";
}

- (void)setRESTAPIPreferences {
    _REST_SDK_MIMETYPE_USED = RKMIMETypeJSON;
    _REST_JRS_LOCALE_SUPPORTED = @{@"en" : @"en_US",
                                  @"de" : @"de",
                                  @"ja" : @"ja",
                                  @"es" : @"es",
                                  @"fr" : @"fr",
                                  @"it" : @"it",
                                  @"zh" : @"zh_CN",
                                  @"pt" : @"pt_BR"};
    
    _REST_JRS_CONNECTION_TIMEOUT = 7;
}

- (void)setRESTURIPrefixes {
    _REST_AUTHENTICATION_URI = @"j_spring_security_check";
    _REST_SERVICES_URI = @"rest";
    _REST_SERVICES_V2_URI = @"rest_v2";
    _REST_RESOURCE_URI = @"/resource";
    _REST_RESOURCES_URI = @"/resources";
    _REST_RESOURCE_THUMBNAIL_URI = @"/thumbnails";
    _REST_REPORT_URI = @"/report";
    _REST_REPORT_OPTIONS_URI = @"/options";
    _REST_REPORTS_URI = @"/reports";
    _REST_INPUT_CONTROLS_URI = @"/inputControls";
    _REST_VALUES_URI = @"/values";
    _REST_SERVER_INFO_URI = @"/serverInfo";
    _REST_REPORT_EXECUTION_URI = @"/reportExecutions";
    _REST_REPORT_EXECUTION_STATUS_URI = @"/status";
    _REST_EXPORT_EXECUTION_URI = @"/exports";
    _REST_EXPORT_EXECUTION_ATTACHMENTS_PREFIX_URI = @"/reportExecutions/{reportExecutionId}/exports/{exportExecutionId}/attachments/";
}

- (void)setUPVersionCodes {
    _SERVER_VERSION_CODE_UNKNOWN = 0;
    _SERVER_VERSION_CODE_EMERALD_5_0_0 = 5.0;
    _SERVER_VERSION_CODE_EMERALD_5_2_0 = 5.2;
    _SERVER_VERSION_CODE_EMERALD_5_5_0 = 5.5;
    _SERVER_VERSION_CODE_EMERALD_5_6_0 = 5.6;
    _SERVER_VERSION_CODE_AMBER_6_0_0 = 6.0;
    _SERVER_VERSION_CODE_AMBER_6_1_0 = 6.1;
}

- (void)setUPServerEditions {
    _SERVER_EDITION_CE = @"CE";
    _SERVER_EDITION_PRO = @"PRO";
}

- (void)setUPInputControlDescriptorTypes {
    _ICD_TYPE_BOOL = @"bool";
    _ICD_TYPE_SINGLE_VALUE_TEXT = @"singleValueText";
    _ICD_TYPE_SINGLE_VALUE_NUMBER = @"singleValueNumber";
    _ICD_TYPE_SINGLE_VALUE_DATE = @"singleValueDate";
    _ICD_TYPE_SINGLE_VALUE_TIME = @"singleValueTime";
    _ICD_TYPE_SINGLE_VALUE_DATETIME = @"singleValueDatetime";
    _ICD_TYPE_SINGLE_SELECT = @"singleSelect";
    _ICD_TYPE_SINGLE_SELECT_RADIO = @"singleSelectRadio";
    _ICD_TYPE_MULTI_SELECT = @"multiSelect";
    _ICD_TYPE_MULTI_SELECT_CHECKBOX = @"multiSelectCheckbox";
}

@end
