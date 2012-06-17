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
//  ParametersListSelectorViewController.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 5/26/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSListSelectorViewController.h"
#import "JSResourceDescriptor.h"


@implementation JSListSelectorViewController
@synthesize singleSelection;
@synthesize selectionDelegate;
@synthesize mandatory;

#pragma mark -
#pragma mark View lifecycle


- (void) dealloc { 
	
	[selectedValues release]; 
	[values release]; 
	[super dealloc]; 
	
} 

- (void)viewWillDisappear:(BOOL)animated {
    
	if ([self.selectionDelegate respondsToSelector:@selector(setSelectedIndexes:)])
	{
		[self.selectionDelegate performSelector:@selector(setSelectedIndexes:) withObject: self.selectedValues];
	}	
	
	[super viewWillDisappear:animated];
	
}



-(id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
    
	self.selectionDelegate = nil;
	self.selectedValues = [NSMutableArray array];
	self.singleSelection = TRUE;
	mandatory = TRUE;
	
	return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return (CGFloat)0.f;
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (self.values != nil)
	{
		return [self.values count];
	}
	
    return 0; // section is 0?
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.selectionStyle = (self.singleSelection) ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
	
	id item = [self.values objectAtIndex:[indexPath row]];
	
	if ([item isKindOfClass: [NSString class]])
	{
		cell.textLabel.text = item;
	}
	else if ([item isKindOfClass:[JSListItem class]])
	{
		cell.textLabel.text = [(JSListItem *)item name];
	}
	
	if ([self.selectedValues containsObject:[NSNumber numberWithInt: [indexPath row]]])
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];		
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textColor = [UIColor blackColor];
	}

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
	
	if (cell.accessoryType == UITableViewCellAccessoryNone)
	{
		if (self.singleSelection)
		{
			//// Clear up all the others...
			[self.selectedValues removeAllObjects];
			[self.selectedValues addObject: [NSNumber numberWithInt: indexPath.row]];
			
			int rows = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
			for (int i=0; i< rows; ++i)
			{
				UITableViewCell *tmpCell = [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: i inSection: indexPath.section] ];
				tmpCell.accessoryType = UITableViewCellAccessoryNone;
				tmpCell.textLabel.textColor = [UIColor blackColor];
			}
			// Close the view...
			[self.navigationController popViewControllerAnimated:YES];
			return;
			
		}
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
		[self.selectedValues addObject: [NSNumber numberWithInt: indexPath.row]];
	}
	else {
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textColor = [UIColor blackColor];
		[self.selectedValues removeObject:[NSNumber numberWithInt: indexPath.row]];
	}
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

-(void)setValues:(NSArray *)vals
{
	[values autorelease];
	values = [vals retain];
	[[self tableView] reloadData];
}

-(NSArray *)values
{
	return values;
}


-(void)setSelectedValues:(NSMutableArray *)vals
{
	[selectedValues autorelease];
	selectedValues = [vals retain];
	[[self tableView] reloadData];
}


-(void)viewWillAppear:(BOOL)animated
{

	[self performSelector:@selector(ensureSelectionVisible) withObject:nil afterDelay:0]; 
}

// Be sure the first selected item is visible...
-(void)ensureSelectionVisible
{
	if (self.selectedValues != nil && self.selectedValues.count > 0)
	{
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[(NSNumber *)[self.selectedValues objectAtIndex:0] intValue]  inSection:0] atScrollPosition: UITableViewScrollPositionMiddle animated:YES];
	}
}




-(NSMutableArray *)selectedValues
{
	return selectedValues;
}


-(IBAction)unsetClicked:(id)sender
{
	self.selectedValues = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)setMandatory:(BOOL)b
{
	if (mandatory == b) return;
	
	mandatory = b;
	
	if (!mandatory)
	{
	    // Add the button...	
		UIBarButtonItem *unsetButton = [[[UIBarButtonItem alloc]
								  initWithTitle: @"Unset"
								  style: UIBarButtonItemStylePlain
								  target:self action:@selector(unsetClicked:)] autorelease];
		
		self.navigationItem.rightBarButtonItem = unsetButton;
	}
	else {
		// remove the unset button...
		self.navigationItem.rightBarButtonItem = nil;
	}
}

@end
