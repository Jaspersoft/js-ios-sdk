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
//  JSTextInputControl.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 5/28/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSTextInputControlCell.h"
#define JS_LBL_TEXT_WIDTH                     160.0f

@implementation JSTextInputControlCell : JSInputControlCell

- (id)initWithDescriptor:(JSResourceDescriptor *)rd tableViewController: (UITableViewController *)tv
{
	if (self = [super initWithDescriptor: rd tableViewController: tv])
	{
		textField = [[UITextField alloc] initWithFrame:CGRectMake(JS_CELL_PADDING + JS_CONTENT_PADDING + JS_LBL_WIDTH, 10.0, 
																			   JS_CELL_WIDTH - (2*JS_CELL_PADDING + JS_CONTENT_PADDING + JS_LBL_WIDTH), 21.0)];
		textField.textAlignment = UITextAlignmentRight;
		textField.font = [UIFont systemFontOfSize:14.0];
		textField.delegate = self;
		textField.returnKeyType = UIReturnKeyDefault;
		textField.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
        textField.backgroundColor = [UIColor clearColor];
		[self addSubview:textField];
	}
	
	return self;
}

-(void)dealloc
{
	[textField release];
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

// Resign and look first for another field...
- (BOOL)textFieldShouldReturn:(UITextField *)txtField
{
	if (txtField.returnKeyType == UIReturnKeyNext) {
        NSIndexPath *indexPath = [self.tableViewController.tableView indexPathForCell:self];
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
        UITableViewCell *nextCell = [self.tableViewController.tableView cellForRowAtIndexPath:nextIndexPath];
        if (nextCell) {
            for (UIView *subview in [nextCell subviews]) {
                if ([subview isKindOfClass:[UITextField class]]) {
                    [subview becomeFirstResponder];
                    break;
                }
            }
        }
    }
	[textField resignFirstResponder];
	self.selectedValue = [txtField text];
	return NO;
}


-(void)setSelectedValue:(id)vals
{
	[super setSelectedValue:vals];
	textField.text = (self.selectedValue == nil) ? @"" : self.selectedValue;
	
}


-(void)cellDidSelected {

	[textField becomeFirstResponder];
}


@end
