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
//  JSClient.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 4/9/11.
//  Modified by Vlad Zavadskii on 7/27/12.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSClient.h"
#import "JSXMLUtils.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define REQUEST_RESOURCES 1
#define REQUEST_RESOURCE 2
#define REQUEST_RESOURCE_FILE 3
#define REQUEST_REPORT 4
#define REQUEST_REPORT_FILE 5
#define REQUEST_EMPTY 6

#define REQUEST_FINISHED 100
#define FILE_REQUEST_FINISHED 200


@interface JSCallBack : NSObject {
}
@property(nonatomic, retain) ASIHTTPRequest *request;
@property(nonatomic, retain) id <JSResponseDelegate> delegate;
@property(nonatomic) int callBackType;
@end

@implementation JSCallBack : NSObject
{
	
}
@synthesize request;
@synthesize delegate;
@synthesize callBackType;

-(void)dealloc
{
    [request release];
    [delegate release];
	[super dealloc];
}
@end

@interface JSClient (PrivateXML)

/** Parse the response of the resources REST call which contains a set of ResourceDescrioptors inside a resourceDescriptors element
 */
-(JSOperationResult *)parseResourcesResponse:(ASIHTTPRequest *)request;

/** Parse the response of the resource REST call which contains a single ResourceDescrioptor
 */
-(JSOperationResult *)parseResourceResponse:(ASIHTTPRequest *)request;

/** Parse the response of the report execution (report PUT) REST call which contains an XML describing the report execution
 */
-(JSOperationResult *)parseReportRunResponse:(ASIHTTPRequest *)request;

-(JSOperationResult *)parseResponse:(NSString *)response;
-(NSMutableArray *)parseResourceDescriptors:(xmlNode *)node;
-(JSResourceDescriptor *)parseResourceDescriptor:(xmlNode *)node;
-(JSResourceProperty *)parseResourceProperty:(xmlNode *)node;

-(NSString *)resourcePropertyToXml:(JSResourceProperty *)rp;
-(NSString *)resourceParameterToXml:(JSResourceParameter *)rp;
-(NSString *)resourceDescriptorToXml:(JSResourceDescriptor *)rp;


@end

@implementation JSClient

@synthesize  jsServerProfile;
@synthesize  timeOutsForMethods;
@synthesize  timeOut;

// Clears ASIHTTRequest session. This prvents caching of authentication credentials
+(void)clearSession {
    [ASIHTTPRequest clearSession];
}

// The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)init {
	
	if(self = [super init]) {
		requestCallBacks = [[NSMutableArray alloc] initWithCapacity:0];
        authenticated = FALSE;
        timeOut = 15;
        timeOutsForMethods = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return self;
}

// The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithJSServerProfile:(JSServerProfile *)theJSServerProfile {
    
	if( (self=[self init]) ) {
        [self setJsServerProfile:theJSServerProfile];
	}
	
	return self;
}

-(void)dealloc {
	[requestCallBacks release];
	requestCallBacks = nil;
    [jsServerProfile release];
    jsServerProfile = nil;
    [timeOutsForMethods release];
    timeOutsForMethods = nil;
	[super dealloc];
}


    
// Coming from the protocol ASIHTTPRequestDelegate
- (void)requestHasFinished:(ASIHTTPRequest *)request withError: (NSError *)error;
{
    authenticated = true;
    
    NSLog(@"Finished request %@", [request url]);
    
    // Use when fetching text data
	// if (requestsAndDelegates == nil) return;
	
	// Look for the request
	JSCallBack *myCallBack = nil;
	
	if (requestCallBacks == nil) return;
	
	for (int i=0; i<[requestCallBacks count]; ++i)
	{
		myCallBack = [requestCallBacks objectAtIndex:i];
		if ([myCallBack request] == request)
		{
			[myCallBack retain];
			[requestCallBacks removeObjectAtIndex:i];
			break;
		}
		else {
			myCallBack = nil;
		}
	}
	
	//JSCallBack *myCallBack = (JSCallBack *)CFDictionaryGetValue( requestsAndDelegates, request);
	
	if (myCallBack == nil) 
	{
		return;
	}

	// Remove the key...
	//CFDictionaryRemoveValue (requestsAndDelegates,request);

	if (myCallBack == nil) return;
	
	id <JSResponseDelegate> myDelegate = [myCallBack delegate];
	
	int cbType = [myCallBack callBackType];


	switch (cbType)
	{
        case REQUEST_RESOURCES:
        {
            JSOperationResult *res = [self parseResourcesResponse: request];
            if (myDelegate != nil && [myDelegate respondsToSelector:@selector(requestFinished:)])
			{
                if (res == nil)
                {
                    NSLog(@"Status: %d", [request responseStatusCode]);
                }
				[myDelegate requestFinished:res];
			}
            break;
        }
        case REQUEST_RESOURCE:
        {
            JSOperationResult *res = [self parseResourceResponse: request];
            
            if (myDelegate != nil && [myDelegate respondsToSelector:@selector(requestFinished:)])
			{
				[myDelegate requestFinished:res];
			}
            break;
        }
        case REQUEST_REPORT:
        {
            JSOperationResult *res = [self parseReportRunResponse: request];
            
            if (myDelegate != nil && [myDelegate respondsToSelector:@selector(requestFinished:)])
			{
                if (res == nil)
                {
                    NSLog(@"Url: %@", [request url]);
                    NSLog(@"Is complete?: %d", [request complete]);
                    NSLog(@"Error: %@", [request error]);
                    NSLog(@"Status: %d", [request responseStatusCode]);
                }
                
				[myDelegate requestFinished:res];
			}
            break;
        }
        case REQUEST_EMPTY:
        {
            JSOperationResult *res = [JSOperationResult operationResultWithReturnCode:[request responseStatusCode] message: [request responseString]];

            if (myDelegate != nil && [myDelegate respondsToSelector:@selector(requestFinished:)])
			{
                [myDelegate requestFinished:res];
			}
            break;
        }
		case REQUEST_FINISHED:
		{
			JSOperationResult *res = nil;
			NSError *error = [request error];
			if (!error) {
				NSString *response = [request responseString];
				res = [self parseResponse:response];
			}
			
			if (myDelegate != nil && [myDelegate respondsToSelector:@selector(requestFinished:)])
			{
				[myDelegate requestFinished:res];
			}
			else {
				NSLog(@"Delegate %@ null, or requestFinished not implemented!", myDelegate);
			}
			break;
		}
		case REQUEST_REPORT_FILE:
        case REQUEST_RESOURCE_FILE:
        {
            
            NSString *contentType = [[request responseHeaders] objectForKey:@"Content-Type"];
			[myDelegate fileRequestFinished:[request downloadDestinationPath] contentType: contentType ];
			break;
        }
	}
	
	[request release];
	[myCallBack release];
	
	// Use when fetching binary data
	//NSData *responseData = [request responseData];
}


