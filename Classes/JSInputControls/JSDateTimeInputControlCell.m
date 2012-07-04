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
//  JSDateTimeInputControl.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 5/28/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSDateTimeInputControlCell.h"
#import "JSDateTimeSelectorViewController.h"

#define JS_LBL_TEXT_WIDTH	160.0f

@implementation JSDateTimeInputControlCell

- (id)initWithDescriptor:(JSResourceDescriptor *)rd tableViewController: (UITableViewController *)tv
{
	if (self = [super initWithDescriptor: rd tableViewController: tv])
	{
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
		height = 61.0f;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(JS_CELL_PADDING + JS_CONTENT_PADDING + JS_LBL_WIDTH, 10.0, 
																   JS_CELL_WIDTH - (2*JS_CELL_PADDING + JS_CONTENT_PADDING + JS_LBL_WIDTH)-20.0f, 22.0)];
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
		label.tag = 100;
		label.textAlignment = UITextAlignmentRight;
		label.font = [UIFont systemFontOfSize:14.0];
		label.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
		label.text = @"Not set";
		label.numberOfLines = 2;
        label.backgroundColor = [UIColor clearColor];
		//label.layer.borderColor = [UIColor blackColor].CGColor;
		//label.layer.borderWidth = 1.0f;
		if (!self.readonly) self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[self addSubview: label];

	}
	
	return self;
}

-(void)dealloc
{
	[label release];
	[super dealloc];
}

// Specifies if the user can select this cell
-(bool)selectable
{
	return !self.readonly;
}


// Override the createNameLabel to adjust the label size...
-(void)createNameLabel
{
	[super createNameLabel];
	
	// Adjust the label size...
	self.nameLabel.autoresizingMask = UIViewAutoresizingNone;
	CGRect rect = self.nameLabel.frame;
	rect.size.width = JS_LBL_TEXT_WIDTH;
	self.nameLabel.frame = rect;
}

-(void)setSelectedValue:(id)vals
{
	[super setSelectedValue:vals];
	
	if (self.selectedValue == nil)
	{
		label.text = @"Not set";
	}
	else {
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		NSString *date = [dateFormatter stringFromDate: self.selectedValue];
		
		[dateFormatter setDateStyle:NSDateFormatterNoStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		NSString *time = [dateFormatter stringFromDate: self.selectedValue];
		//label.numberOfLines = 2;
		label.text = [NSString stringWithFormat:@"%@\n%@",date,time];
		
	}
}

-(void)cellDidSelected
{

	JSDateTimeSelectorViewController *rvc = [[JSDateTimeSelectorViewController alloc] initWithStyle:UITableViewStyleGrouped];
	rvc.selectionDelegate = self;
	rvc.dateOnly = NO;
	rvc.mandatory = self.mandatory;
	rvc.selectedValue = self.selectedValue;
	[self.tableViewController.navigationController pushViewController: rvc animated: YES];
	[rvc release];
	
}


@end
