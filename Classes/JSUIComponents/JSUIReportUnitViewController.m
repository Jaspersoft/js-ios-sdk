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
//  ReportUnitViewController.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 6/7/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSUIReportUnitViewController.h"
#import "ASIWebPageRequest.h"
#import "JSUILoadingView.h"



@implementation JSUIReportUnitViewController

@synthesize descriptor, parameters, previousController, client, format;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return true;
}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
		descriptor = nil;
		reportLoaded = NO;
		myPageRef = nil;
		myContentView = nil;
        self.format = @"PDF";
	}
	return self;
}


- (void)dealloc
{
	if (myContentView != nil)
	{
		[myContentView release], myContentView = nil;
		CGPDFDocumentRelease(myDocumentRef), myDocumentRef = NULL;
		myPageRef = NULL;
    }
    [toolbar release];
    [super dealloc];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
		// fix the view area...
		if (scrollView != nil)
		{
			CGRect pagingScrollViewFrame =  [[UIScreen mainScreen] bounds];
			CGRect screenBounds =  [[UIScreen mainScreen] bounds];
			
			
			if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
				toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
			{
				pagingScrollViewFrame.origin.x -= 10;
				pagingScrollViewFrame.size.height = screenBounds.size.width - 20;
				pagingScrollViewFrame.size.width = screenBounds.size.height + (2 * 10);
				
				// Optimize for this view...
				
			}
			else {
				pagingScrollViewFrame.origin.x -= 10;
				//pagingScrollViewFrame.size.height;
				pagingScrollViewFrame.size.width += (2 * 10);
			}

			scrollView.frame = pagingScrollViewFrame;
		
			CGRect pageRect = CGRectIntegral(CGPDFPageGetBoxRect(myPageRef, kCGPDFCropBox));
			
			CGFloat xScale = (pagingScrollViewFrame.size.width-20.0) / pageRect.size.width;
			scrollView.zoomScale = xScale;
			scrollView.contentOffset = CGPointMake(0.0,0.0);
			
		}
	
	
}

//
// As the view appears, we trigger the fetcher to load the resource (if it is not on out cache...)
//
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	if (descriptor != nil)
	{
		[self performSelector:@selector(executeReport) withObject:nil afterDelay:0.0];
	}
	
}

-(void)executeReport {

	
	reportLoaded = false;
	
	if ([self client] == nil) return;
	
	if ([self descriptor] != nil)
	{
		// load the busy view...
        [JSUILoadingView showLoadingInView:self.view];
        
		
		NSMutableDictionary *arguments  = [NSMutableDictionary dictionaryWithObject:self.format forKey:@"RUN_OUTPUT_FORMAT"];
        [arguments setObject:@"./" forKey:@"IMAGES_URI"];
        
		NSMutableDictionary *namedParameters  = [NSMutableDictionary dictionary];
		
		if (parameters != nil)
		{
			NSEnumerator *enumerator = [parameters keyEnumerator];
			id objKey;
			
			while ((objKey = [enumerator nextObject])) {
				
				id value = [parameters objectForKey:objKey];
				
				if (value == nil) continue;
				if ([value isKindOfClass:[NSArray class]])
				{
					[namedParameters setValue:value 
									   forKey: [NSString stringWithFormat:@"%@",objKey]];
				}
				else if ([value isKindOfClass:[NSDate class]])
				{
					// Dates should be passed to the service as numbers...
					NSDate *dateValue = (NSDate *)value;
					NSTimeInterval interval = [dateValue timeIntervalSince1970];
					[namedParameters setValue:[NSString stringWithFormat:@"%.0f", interval*1000] 
								 forKey: [NSString stringWithFormat:@"%@",objKey]];
				}
				else
				{
					[namedParameters setValue:value forKey: [NSString stringWithFormat:@"%@",objKey]];
				}
			}
			
		}

		[[self client] reportRun: self.descriptor.uri withParameters: namedParameters withArguments: arguments responseDelegate: self];  
	}
	
	
}