// Coming from the protocol ASIHTTPRequestDelegate
- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self requestHasFinished:request withError: [request error]];
}


// Coming from the protocol ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self requestHasFinished:request withError: nil];
}

/*******************************************
 
 List or search for resources Synchronous version
 
********************************************/
- (JSOperationResult *)resources:(NSString *)uri {
	
    if ([uri isEqualToString:@""])
    {
       //uri = @"/";
    }
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/rest/resources%@", [jsServerProfile baseUrl], uri]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];  
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"resources"] ?: self.timeOut];
    if (!authenticated) 
    {
        [request setShouldPresentCredentialsBeforeChallenge: NO];
    }
	[request startSynchronous];
	
    return [self parseResourcesResponse: request];
}


-(JSOperationResult *)parseResourcesResponse:(ASIHTTPRequest *)request
{
    JSOperationResult *operationResult = nil;
    operationResult = [JSOperationResult operationResultWithReturnCode:[request responseStatusCode] message:[request responseStatusMessage]];
    
    if (![request error])
    {
        // parse the xml...
        xmlDocPtr doc;

        /* Load XML document */
        NSString *responseString = [request responseString]; 
        doc = xmlParseMemory([responseString UTF8String], [responseString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
            
        if (doc == NULL)
        {
           NSLog(@"Unable to parse.");
           NSLog(@"%@",responseString);
           [operationResult setReturnCode: [request responseStatusCode]];
           [operationResult setMessage:@"Invalid response"];
        }
        else
        {
            xmlNode *rootNode = xmlDocGetRootElement(doc);
          
            // Parse the resource descriptors children  of the root....
            NSMutableArray *descriptors = [self parseResourceDescriptors: rootNode->children ];
            [operationResult setResourceDescriptors:descriptors];
            
            xmlFree(doc);
        }
    }
    else
    {
        [operationResult setReturnCode: [request responseStatusCode]];
        [operationResult setMessage: [request responseStatusMessage]];
        [operationResult setError: [request error]];

    }
    return operationResult;
}


/*******************************************
 
 List Asynchronous version.
 
 ********************************************/
-(void)resources:(NSString *)uri responseDelegate:(id <JSResponseDelegate>)responseDelegate {
    
    [self resources:uri withArguments:[NSMutableDictionary dictionary] responseDelegate:responseDelegate];
	
}
    
- (void)resources:(NSString *)uri withArguments:(NSDictionary *)args responseDelegate:(id <JSResponseDelegate>)responseDelegate {
    
    NSLog(@"Requesting url: %@", uri);
	
	NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/rest/resources%@", [jsServerProfile baseUrl], uri];
	
    NSMutableString *queryString = [NSMutableString stringWithString:@""];
    
    if (args != nil)
	{
		NSEnumerator *enumerator = [args keyEnumerator];
		id objKey;
		while ((objKey = [enumerator nextObject])) {
			
			id value = [args objectForKey:objKey];
            
			if ([value isKindOfClass: [NSArray class]])
		    {
				NSArray *values = (NSArray *)value;
				for (int i=0; i< [values count]; ++i)
				{
                    if ([queryString length] == 0)
                    {
                        [queryString appendString:@"?"];
                    }
                    else
                    {
                        [queryString appendString:@"&"];
                    }
                    NSString *val = [[NSString stringWithFormat:@"%@",[values objectAtIndex:i]] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                    NSString *key = [[NSString stringWithFormat:@"%@",objKey] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                    [queryString appendFormat:@"%@=%@",key,val];
				}
		    }
			else
			{
                if ([queryString length] == 0)
                {
                    [queryString appendString:@"?"];
                }
                else
                {
                    [queryString appendString:@"&"];
                }
                NSString *val = [[NSString stringWithFormat:@"%@",value] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                NSString *key = [[NSString stringWithFormat:@"%@",objKey] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                [queryString appendFormat:@"%@=%@",key,val];
            }
		}
	}
    
    [urlString appendString:queryString];
    
    NSURL *url = [NSURL URLWithString: urlString];

	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	
	// Bind the delegate to the request....
	JSCallBack *callBack = [[JSCallBack alloc] init];
	[callBack setDelegate: responseDelegate];
	[callBack setCallBackType: REQUEST_RESOURCES];
	[callBack setRequest:request];
	
	//CFDictionaryAddValue( requestsAndDelegates, request, callBack );
	[requestCallBacks addObject: callBack];
	
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];    
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"resources"] ?: self.timeOut];
    if (!authenticated) 
    {
        [request setShouldPresentCredentialsBeforeChallenge: NO];
    }
	[request setDelegate: self];
	[request startAsynchronous];
}


/*******************************************
 
 RESOURCE Synchronous version
 
 ********************************************/
- (JSOperationResult *)resourceInfo:(NSString *)uri {
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/rest/resource%@", [jsServerProfile baseUrl], uri]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];    
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"resourceInfo"] ?: self.timeOut];
    if (!authenticated) 
    {
        [request setShouldPresentCredentialsBeforeChallenge: NO];
    }
	[request startSynchronous];
	
	return [self parseResourceResponse: request];
}

-(JSOperationResult *)parseResourceResponse:(ASIHTTPRequest *)request
{
    JSOperationResult *operationResult = nil;
    operationResult = [JSOperationResult operationResultWithReturnCode:[request responseStatusCode] message:[request responseStatusMessage]];
    
    if (![request error] && [request responseStatusCode] <= 400)
    {
        // parse the xml...
        xmlDocPtr doc;
        
        /* Load XML document */
        NSString *responseString = [request responseString];
        
        if (responseString == nil && [request responseData] != nil) // we have a big xml to parse here...
        {
            // Parsing data like that it is not trivial... let's save the data in a temporary file...
            NSString *tmpDir = NSTemporaryDirectory();
            
            NSString *tempFile = [tmpDir stringByAppendingPathComponent: [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]];
                                                                          
            [[request responseData] writeToFile:tempFile  atomically:TRUE];
            
            doc = xmlReadFile([tempFile UTF8String], NULL, 0);
            
            if (doc == nil) 
            {
                xmlErrorPtr err = xmlGetLastError();
                if (err->domain == XML_FROM_PARSER && err->code == XML_ERR_INVALID_CHAR)
                {
                    // Try to load the file in a different way, this is probably a charset problem...
                    doc = xmlReadFile([tempFile UTF8String], "iso-8859-1", 0);
                }
            }
            
        }
        else
        {
            doc = xmlParseMemory([responseString UTF8String], [responseString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        }
            
        if (doc == NULL)
        {
            NSLog(@"Unable to parse.");
            NSLog(@"%@",responseString);
            return operationResult;
        }
        
        xmlNode *rootNode = xmlDocGetRootElement(doc);
        
        // Parse the resource descriptors children  of the root....
        JSResourceDescriptor *rd = [self parseResourceDescriptor:rootNode];
        NSMutableArray *descriptors = [NSMutableArray arrayWithCapacity:1];
        [descriptors addObject:rd];
        
        [operationResult setResourceDescriptors:descriptors];
        
        xmlFree(doc);
    }
    
    else
    {
        [operationResult setMessage: [request responseString]];
        [operationResult setError: [request error]];
    }
    return operationResult;
}



/*******************************************
 
 RESOURCE Asynchronous version.
 
 ********************************************/
- (void)resourceInfo:(NSString *)uri responseDelegate:(id <JSResponseDelegate>)responseDelegate;
{
	[self resourceInfo:uri withArguments: [NSDictionary dictionary] responseDelegate:responseDelegate];
}

/*******************************************
 
 RESOURCE Asynchronous version.
 
 ********************************************/
- (void)resourceInfo:(NSString *)uri withArguments:(NSDictionary *)args  responseDelegate:(id <JSResponseDelegate>)responseDelegate {
	
	NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/rest/resource%@", [jsServerProfile baseUrl], uri];
	
	NSMutableString *queryString = [NSMutableString stringWithString:@""];
    
	if (args != nil)
	{
		NSEnumerator *enumerator = [args keyEnumerator];
		id objKey;
		while ((objKey = [enumerator nextObject])) {
			
			id value = [args objectForKey:objKey];

			if ([value isKindOfClass: [NSArray class]])
		    {
				NSArray *values = (NSArray *)value;
				for (int i=0; i< [values count]; ++i)
				{
                    if ([queryString length] == 0)
                    {
                        [queryString appendString:@"?"];
                    }
                    else
                    {
                        [queryString appendString:@"&"];
                    }
                    NSString *val = [[NSString stringWithFormat:@"%@",[values objectAtIndex:i]] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                    NSString *key = [[NSString stringWithFormat:@"%@",objKey] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                    [queryString appendFormat:@"%@=%@",key,val];
				}
		    }
			else
			{
                if ([queryString length] == 0)
                {
                    [queryString appendString:@"?"];
                }
                else
                {
                    [queryString appendString:@"&"];
                }
                NSString *val = [[NSString stringWithFormat:@"%@",value] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                NSString *key = [[NSString stringWithFormat:@"%@",objKey] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                [queryString appendFormat:@"%@=%@",key,val];
            }
		}
	}

    [urlString appendString:queryString];
    
    NSURL *url = [NSURL URLWithString: urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
	// Bind the delegate to the request....
	JSCallBack *callBack = [[JSCallBack alloc] init];
	[callBack setDelegate: responseDelegate];
	[callBack setCallBackType: REQUEST_RESOURCE];
	[callBack setRequest:request];
	
	//CFDictionaryAddValue( requestsAndDelegates, request, callBack );
	[requestCallBacks addObject: callBack];
	
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];    
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"resourceInfo"] ?: self.timeOut];
    if (!authenticated) 
    {
        [request setShouldPresentCredentialsBeforeChallenge: NO];
    }
	[request setDelegate: self];
	[request startAsynchronous];
}



/*******************************************
 
 FILE Synchronous version
 
 ********************************************/
- (bool)resourceFile:(NSString *)uri andFilename: (NSString *)identifier toPath: (NSString *)path {
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/rest/resource/%@&file=%@", [jsServerProfile baseUrl], uri, identifier]];
	
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    	
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];    
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"resourceFile"] ?: self.timeOut];
     if (!authenticated) 
     {
         [request setShouldPresentCredentialsBeforeChallenge: NO];
     }
	[request setDownloadDestinationPath:path];
	[request startSynchronous];
	
	NSError *error = [request error];
	if (!error) {
		return YES;
	}
	
	return NO;
}


/*******************************************
 
 FILE Asynchronous version.
 
 ********************************************/
- (void)resourceFile:(NSString *)uri andFilename:(NSString *)identifier toPath: (NSString *)path responseDelegate:(id <JSResponseDelegate>)responseDelegate {
	
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/rest/resource%@?file=%@", [jsServerProfile baseUrl], uri, identifier]];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	
	
	// Bind the delegate to the request....
	JSCallBack *callBack = [[JSCallBack alloc] init];
	[callBack setDelegate: responseDelegate];
	[callBack setCallBackType: REQUEST_RESOURCE_FILE];
	[callBack setRequest:request];
	
	//CFDictionaryAddValue( requestsAndDelegates, request, callBack );
	[requestCallBacks addObject: callBack];
	
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];    
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"resourceFile"] ?: self.timeOut];
    
    if (!authenticated) 
    {
        [request setShouldPresentCredentialsBeforeChallenge: NO];
    }
	[request setDownloadDestinationPath:path];
	[request setDelegate: self];
	[request startAsynchronous];
}




