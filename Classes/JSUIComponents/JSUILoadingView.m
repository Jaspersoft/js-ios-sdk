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
//  LoadingView.m
//  LoadingView
//
//  The code of this class derives from code created by Matt Gallagher on 12/04/09.
//  Copyright Matt Gallagher 2009. All rights reserved.
// 
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "JSUILoadingView.h"
#import <QuartzCore/QuartzCore.h>


//
// NewPathWithRoundRect
//
// Creates a CGPathRect with a round rect of the given radius.
//
CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
	//
	// Create the boundary path
	//
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + rect.size.height - cornerRadius);

	// Top left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y,
		rect.origin.x + rect.size.width,
		rect.origin.y,
		cornerRadius);

	// Top right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height,
		cornerRadius);

	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		rect.origin.y + rect.size.height,
		cornerRadius);

	// Bottom left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		rect.origin.y,
		cornerRadius);

	// Close the path at the rounded rect
	CGPathCloseSubpath(path);
	
	return path;
}

@implementation JSUILoadingView

static JSUILoadingView *sharedInstance = nil;


+(void)showLoadingInView:(UIView *)view
{
    if (sharedInstance != nil) return;
    
    sharedInstance = [[JSUILoadingView alloc] initWithFrame:view.window.bounds];
    [sharedInstance showInView: view.window];    
}

+(void)hideLoadingView
{
    
    if (sharedInstance == nil) return;
    [sharedInstance removeView];
    [sharedInstance release];
    sharedInstance = nil;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.opaque = NO;
	self.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
    
	const CGFloat DEFAULT_LABEL_WIDTH = 280.0;
	const CGFloat DEFAULT_LABEL_HEIGHT = 50.0;
	CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
	UILabel *loadingLabel =
    [[[UILabel alloc]
      initWithFrame:labelFrame]
     autorelease];
	loadingLabel.text = NSLocalizedString(@"Loading...", nil);
	loadingLabel.textColor = [UIColor whiteColor];
	loadingLabel.backgroundColor = [UIColor clearColor];
	loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	loadingLabel.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
	
	[self addSubview:loadingLabel];
	UIActivityIndicatorView *activityIndicatorView =
    [[[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]
     autorelease];
	[self addSubview:activityIndicatorView];
	activityIndicatorView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicatorView startAnimating];
	
	CGFloat totalHeight =
    loadingLabel.frame.size.height +
    activityIndicatorView.frame.size.height;
	labelFrame.origin.x = floor(0.5 * (frame.size.width - DEFAULT_LABEL_WIDTH));
	labelFrame.origin.y = floor(0.5 * (frame.size.height - totalHeight));
	loadingLabel.frame = labelFrame;
	
	CGRect activityIndicatorRect = activityIndicatorView.frame;
	activityIndicatorRect.origin.x =
    0.5 * (frame.size.width - activityIndicatorRect.size.width);
	activityIndicatorRect.origin.y =
    loadingLabel.frame.origin.y + loadingLabel.frame.size.height;
	activityIndicatorView.frame = activityIndicatorRect;
    
	return self;

}

-(void)showInView:(UIView *)view
{
    [view addSubview:self];
    
	// Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
    
	[[view layer] addAnimation:animation forKey:@"layerAnimation"];
}

//
// removeView
//
// Animates the view out from the superview. As the view is removed from the
// superview, it will be released.
//
- (void)removeView
{

	[self removeFromSuperview];

	// Set up the animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	
	[[self.window layer] addAnimation:animation forKey:@"layerAnimation"];
}

//
// drawRect:
//
// Draw the view.
//
- (void)drawRect:(CGRect)rect
{
	
	// Center the rectanlge...
	
	rect.origin.y = rect.origin.y + (rect.size.height-150)/2;
	rect.size.height = 150;
	//rect.size.height -= 1;
	rect.size.width -= 1;
	
	const CGFloat RECT_PADDING = 8.0;
	rect = CGRectInset(rect, RECT_PADDING, RECT_PADDING);
	
	const CGFloat ROUND_RECT_CORNER_RADIUS = 5.0;
	CGPathRef roundRectPath = NewPathWithRoundRect(rect, ROUND_RECT_CORNER_RADIUS);
	
	CGContextRef context = UIGraphicsGetCurrentContext();

	const CGFloat BACKGROUND_OPACITY = 0.75;
	CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextFillPath(context);

	const CGFloat STROKE_OPACITY = 0.25;
	CGContextSetRGBStrokeColor(context, 1, 1, 1, STROKE_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextStrokePath(context);
	
	CGPathRelease(roundRectPath);
}

//
// dealloc
//
// Release instance memory.
//
- (void)dealloc
{
    [super dealloc];
}

@end