-(void)fileRequestFinished:(NSString *)path contentType: (NSString *)contentType
{

	
    
	//[self.navigationController setToolbarHidden: NO];
	NSFileManager *myFM = [NSFileManager defaultManager];
	
	if ( [myFM isReadableFileAtPath:path] )
	{
        
        currentPage = 1;
		if ([format isEqualToString: @"PDF"])
		{
			
			myDocumentRef = CGPDFDocumentCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path]);
			
			myPageRef = CGPDFDocumentGetPage(myDocumentRef, currentPage);
			CGRect pageRect = CGRectIntegral(CGPDFPageGetBoxRect(myPageRef, kCGPDFCropBox));
			
			CGRect pagingScrollViewFrame =  [[UIScreen mainScreen] bounds];
			pagingScrollViewFrame.origin.x -= 10;
			pagingScrollViewFrame.size.height += 20;
			pagingScrollViewFrame.origin.y = 10;
			pagingScrollViewFrame.size.width += (2 * 10);
			
			
			scrollView =[[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
			scrollView.delegate = self;
			//scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * 3, scrollView.bounds.size.height);
			[self setMaxMinZoomScalesForCurrentBounds:scrollView page: pageRect.size];
			
			[toolbar removeFromSuperview];
			
			[self.view addSubview:scrollView];
			[self.view addSubview:toolbar];
			
			
			[self.view.layer setNeedsLayout];
			scrollView.zoomScale= scrollView.minimumZoomScale;
			[JSUILoadingView hideLoadingView];
			
		}
		else if ([format isEqualToString: @"HTML"] && [[path pathExtension] isEqualToString:@"html"])
		{
            
            NSMutableString *html = [NSMutableString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error: nil];
            
            [html replaceOccurrencesOfString:@"http://localhost:8080/jasperserver-pro" withString:[[client jsServerProfile] baseUrl] options: NSLiteralSearch range: NSMakeRange(0, [html length])];
            
            [html replaceOccurrencesOfString:@"dataFormat: 'xml'," withString:@"dataFormat: 'xml',renderer: 'javascript'," options: NSLiteralSearch range: NSMakeRange(0, [html length])];
            
            [html replaceOccurrencesOfString:@"if(typeof(printRequest) === 'function') printRequest();" withString:@"" options: NSLiteralSearch range: NSMakeRange(0, [html length])];
            
        
            [html writeToFile:path atomically:TRUE encoding:NSUTF8StringEncoding error:nil];
            
            //NSLog(@"Content of the string: %@",html);
            
            //NSLog(@"Content of the file: %@", [NSMutableString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error: nil]);
            
            // Load the FusionCharts js file...
            //ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: @"http://radar:8080/jasperserver-pro/fusion/charts/FusionCharts.js"]];
            //[request startSynchronous];
            
            //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			//NSString *documentsDirectory = [paths objectAtIndex:0];
            
            //[[request responseString] writeToFile: [documentsDirectory stringByAppendingPathComponent:@"FusionCharts.js"] atomically:TRUE encoding: NSUTF8StringEncoding error: nil];
                        
            [webView setScalesPageToFit:true];
            [webView setHidden:FALSE];
            [webView setDelegate:self];
			[webView loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath:path]]];
            [JSUILoadingView hideLoadingView];
		}
        [self updatePage];
        
	}
    
    
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}



- (void)setMaxMinZoomScalesForCurrentBounds:(UIScrollView *)sv page:(CGSize)pageSize
{
    CGSize boundsSize = self.view.frame.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width / pageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / pageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 3.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    sv.maximumZoomScale = maxScale;
    sv.minimumZoomScale = minScale;
}

