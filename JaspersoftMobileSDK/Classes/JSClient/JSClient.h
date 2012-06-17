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

//
//  JSClient.h
//  Jaspersoft
//
//  Created by Giulio Toffoli on 4/9/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSOperationResult.h"
#import "ASIHTTPRequestDelegate.h"
#import "JSResourceParameter.h"
#import "JSResourceProperty.h"
#import "JSConstants.h"


/** This protocol must be implemented by objects that want to call the REST services asynchronously.
 *
 */
@protocol JSResponseDelegate <NSObject>

/** This method is invoked when the request is complete. The result of the request can be checked looking at the JSOperationResult passed as parameter.
 * 
 */
-(void)requestFinished:(JSOperationResult *)op;


/** This method is invoked when the request is complete and the user requested a file (i.e. the file of a resource of a file of a generated report).
 * 
 */
@optional
-(void)fileRequestFinished:(NSString *)path contentType:(NSString *)contentType;

@end

/** A client to interact with the JasperReports Server REST API
 *  The JSClient is a convenient class to store the connection details to use the JasperReports Server REST API.
 *  The object puts at disposal a set of method search and navigate the repository, get information of resource, run reports.
 */
@interface JSClient : NSObject <ASIHTTPRequestDelegate> {
	
	//CFMutableDictionaryRef requestsAndDelegates;
	NSMutableArray *requestCallBacks;
    
    bool authenticated;
}

/** The name used to refer to this JSClient.
 *  The alias is mainly used to display the name of this JSClient in UI (i.e. when displaying a list of available servers).
 */
@property(nonatomic, retain) NSString *alias;

/** The username, must be a valid account on JasperReports Server.
 */
@property(nonatomic, retain) NSString *username;

/** The account password
 */
@property(nonatomic, retain) NSString *password;

/** The name of an organization (used in JasperReport Server Professional which supports multi-tenancy).
 *  Can be nil or empty.
 */
@property(nonatomic, retain) NSString *organization;

/** The URL of JasperReports Server. The url does not include the /rest/ portion of the uri, i.e. http://hostname:port/jasperserver
 */
@property(nonatomic, retain) NSString *baseUrl;


/** Time out for your server calls (default 15000 milliseconds)
 */
@property(nonatomic) int timeOut;

/** Creates a new JSClient with the specified alias.
 */
- (id)initWithAlias:(NSString *)theAlias Username:(NSString *)user Password:(NSString *)pass Organization:(NSString *)org Url:(NSString *)url;

/** List resources and folders available in the specified repository URI (i.e. /reports/samples/).
 *  This method is synchronous and returns a JSOperationResult. If the call is executed succesfully (i.e. the uri is valid), the property resourceDescriptors of
 *  JSOperationResult contains the list of found resources.
 */
- (JSOperationResult *)resources:(NSString *)uri;

/** List resources and folders available in the specified repository URI (i.e. /reports/samples/).
 *  This method is asynchronous. At the end of the call, the method requestFinished of the delegate is called.
 */
- (void)resources:(NSString *)uri responseDelegate:(id <JSResponseDelegate>)responseDelegate;
- (void)resources:(NSString *)uri withArguments:(NSDictionary *)args responseDelegate:(id <JSResponseDelegate>)responseDelegate;


- (JSOperationResult *)resourceInfo:(NSString *)uri;
- (void)resourceInfo:(NSString *)uri responseDelegate:(id <JSResponseDelegate>)responseDelegate;
- (void)resourceInfo:(NSString *)uri withArguments:(NSDictionary *)args responseDelegate:(id <JSResponseDelegate>)responseDelegate;

- (bool)resourceFile:(NSString *)uri andFilename: (NSString *)identifier toPath:(NSString *)path;
- (void)resourceFile:(NSString *)uri andFilename: (NSString *)identifier toPath:(NSString *)path responseDelegate:(id <JSResponseDelegate>)responseDelegate;

- (JSOperationResult *)reportRun:(NSString *)uri withParameters:(NSDictionary *)params withArguments:(NSDictionary *)args;
-(void)reportRun:(NSString *)uri withParameters:(NSDictionary *)params withArguments:(NSDictionary *)args responseDelegate:(id <JSResponseDelegate>)responseDelegate;


- (bool)reportFile:(NSString *)uuid andFilename: (NSString *)identifier toPath:(NSString *)path;
- (void)reportFile:(NSString *)uuid andFilename: (NSString *)identifier toPath:(NSString *)path responseDelegate:(id <JSResponseDelegate>)responseDelegate;


- (void)resourceCreate: (NSString *)parentFolder resourceDescriptor: (JSResourceDescriptor *)rd data: (NSData *)data responseDelegate:(id <JSResponseDelegate>)responseDelegate;

- (void)resourceModify: (NSString *)uri resourceDescriptor: (JSResourceDescriptor *)rd data: (NSData *)data responseDelegate:(id <JSResponseDelegate>)responseDelegate;

- (void)resourceDelete: (NSString *)uri responseDelegate:(id <JSResponseDelegate>)responseDelegate;

@end