/*******************************************
 
 RunReport Synchronous version
 
 ********************************************/
- (JSOperationResult *)reportRun:(NSString *)uri withParameters:(NSDictionary *)params withArguments:(NSDictionary *)args {
	
	JSOperationResult *res = nil;
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/rest/report%@", [jsServerProfile baseUrl], uri]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	
	if (args != nil)
	{
		NSEnumerator *enumerator = [args keyEnumerator];
		id objKey;
		while ((objKey = [enumerator nextObject])) {
			
			id value = [args objectForKey:objKey];
			
			if ([value isKindOfClass: [NSArray class]])
		    {
				NSArray *values = (NSArray *)value;
				for (int i=0; i< [values count]; ++i)
				{
					[request addPostValue:[values objectAtIndex:i] forKey:objKey];
				}
		    }
			else {
				[request addPostValue:value forKey:objKey];
			}

		}
	}
	
	if (params != nil)
	{
		NSEnumerator *enumerator = [params keyEnumerator];
		id objKey;
		while ((objKey = [enumerator nextObject])) {
			
			id value = [params objectForKey:objKey];
			
			if ([value isKindOfClass: [NSArray class]])
		    {
				NSArray *values = (NSArray *)value;
				for (int i=0; i< [values count]; ++i)
				{
					[request addPostValue:[values objectAtIndex:i] forKey:objKey];
				}
		    }
			else {
				[request addPostValue:value forKey:objKey];
			}

		}
	}
	
	
	
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];    
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"reportRun"] ?: self.timeOut];
    
    
    if (!authenticated) 
    {
        [request setShouldPresentCredentialsBeforeChallenge: NO];
    }
	[request startSynchronous];
	
	NSError *error = [request error];
	if (!error) {
		NSString *response = [request responseString];
		//NSLog(response);
		
		res = [self parseResponse:response];
	}
    
    
	
	return res;
}
/*******************************************
 
 RunReport Asynchronous version.
 
 ********************************************/