-(void)requestFinished:(JSOperationResult *)res
{
	if (res == nil)
	{
		UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message:@"Error reading the response" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[uiView show];
	}
	else if ([res returnCode] != 0) {
		
		NSString *msg = [NSString stringWithFormat:@"Error executing the report: %@", [res message]];
		
		UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[uiView show];
	}
	else {
        //JSReportExecution *re = [res reportExecution];
	
		uuid  = [[res reportExecution] uuid];
        //NSString *reportUri  = [[res reportExecution] uri];
		pages = [[res reportExecution] totalPages];
		
		if (downloadQueue != nil)
		{
			[downloadQueue release];
			downloadQueue=nil;
		}
		
		
		if (pages > 0)
		{
			downloadQueue = [[NSMutableSet alloc] init];
			
			// download all the files...
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *cacheDirectory = [documentsDirectory stringByAppendingPathComponent:@"cache"];
			
			cacheDirectory = [cacheDirectory stringByAppendingPathComponent: [[res reportExecution] uuid]];
			
			NSFileManager *fileManager = [NSFileManager defaultManager];
			
			if (![fileManager fileExistsAtPath:cacheDirectory])
			{
				[fileManager createDirectoryAtPath:cacheDirectory withIntermediateDirectories: YES attributes: nil error:NULL];
			}
			
            
			for (int i=0; i< [[[res reportExecution] fileNames] count]; ++i)
			{
				NSString *fileName = [[[res reportExecution] fileNames] objectAtIndex: i];
				NSString *fileType = [[[res reportExecution] fileTypes] objectAtIndex: i];
                
				// We don't use cache here for now....
                NSString *extension = @""; // use default extension.,,
				if ( [fileType isEqualToString: @"text/html"])
				{
					extension = @".html";
				}
				else if ( [fileType isEqualToString: @"application/images"])
				{
					extension = @"";
				}
                else if ( [fileType isEqualToString: @"application/pdf"])
				{
					extension = @".pdf";
				}
				
				// the path to write file
				NSString *resourceFile = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@%@",fileName, extension]]; //self.descriptor.name
				
				[downloadQueue addObject:resourceFile];
				
				[[self client] reportFile: uuid andFilename: fileName toPath: resourceFile responseDelegate: self];  
			}
			
			if ([[[res reportExecution] fileNames] count] == 0)
			{
				UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message:@"The report had some problems..." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
				[uiView show];

			}
			else {
				return;
			}
		}
		else {
			UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message:@"The report is empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
			[uiView show];
		}


	}
	
	[JSUILoadingView hideLoadingView];
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	if (currentPage > 0)
	{
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(ctx, CGContextGetClipBoundingBox(ctx));
    CGContextTranslateCTM(ctx, 0.0, layer.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
	myPageRef = CGPDFDocumentGetPage(myDocumentRef, currentPage);	
	
    CGContextConcatCTM(ctx, CGPDFPageGetDrawingTransform(myPageRef, kCGPDFCropBox, layer.bounds, 0, true));
    CGContextDrawPDFPage(ctx, myPageRef);
	}
	else {
		[super drawLayer:layer inContext:ctx];
	}
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
		return myContentView;
}

-(IBAction)nextPage:(id)sender
{
	if (currentPage < pages)
	{
		currentPage++;
		[self updatePage];
	}
}

-(IBAction)prevPage:(id)sender
{
	if (currentPage > 1)
	{
		currentPage--;
		[self updatePage];
	}
}


-(IBAction)close:(id)sender
{
    [self.previousController dismissModalViewControllerAnimated:true];

    /*
	// change the UIViewController with some animation...
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationCurve:UIViewAnimationTransitionFlipFromLeft];
	
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView: self.view.window cache:YES];
	UIWindow *window = self.view.window;
	
	[self.view removeFromSuperview];
	[window addSubview:self.previousController.navigationController.view];
	[window makeKeyAndVisible];	
	[UIView commitAnimations];
	*/
	
}

-(void)updatePage
{
    
    if ([format isEqualToString:@"HTML"])
    {
        int scrollXPosition = [[webView stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] intValue];
        
        int documentPage = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.offsetHeight"] intValue];
        
        int pageSize = (int)((1.0 *documentPage)/(1.0 *pages));
        
        //int scrollBy = (currentPage-1)*pageSize + scrollPosition;
        
        //Scroll UIWebView to point
        [webView stringByEvaluatingJavaScriptFromString: [NSString  stringWithFormat:@"window.scrollTo(%d,%d);", scrollXPosition,(currentPage-1)*pageSize ] ];
            
    }
    
	// 1. read scroll position and scale...
	float zoomScale = scrollView.zoomScale;
	CGPoint offset = scrollView.contentOffset;
	
	[pagesButton setTitle: [NSString stringWithFormat:@"%d/%d",currentPage, pages]];

	myPageRef = CGPDFDocumentGetPage(myDocumentRef, currentPage);	
	CGRect pageRect = CGRectIntegral(CGPDFPageGetBoxRect(myPageRef, kCGPDFCropBox));
	
	UIView *oldPageView = myContentView;
	CATiledLayer *tiledLayer = [CATiledLayer layer];
	tiledLayer.delegate = self;
	tiledLayer.tileSize = CGSizeMake(1024.0, 1024.0);
	tiledLayer.levelsOfDetail = 1000;
	tiledLayer.levelsOfDetailBias = 1000;
	tiledLayer.frame = pageRect;
	
	pageRect.origin.x += 10;
	pageRect.size.width += 40;
	myContentView = [[UIView alloc] initWithFrame:pageRect];
	[myContentView.layer addSublayer:tiledLayer];
	 
	
	
	[scrollView addSubview:myContentView];
	
	if (oldPageView != nil)
	{
		[oldPageView removeFromSuperview];
		[oldPageView autorelease];
	}
	
	scrollView.contentOffset = offset;
	
	[scrollView setNeedsLayout];
	scrollView.zoomScale = zoomScale;

		
}

@end
