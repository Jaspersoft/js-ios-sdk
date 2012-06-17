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


#import "JSDatePickerView.h"



@implementation JSDatePickerView

@synthesize delegate;
@synthesize datePickerView;
@synthesize datePicker;
@synthesize pickerMode;
@synthesize date;
@synthesize tag;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		
		self.pickerMode = UIDatePickerModeDate;
        self.datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 260.0)]; //frame.size.height - DATE_PICKER_HEIGHT
		self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44, 320.0, 216.0)];
		[self.datePicker setDatePickerMode:UIDatePickerModeDate];
		[self.datePickerView addSubview:self.datePicker];
		
		
		pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		pickerToolbar.barStyle=UIBarStyleBlackTranslucent;
		[pickerToolbar sizeToFit];
		
		NSMutableArray *barItems = [[NSMutableArray alloc] init];   
		UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDatePicker)];
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDatePicker)];
		[barItems addObject:cancelButton];
		[barItems addObject:flexSpace];
		[barItems addObject:doneButton];
		[doneButton release];
		[cancelButton release];
		[flexSpace release];
		
		[pickerToolbar setItems:barItems animated:YES];       
		[self.datePickerView addSubview:pickerToolbar];
		
		self.date = [NSDate date];

		[self addSubview:self.datePickerView];
	}
	
    return self;
}

-(IBAction)cancelDatePicker
{
	[self showDatePicker:NO atLocation: 0];
}

-(IBAction)doneDatePicker
{
	[self showDatePicker:NO atLocation: 0];
	[self.delegate dateChanged: [self.datePicker date] tag: self.tag];
}

- (void)showDatePicker:(BOOL)show atLocation:(CGFloat)loc {
	[self showDatePicker:show atLocation:loc withDate: [NSDate date]];
}

- (void)showDatePicker:(BOOL)show atLocation:(CGFloat)loc withDate:(NSDate *)dt {
	CGRect screenRect = self.frame;
	CGSize pickerSize = [self.datePickerView sizeThatFits:CGSizeZero];
	
	self.date = dt;
	
	// The parent view should be modified to present the top border of the datepicker at location loc.
	CGFloat offset = 260.0f - loc; // 260 is the position of the top border of the picker...
	if (offset < 0) offset = 0;
	
	CGRect endRectBackFrame =  CGRectMake(self.delegate.view.frame.origin.x, self.delegate.view.frame.origin.y, self.delegate.view.frame.size.width, self.delegate.view.frame.size.height);
	
	if (!show) {
		offset = -endRectBackFrame.origin.y;
	}
	
	CGRect startRect = CGRectMake(0.0,
								  screenRect.origin.y + screenRect.size.height,
								  pickerSize.width, pickerSize.height);
	
	CGRect pickerRect = CGRectMake(0.0,
								   screenRect.origin.y + screenRect.size.height - pickerSize.height,
								   pickerSize.width,
								   pickerSize.height);
	
	self.datePickerView.frame = pickerRect;
	
	if ( show ) {
        self.datePickerView.frame = startRect;
		[[[self.delegate view] superview] addSubview: self];
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	
	if ( show ) {
		self.datePickerView.frame = pickerRect;
		[[self.delegate tableView] setFrame: endRectBackFrame];
		[[self.delegate tableView] setContentOffset: CGPointMake(0, offset)];
		self.datePicker.date = self.date;
		self.datePicker.datePickerMode = self.pickerMode;
		
	} else {
		[UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
		self.datePickerView.frame = startRect;
		[[self.delegate tableView] setContentOffset: CGPointMake(0, 0)];
		
	}
	
	[UIView commitAnimations];	
}

- (void)slideDownDidStop {
	[self removeFromSuperview];
}

- (void)dealloc {
	[datePicker release];
	[datePickerView release];
	[date release];
	
    [super dealloc];
}




@end