-(void)reportRun:(NSString *)uri withParameters:(NSDictionary *)params withArguments:(NSDictionary *)args responseDelegate:(id <JSResponseDelegate>)responseDelegate {
	
	
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/rest/report%@", [jsServerProfile baseUrl], uri];
	
	NSMutableString *queryString = [NSMutableString stringWithString:@""];
    
    // Append the arguments to the query string...
    
	if (args != nil)
	{
		NSEnumerator *enumerator = [args keyEnumerator];
		id objKey;
		while ((objKey = [enumerator nextObject])) {
			
			id value = [args objectForKey:objKey];
            
			if ([value isKindOfClass: [NSArray class]])
		    {
				NSArray *values = (NSArray *)value;
				for (int i=0; i< [values count]; ++i)
				{
                    if ([queryString length] == 0)
                    {
                        [queryString appendString:@"?"];
                    }
                    else
                    {
                        [queryString appendString:@"&"];
                    }
                    NSString *val = [[NSString stringWithFormat:@"%@",[values objectAtIndex:i]] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                    NSString *key = [[NSString stringWithFormat:@"%@",objKey] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                    [queryString appendFormat:@"%@=%@",key,val];
				}
		    }
			else
			{
                if ([queryString length] == 0)
                {
                    [queryString appendString:@"?"];
                }
                else
                {
                    [queryString appendString:@"&"];
                }
                NSString *val = [[NSString stringWithFormat:@"%@",value] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                NSString *key = [[NSString stringWithFormat:@"%@",objKey] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                [queryString appendFormat:@"%@=%@",key,val];
            }
		}
	}
    
    [urlString appendString:queryString];
    
    NSURL *url = [NSURL URLWithString: urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    // Prepare the resource descriptor for which we want to run the report....
    
    NSMutableString *resourceDescriptorXml = [NSMutableString stringWithFormat:@"<resourceDescriptor name=\"\" wsType=\"reportUnit\" uriString=\"%@\">", uri];
    
    if (params != nil)
	{
		NSEnumerator *enumerator = [params keyEnumerator];
		id objKey;
		while ((objKey = [enumerator nextObject])) {
			
			id value = [params objectForKey:objKey];
			
			if ([value isKindOfClass: [NSArray class]])
		    {
				NSArray *values = (NSArray *)value;
				for (int i=0; i< [values count]; ++i)
				{
                    
                    [resourceDescriptorXml appendFormat:@"<parameter name=\"%@\" isListItem=\"true\"><![CDATA[%@]]></parameter>", objKey, [values objectAtIndex:i]];
					//[request addPostValue:[values objectAtIndex:i] forKey:objKey];
				}
		    }
			else {
                [resourceDescriptorXml appendFormat:@"<parameter name=\"%@\"><![CDATA[%@]]></parameter>", objKey, value];
				//[request addPostValue:value forKey:objKey];
            }
			
		}
	}
	
    
    [resourceDescriptorXml appendString:@"</resourceDescriptor>"];
    
    
    [request setRequestMethod: @"PUT"];
	[request appendPostData:[resourceDescriptorXml dataUsingEncoding:NSUTF8StringEncoding]];
	
	// Bind the delegate to the request....
	JSCallBack *callBack = [[JSCallBack alloc] init];
	[callBack setDelegate: responseDelegate];
    
	[callBack setCallBackType: REQUEST_REPORT];
	[callBack setRequest:request];
	
	[requestCallBacks addObject: callBack];
	
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];    
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"reportRun"] ?: self.timeOut];
    
    if (!authenticated) 
    {
        [request setShouldPresentCredentialsBeforeChallenge: NO];
    }
	[request setDelegate: self];
	[request startAsynchronous];
}


/*******************************************
 
 REPORT FILE Synchronous version
 
 ********************************************/
- (bool)reportFile:(NSString *)uuid andFilename: (NSString *)identifier toPath: (NSString *)path {
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/rest/report%@&file=%@", [jsServerProfile baseUrl], uuid, identifier]];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];    
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"reportFile"] ?: self.timeOut];
    if (!authenticated) 
    {
        [request setShouldPresentCredentialsBeforeChallenge: NO];
    }
	[request setDownloadDestinationPath:path];
	[request startSynchronous];
	
	NSError *error = [request error];
	if (!error) {
		return YES;
	}
	
	return NO;
}


