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
//  JSBooleanInputControlCell.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 5/28/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSBooleanInputControlCell.h"

#define JS_LBL_BOOLEAN_WIDTH                  200.0f
//#define JS_LBL_BOOLEAN_MANDATORY_WIDTH        240.0f

@implementation JSBooleanInputControlCell


- (id)initWithDescriptor:(JSResourceDescriptor *)rd tableViewController: (UITableViewController *)tv
{
	if (self = [super initWithDescriptor: rd tableViewController: tv])
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		//if ([[descriptor resourcePropertyValue:JS_PROP_INPUTCONTROL_TYPE withDefault: JS_IC_TYPE_BOOLEAN] isEqualToString:JS_IC_TYPE_BOOLEAN])  // IC_TYPE_BOOLEAN
		//{
		if (self.mandatory)
		{
			self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y, JS_LBL_BOOLEAN_WIDTH, self.nameLabel.frame.size.height);				
			self.accessoryType = UITableViewCellAccessoryNone;
			
			
			// Comment this portion if you want a simple checkmark style.
			// You would have to change the cellDidSelected code as well.
			if (!self.readonly)
			{
				switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(JS_CELL_PADDING + JS_CONTENT_PADDING + JS_LBL_BOOLEAN_WIDTH-15.0, 10.0, 
																	 JS_CELL_WIDTH - (2*JS_CELL_PADDING + JS_CONTENT_PADDING + JS_LBL_WIDTH)-JS_CONTENT_PADDING, 21.0)];
				[switchButton addTarget:self action: @selector(switchSelected) forControlEvents:UIControlEventValueChanged];
				[self addSubview:switchButton];
			}
			else {
				switchButton = nil;
			}

			self.selectedValue = @"false";
		}
		else {
			
			self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y, JS_LBL_BOOLEAN_WIDTH, self.nameLabel.frame.size.height);
			self.selectedValue = nil;
			label = [[UILabel alloc] initWithFrame:CGRectMake(
																	   JS_CELL_PADDING + JS_CONTENT_PADDING + JS_LBL_WIDTH, 10.0, 
																	   JS_CELL_WIDTH - (2*JS_CELL_PADDING + JS_CONTENT_PADDING + JS_LBL_WIDTH) - 20.0f, 21.0)];
			
			label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
			label.textAlignment = UITextAlignmentRight;
			label.tag = 100;
			label.font = [UIFont systemFontOfSize:14.0];
			label.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
			label.text = @"Not set";
			
			if (self.readonly)
			{
				label.frame = CGRectMake(246.0, 10.0, 53.0, 21.0);
			}
			else {
				
				self.selectionStyle = UITableViewCellSelectionStyleBlue;
				self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}	
			[self addSubview:label];
		}
	}
	
	return self;
}

-(void)dealloc
{
	[switchButton release];
	[label release];
	[super dealloc];
}


// Specifies if the user can select this cell
-(bool)selectable
{
	return !self.readonly;
}


// User touched the InputControl cell....
-(void)cellDidSelected
{
	if (self.readonly) return;
	
	if (self.mandatory)
	{
		// Nothing to do, since the UISwitch even is used instead.
		// The code below is useful to use a simple checkmark instead of the UISwith:
		
		//self.accessoryType =  (self.accessoryType == UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
		//self.selectedValue = (self.accessoryType == UITableViewCellAccessoryCheckmark) ? @"true" : @"false";
		
	}
	else {
		
		NSMutableArray *vals = [NSMutableArray arrayWithCapacity:3];
		[vals addObject:@"Not set"];
		[vals addObject:@"Yes"];
		[vals addObject:@"No"];
		
		NSMutableArray *selectedVals = [NSMutableArray arrayWithCapacity:1];
		if (self.selectedValue == nil) {
			[selectedVals addObject:[NSNumber numberWithInt:0]];
		}
		else if ([self.selectedValue isEqualToString:@"true"]) {
			[selectedVals addObject:[NSNumber numberWithInt:1]];
		}
		else {
			[selectedVals addObject:[NSNumber numberWithInt:2]];
		}
		
		JSListSelectorViewController *rvc = [[JSListSelectorViewController alloc] initWithStyle:UITableViewStyleGrouped];
		rvc.values  = vals;
		rvc.selectedValues = selectedVals;
		rvc.selectionDelegate = self;
		[self.tableViewController.navigationController pushViewController: rvc animated: YES];
		[rvc release];
	}
}


-(void)setSelectedValue:(id)vals
{
	if (self.mandatory)
	{
		BOOL sel = FALSE;
		if (vals != nil && [vals isKindOfClass:[NSString class]] && [vals isEqualToString:@"true"])
		{
			sel = TRUE;
		}
		
		[switchButton setSelected: sel];
		[super setSelectedValue: (sel) ? @"true" : @"false"];
		
	}
	else {
		
		[super setSelectedValue:vals];
	
		if (self.selectedValue == nil) {
			label.text = @"Not set";
		}
		else if ([self.selectedValue isEqualToString:@"true"]) {
			label.text = @"Yes";
		}
		else {
			label.text = @"No";
		}
	}
}



// This methos id invoked by the ListSelectorView, so we check the values only for the
// input control types which make sense.
-(void)setSelectedIndexes:(NSMutableArray *)indexes
{
	if ([[indexes objectAtIndex:0] intValue] == 0)
	{
		self.selectedValue = nil;
	}
	else if ([[indexes objectAtIndex:0] intValue] == 1) {
		self.selectedValue = @"true";
	}
	else {
		self.selectedValue = @"false";
	}
}

-(IBAction)switchSelected
{
	self.selectedValue = [switchButton isOn] ? @"true" : @"false";
}

@end
