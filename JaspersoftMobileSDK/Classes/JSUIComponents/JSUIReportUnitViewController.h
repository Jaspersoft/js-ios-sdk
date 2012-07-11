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
//  ReportUnitViewController.h
//  Jaspersoft
//
//  Created by Giulio Toffoli on 6/7/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSClient.h"

#import <QuartzCore/QuartzCore.h>

@interface JSUIReportUnitViewController : UIViewController  <JSResponseDelegate, UIScrollViewDelegate, UIWebViewDelegate> {

	// Execution id
	NSString *uuid;
	NSInteger pages;
	NSInteger currentPage;
	
	NSMutableSet *downloadQueue;

	bool reportLoaded;
	
	IBOutlet UILabel *label;
	IBOutlet UIView  *backgroundView;
	
	
	// HTML viewer
	IBOutlet UIWebView *webView;
	
	// PDF viewer
	UIScrollView *scrollView;
	UIView *myContentView;
    CGPDFDocumentRef myDocumentRef;
    CGPDFPageRef myPageRef;
	IBOutlet UIToolbar *toolbar;
	IBOutlet UIBarButtonItem *pagesButton;

	
}
@property(retain, nonatomic) NSDictionary *parameters;
@property(retain, nonatomic) JSResourceDescriptor *descriptor;
@property(retain, nonatomic) JSClient *client;
@property(retain, nonatomic) UIViewController *previousController;
@property(retain, nonatomic) NSString *format;

-(IBAction)nextPage:(id)sender;
-(IBAction)prevPage:(id)sender;
-(IBAction)close:(id)sender;
-(void)updatePage;
- (void)setMaxMinZoomScalesForCurrentBounds:(UIScrollView *)scrollView page:(CGSize)pageSize;

@end