/*******************************************
 
 REPORT FILE Asynchronous version.
 
 ********************************************/
- (void)reportFile:(NSString *)uuid andFilename:(NSString *)identifier toPath: (NSString *)path responseDelegate:(id <JSResponseDelegate>)responseDelegate {
	
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/rest/report/%@?file=%@", [jsServerProfile baseUrl], uuid, identifier]];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];	
	
	// Bind the delegate to the request....
	JSCallBack *callBack = [[JSCallBack alloc] init];
	[callBack setDelegate: responseDelegate];
	[callBack setCallBackType: REQUEST_RESOURCE_FILE];
	[callBack setRequest:request];
	
	//CFDictionaryAddValue( requestsAndDelegates, request, callBack );
	[requestCallBacks addObject: callBack];
	
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];    
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"reportFile"] ?: self.timeOut];
    if (!authenticated) 
    {
        [request setShouldPresentCredentialsBeforeChallenge: NO];
    }
	[request setDownloadDestinationPath:path];
	[request setDelegate: self];
	[request startAsynchronous];
}


/*******************************************
 
 CREATE A NEW RESOURCE Asynchronous version.
 
 ********************************************/
- (void)resourceCreate: (NSString *)parentFolder resourceDescriptor: (JSResourceDescriptor *)rd data: (NSData *)data responseDelegate:(id <JSResponseDelegate>)responseDelegate
{
    
    NSString *xml = [self resourceDescriptorToXml:rd];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/rest/resource%@", [jsServerProfile baseUrl], parentFolder]];
	
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	
    [request setPostFormat: ASIMultipartFormDataPostFormat];
    
    
    [request setRequestMethod: @"PUT"];
	[request addPostValue:xml forKey: @"ResourceDescriptor"];
	
	if (data != nil)
    {
        [request addData:data withFileName:@"file" andContentType:@"application/octet-stream" forKey: [rd uri]];
    }
    
	// Bind the delegate to the request....
	JSCallBack *callBack = [[JSCallBack alloc] init];
	[callBack setDelegate: responseDelegate];
	[callBack setCallBackType: REQUEST_RESOURCE];
	[callBack setRequest:request];
	
	//CFDictionaryAddValue( requestsAndDelegates, request, callBack );
	[requestCallBacks addObject: callBack];
	
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];    
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"resourceCreate"] ?: self.timeOut];
    if (!authenticated) 
    {
        [request setShouldPresentCredentialsBeforeChallenge: NO];
    }
	[request setDelegate: self];
	[request startAsynchronous];
}


