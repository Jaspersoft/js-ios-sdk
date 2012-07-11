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
 * along with Jaspersoft Mobile. If not, see <http://www.gnu.org/licenses/>.
 */

//
//  ResourcePreviewController.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 5/20/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSUIResourcePreviewController.h"
#import "JSUILoadingView.h"


@implementation JSUIResourcePreviewController : UIViewController
@synthesize descriptor;
@synthesize client;

-(id)init
{
    self = [super init];
    //resources = nil;
    descriptor = nil;
    resourceLoaded = NO;
    webView = nil;
    
    return self;
}



- (void)viewDidLoad {
	
	[super viewDidLoad];	
     
    if (webView == nil)
    {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
    }
}


- (void) dealloc
{
	[webView release];
	[super dealloc];
}

//
// As the view appears, we trigger the fetcher to load the resource (if it is not on out cache...)
//
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	if (descriptor != nil)
	{
		[self performSelector:@selector(loadResourceFile) withObject:nil afterDelay:0.0];
	}
	
}

//
// Load the resource from remote...
//
-(void)loadResourceFile {
	
	if ([self client] == nil) return;
	
	if ([self descriptor] != nil)
	{
		self.navigationItem.title=[NSString stringWithFormat:@"%@", [descriptor label]];
		
		// load the busy view...
		[JSUILoadingView showLoadingInView:self.view];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *cacheDirectory = [documentsDirectory stringByAppendingPathComponent:@"cache"];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		if (![fileManager fileExistsAtPath:cacheDirectory])
		{
			[fileManager createDirectoryAtPath:cacheDirectory withIntermediateDirectories: YES attributes: nil error:NULL];
		}
		
		// We don't use cache here for now....
		NSString *extension = @"";
		if (  [descriptor.wsType isEqualToString:JS_TYPE_IMAGE] )
		{
			extension = @"png";
		}
		else if (  [descriptor.wsType isEqualToString:JS_TYPE_PDF] )
		{
			extension = @"pdf";
		}
		else if (  [descriptor.wsType isEqualToString:JS_TYPE_PDF] )
		{
			extension = @"html";
		}
		else if (  [descriptor.wsType isEqualToString:JS_TYPE_CSS] || [descriptor.wsType isEqualToString:JS_TYPE_RESOURCE_BUNDLE] || [descriptor.wsType isEqualToString:JS_TYPE_JRXML])
		{
			extension = @"txt";
		}
		
		// the path to write file
		NSString *resourceFile = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.%@",self.descriptor.name, extension]]; //self.descriptor.name
		
		[[self client] resourceFile: self.descriptor.uri andFilename: @"attachment" toPath: resourceFile responseDelegate: self];  
	}
}

-(void)fileRequestFinished:(NSString *)path contentType:(NSString *)contentType {
	
	resourceLoaded = true;
	
	[JSUILoadingView hideLoadingView];
	
	//[self.navigationController setToolbarHidden: NO];
	NSFileManager *myFM = [NSFileManager defaultManager];
	
	if ( [myFM isReadableFileAtPath:path] )
	{
		if (  [descriptor.wsType isEqualToString:JS_TYPE_IMAGE] )
		{
				for(UIView *wview in [[[webView subviews] objectAtIndex:0] subviews]) { 
					if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; } 
				}   
			webView.backgroundColor= [UIColor blackColor];
			
				NSURL *url = [NSURL fileURLWithPath:path];
				NSString *htmlString = [NSString stringWithFormat:@"<html><head>\
										<meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = yes, width = 320\"/></head>\
										<body style=\"background:#000;margin-top:0px;margin-left:0px\">\
										<table height=436 cellpadding=0 cellspacing=0><tr><td valign=middle align=center><div style=\"background-color: #fff;\"><img style=\"vertical-align: middle\" src=\"%@\" width=\"320\" /></div></td></table>\
										</body></html>",url];
				[webView loadHTMLString:htmlString baseURL:nil];
		}
		else if (  [descriptor.wsType isEqualToString:JS_TYPE_JRXML] )
		{
			for(UIView *wview in [[[webView subviews] objectAtIndex:0] subviews]) { 
				if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; } 
			}   
			webView.backgroundColor= [UIColor blackColor];
			
			// Assuming UTF8 encoding here....
			NSString *content = [NSString stringWithContentsOfFile: path encoding:NSUTF8StringEncoding error:nil ];
			
			content = [content stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
			
			NSString *htmlString = [NSString stringWithFormat:@"<html><head>\
									<meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = yes, width = 320\"/></head>\
									<body style=\"background:#000;margin-top:0px;margin-left:0px\">\
									<div style=\"color: #ffffff; font-family: courier;\">%@</div>\
									</body></html>",content];
			[webView loadHTMLString:htmlString baseURL:nil];
		}
		else {
			[webView loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath:path]]];
		}

		
	}
	
}

-(void)requestFinished:(JSOperationResult *)op
{
}

@end