/*******************************************
 
 MODIFY A RESOURCE Asynchronous version.
 
 ********************************************/
- (void)resourceModify: (NSString *)uri resourceDescriptor: (JSResourceDescriptor *)rd data: (NSData *)data responseDelegate:(id <JSResponseDelegate>)responseDelegate;

{
    
    NSString *xml = [self resourceDescriptorToXml:rd];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/rest/resource%@", [jsServerProfile baseUrl], uri]];
	
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	
    [request setPostFormat: ASIMultipartFormDataPostFormat];
    
    
    [request setRequestMethod: @"POST"];
	[request addPostValue:xml forKey: @"ResourceDescriptor"];
	
	if (data != nil)
    {
        [request addData:data withFileName:@"file" andContentType:@"application/octet-stream" forKey: [rd uri]];
    }
    
	// Bind the delegate to the request....
	JSCallBack *callBack = [[JSCallBack alloc] init];
	[callBack setDelegate: responseDelegate];
	[callBack setCallBackType: REQUEST_RESOURCE];
	[callBack setRequest:request];
	
	//CFDictionaryAddValue( requestsAndDelegates, request, callBack );
	[requestCallBacks addObject: callBack];
	    
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];    
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"resourceModify"] ?: self.timeOut];
    if (!authenticated) 
    {
        [request setShouldPresentCredentialsBeforeChallenge: NO];
    }
	[request setDelegate: self];
	[request startAsynchronous];
    
    
}


/*******************************************
 
 DELETE A RESOURCE OR A FOLDER Asynchronous version.
 
 ********************************************/
- (void)resourceDelete: (NSString *)uri responseDelegate:(id <JSResponseDelegate>)responseDelegate
{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/rest/resource%@", [jsServerProfile baseUrl], uri]];
	
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setRequestMethod: @"DELETE"];
	
	// Bind the delegate to the request....
	JSCallBack *callBack = [[JSCallBack alloc] init];
	[callBack setDelegate: responseDelegate];
	[callBack setCallBackType: REQUEST_EMPTY];
	[callBack setRequest:request];
	
	//CFDictionaryAddValue( requestsAndDelegates, request, callBack );
	[requestCallBacks addObject: callBack];
	
    
    [request setUsername: [[self jsServerProfile] getUsernameWithOrgId]];    
	[request setPassword: [[self jsServerProfile] password]];
    [request setTimeOutSeconds: [self getTimeOutForMethod:@"resourceDelete"] ?: self.timeOut];
    if (!authenticated) 
    {
        [request setShouldPresentCredentialsBeforeChallenge: NO];
    }
	[request setDelegate: self];
	[request startAsynchronous];
    
    
}

-(NSString *)resourcePropertyToXml:(JSResourceProperty *)rp
{
    NSMutableString *xml = [NSMutableString stringWithFormat:@"<%@ %@=\"%@\">",
                            JS_NSXML_RESOURCE_PROPERTY,
                            JS_NSXML_NAME,
                            [rp name]];
    
    if ([rp value] != nil)
    {
        
        [xml appendFormat:@"<value><![CDATA[%@]]></value>",[rp value]];
    }

    for (int i=0; i< [[rp resourceProperties] count]; ++i)
    {
        JSResourceProperty *rpChild = (JSResourceProperty *)[[rp resourceProperties] objectAtIndex: i];
        
        [xml appendString: [self resourcePropertyToXml:rpChild]];
    }
    
    [xml appendString: @"</resourceProperty>"];
    
    return xml;
}

-(NSString *)resourceParameterToXml:(JSResourceParameter *)rp
{
    NSMutableString *xml = [NSMutableString stringWithFormat:@"<%@ %@=\"%@\"",
                            JS_NSXML_RESOURCE_PARAMETER,
                            JS_NSXML_NAME,
                            [rp name]];
    
    if ([rp isListItem])
    {
        [xml appendString:@" isListItem=\"true\""];
    }
     
    if ([rp value] != nil)
    {
        [xml appendFormat:@"><![CDATA[%@]]></%@>",[rp value], JS_NSXML_RESOURCE_PARAMETER];
    }
    else
    {
        [xml appendString:@"/>"];        
    }
    
    return xml;
}

-(NSString *)resourceDescriptorToXml:(JSResourceDescriptor *)rd
{
    if (rd == nil) return nil;
    
    NSMutableString *xml = [NSMutableString stringWithFormat:@"<%@ ", JS_NSXML_RESOURCE_DESCRIPTOR];
    
    if ([rd name] != nil)
    {
        [xml appendFormat:@" %@=\"%@\"", JS_NSXML_NAME, [rd name]];
    }
    
    if ([rd wsType] != nil)
    {
        [xml appendFormat:@" %@=\"%@\"", JS_NSXML_WSTYPE, [rd wsType]];
    }
    
    if ([rd uri] != nil)
    {
        [xml appendFormat:@" %@=\"%@\"", JS_NSXML_URI_STRING, [rd uri]];
    }
    if ([rd isNew] == TRUE)
    {
        [xml appendString:@" isNew=\"true\""];
    }
    [xml appendString:@">"];
    
    if ([rd label] != nil)
    {
        [xml appendFormat:@"<label><![CDATA[%@]]></label>", [rd label]];
    }
    
    if ([rd description] != nil)
    {
        [xml appendFormat:@"<description><![CDATA[%@]]></description>", [rd description]];
    }
    
        
    for (int i=0; i< [[rd resourceProperties] count]; ++i)
    {
        JSResourceProperty *rp = (JSResourceProperty *)[[rd resourceProperties] objectAtIndex: i];
            
        [xml appendString: [self resourcePropertyToXml:rp]];
    }
    
    for (int i=0; i< [[rd resourceDescriptors] count]; ++i)
    {
        JSResourceDescriptor *rp = (JSResourceDescriptor *)[[rd resourceDescriptors] objectAtIndex: i];
        
        [xml appendString: [self resourceDescriptorToXml:rp]];
    }
    
    for (int i=0; i< [[rd resourceParameters] count]; ++i)
    {
        JSResourceParameter *rp = (JSResourceParameter *)[[rd resourceParameters] objectAtIndex: i];
        
        [xml appendString: [self resourceParameterToXml:rp]];
    }
    
    
    [xml appendFormat:@"</%@>", JS_NSXML_RESOURCE_DESCRIPTOR];
    
    return xml;
    
}


-(JSOperationResult *)parseReportRunResponse:(ASIHTTPRequest *)request
{
    JSOperationResult *operationResult = nil;
    operationResult = [JSOperationResult operationResultWithReturnCode:0 message:[request responseStatusMessage]];
    
    if (![request error])
    {
        // parse the xml...
        xmlDocPtr doc;
        
        /* Load XML document */
        NSString *responseString = [request responseString]; 
        doc = xmlParseMemory([responseString UTF8String], [responseString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        
        if (doc == NULL)
        {
            NSLog(@"Unable to parse.");
            NSLog(@"%@",responseString);
            return nil;
        }
        
        xmlNode *rootNode = xmlDocGetRootElement(doc);
        
        JSReportExecution *reportExecution = [[[JSReportExecution alloc] init] autorelease];
        
        [reportExecution setUuid:[JSXMLUtils getValueFromNode: doc xPathQuery: @"/report/uuid"]];
        [reportExecution setUri:[JSXMLUtils getValueFromNode: doc xPathQuery: @"/report/uri"]];
        [reportExecution setTotalPages:[JSXMLUtils getIntValueFromNode: doc xPathQuery: @"/report/totalPages"]];
        
        // get all the files and thier content type
        
        NSMutableArray *fileNames = [NSMutableArray arrayWithCapacity:0]; // This object uses autorelease, so no free must be called...
        NSMutableArray *contentTypes = [NSMutableArray arrayWithCapacity:0]; // This object uses autorelease, so no free must be called...
        
        xmlNode *cur_node = NULL;
        for (cur_node = rootNode->children; cur_node; cur_node = cur_node->next) {
            
            
            if (cur_node->type == XML_ELEMENT_NODE && xmlStrcmp(cur_node->name,(const xmlChar *)JS_XML_RE_FILE)==0) {
                NSString *fileName = [JSXMLUtils getNodeValue:cur_node];
                
                if (fileName != nil && [fileName lengthOfBytesUsingEncoding: NSUTF8StringEncoding] > 0)
                {
                    [fileNames addObject:fileName];
                    if (xmlHasProp(cur_node, JS_XML_RE_TYPE)) {
                        
                        NSString* contentType = [JSXMLUtils getAttribute: (const xmlChar *)JS_XML_RE_TYPE ofNode: cur_node];
                        [contentTypes addObject: contentType];
                    }
                }
            }
        }
        [reportExecution setFileNames:fileNames];
        [reportExecution setFileTypes:contentTypes];
        
        [operationResult setReportExecution: reportExecution];
        
        
        xmlFree(doc);
    }
    else
    {
        [operationResult setError: [request error]];
    }
    return operationResult;
}

//////////////  PARSING FUNCTIONS  //////////////////////

-(JSOperationResult *)parseResponse:(NSString *)response {

	xmlDocPtr doc;
	JSOperationResult *operationResult = nil;
	
	/* Load XML document */
    doc = xmlParseMemory([response UTF8String], [response lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    if (doc == NULL)
    {
        NSLog(@"Unable to parse.");
        NSLog(@"%@",response);
        return nil;
    }
	
	xmlNode *rootNode = xmlDocGetRootElement(doc);

	NSString *code =  [JSXMLUtils getValueFromNode: doc xPathQuery: @"/operationResult/returnCode"];
	
	// Error parsing the restul!!!
	if (code == nil)
	{
		return nil; 
	}
	else {
		
		NSString *message = [JSXMLUtils getValueFromNode: doc xPathQuery: @"/operationResult/message"];
		operationResult = [JSOperationResult operationResultWithReturnCode:[code intValue] message:(message == nil) ? @"" : message];
		
		// Parse the resource descriptors children  of the root....
		NSMutableArray *descriptors = [self parseResourceDescriptors: rootNode->children ];
		[operationResult setResourceDescriptors:descriptors];
	 }
	
	xmlFree(doc);
	return operationResult;
}


// Read all the nodes of type resourceDescriptor that are siblings or children of a given xml node
// and return them in a NSMutableArray which contains ResourseDescriptor objects
-(NSMutableArray *)parseResourceDescriptors:(xmlNode *)node {
	
	NSMutableArray *res = [NSMutableArray arrayWithCapacity:0]; // This object is autoreleases, so no free must be called...
	
	
	xmlNode *cur_node = NULL;
	
    for (cur_node = node; cur_node; cur_node = cur_node->next) {
        if (cur_node->type == XML_ELEMENT_NODE && xmlStrcmp(cur_node->name,JS_XML_RESOURCE_DESCRIPTOR)==0) {
			
			JSResourceDescriptor *rd = [self parseResourceDescriptor: cur_node];
			if (rd != nil)
			{
				[res addObject:rd];
			}
		}
    }
	
	return res;
}

-(JSResourceDescriptor *)parseResourceDescriptor:(xmlNode *)node {

	JSResourceDescriptor *rd = [JSResourceDescriptor resourceDescriptor];
	
    xmlNode *child_node = NULL;
    
    // jasperserver_string_set is NULL safe...
    if (xmlHasProp(node, JS_XML_NAME))       { 
		[rd setName: [JSXMLUtils getAttribute: (const xmlChar *)JS_XML_NAME ofNode: node]];
	}
	if (xmlHasProp(node, JS_XML_WSTYPE))     { 
		[rd setWsType: [JSXMLUtils getAttribute: (const xmlChar *)JS_XML_WSTYPE ofNode: node]];
	}
	if (xmlHasProp(node, JS_XML_URI_STRING)) { 
		[rd setUri: [JSXMLUtils getAttribute: (const xmlChar *)JS_XML_URI_STRING ofNode: node]];
	}

	//if (xmlHasProp(resNode, "isNew" )) {
	//	const xmlChar *isNew =  xmlGetProp(resNode, BAD_CAST "isNew" );
	//	res->isNew = (!xmlStrcmp(isNew, "true")) ? 1 : 0;
	//	xmlFree(isNew);
    //}
	
    for (child_node = node->children; child_node; child_node = child_node->next) {
        if (child_node->type == XML_ELEMENT_NODE) {
			
            if (!xmlStrcmp(child_node->name, JS_XML_LABEL))
            {
				[rd setLabel: [JSXMLUtils getNodeValue: child_node]];
            }
            else if (!xmlStrcmp(child_node->name,(xmlChar *)JS_XML_DESCRIPTION))
            {
				[rd setDescription: [JSXMLUtils getNodeValue: child_node]];
            }
            else if (!xmlStrcmp(child_node->name, JS_XML_RESOURCE_PROPERTY))
			{
				JSResourceProperty *rp = [self parseResourceProperty: child_node];
				if (rp != nil)
				{
					[[rd resourceProperties] addObject:rp];
				}
			}
			else if (!xmlStrcmp(child_node->name, JS_XML_RESOURCE_DESCRIPTOR))
			{
				JSResourceDescriptor *subRd = [self parseResourceDescriptor: child_node];
				if (subRd != nil)
				{
					[[rd resourceDescriptors] addObject:subRd];
				}
				else {
					NSLog(@"Descriptor parsing failed...");
				}

			}
        }
	}
	
	return rd;
	
}


-(JSResourceProperty *)parseResourceProperty:(xmlNode *)node {
	
	JSResourceProperty *rp = [JSResourceProperty resourceProperty];
	
    xmlNode *child_node = NULL;
    
    // jasperserver_string_set is NULL safe...
    if (xmlHasProp(node, JS_XML_NAME ))     { [rp setName: [JSXMLUtils getAttribute: (const xmlChar *)JS_XML_NAME ofNode: node]]; }

    for (child_node = node->children; child_node; child_node = child_node->next) {
        if (child_node->type == XML_ELEMENT_NODE) {
			
            if (!xmlStrcmp(child_node->name, JS_XML_VALUE))
            {
				[rp setValue: [JSXMLUtils getNodeValue: child_node]];
            }
            else if (!xmlStrcmp(child_node->name, JS_XML_RESOURCE_PROPERTY))
			{
				JSResourceProperty *subRp = [self parseResourceProperty: child_node];
				if (subRp != nil)
				{
					[[rp resourceProperties] addObject:subRp];
				}
			}
		}
	}
	
	return rp;
	
}

//////////////  HELPER FUNCTIONS  //////////////////////

- (void)setTimeOut:(NSInteger)methodTimeOut forMethod:(NSString *)methodName {
    [self.timeOutsForMethods setObject:[NSNumber numberWithInteger:methodTimeOut] forKey:methodName];
}

- (void)removeTimeOutForMethod:(NSString *)methodName {
    [self.timeOutsForMethods removeObjectForKey:methodName];
}

- (NSInteger)getTimeOutForMethod:(NSString *)methodName {
    return [[self.timeOutsForMethods objectForKey:methodName] integerValue];
}

@end


