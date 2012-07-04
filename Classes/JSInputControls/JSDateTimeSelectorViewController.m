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

#import "JSDateTimeSelectorViewController.h"

#define DATE_SECTION    0
#define TIME_SECTION    1

@implementation JSDateTimeSelectorViewController
@synthesize selectedValue;
@synthesize dateOnly;
@synthesize mandatory;
@synthesize selectionDelegate;



#pragma mark -
#pragma mark View lifecycle


- (void) dealloc { 
	
	[predefinedDates release]; 
	[predefinedDateLabels release]; 
	[selectedValue release];
	[datePickerView autorelease];
	[super dealloc]; 
	
} 


- (void)viewWillDisappear:(BOOL)animated {
    
	if ([self.selectionDelegate respondsToSelector:@selector(setSelectedValue:)])
	{
		[self.selectionDelegate performSelector:@selector(setSelectedValue:) withObject: self.selectedValue];
	}	
	
	[super viewWillDisappear:animated];
	
}


-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    selectionDelegate = nil;
    dateOnly = TRUE;
    mandatory = TRUE;
    
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *prevMonth = [gregorian dateByAddingComponents:components toDate:today options:0];
    
    components.month = -3;
    NSDate *prev3Month = [gregorian dateByAddingComponents:components toDate:today options:0];
    [components release];
    
    
    [gregorian release];
    
    
    predefinedDates = [[NSArray arrayWithObjects: today, prevMonth, prev3Month, nil] retain];
    predefinedDateLabels = [[NSArray arrayWithObjects: @"Today", @"A month ago", @"3 months ago", nil] retain];
    //predefinedDates = [[NSArray array] retain];
    //predefinedDateLabels = [[NSArray array] retain];
    
    
    
    self.selectedValue = today;

    return self;
}


// Customize the number of rows in the table view.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if (section == DATE_SECTION) return @"Date";
	if (section == TIME_SECTION && !self.dateOnly) return @"Time";
	return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return (CGFloat)22.f;
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (section == DATE_SECTION) return predefinedDates.count + 1;
	if (section == TIME_SECTION) return self.dateOnly ? 0 : 1;
	return 1; // Time section
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nil"];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if (indexPath.section == DATE_SECTION)
	{
			if (indexPath.row < predefinedDates.count)
			{
				cell.textLabel.text = [predefinedDateLabels objectAtIndex:[indexPath row]];
				if (selectedValue != nil)
				{
					if ([self isDateEqual:selectedValue to: [predefinedDates objectAtIndex:[indexPath row]]])
					{
						cell.accessoryType = UITableViewCellAccessoryCheckmark;
						cell.textLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
					}
				}
			}
		    else {
				
				NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
				[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
				[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
				
				cell.textLabel.text = [dateFormatter stringFromDate: self.selectedValue == nil ? [NSDate date] : self.selectedValue];
				
				BOOL found = NO;
				for (int i=0; i< predefinedDates.count; ++i)
				{
					// Same date?
					if ([self isDateEqual:selectedValue to: [predefinedDates objectAtIndex:i]])
					{
						found = TRUE;
						break;
					}
				}
						 
				if (!found)
				{
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
					cell.textLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
				}
			}
	}
	else if (indexPath.section == TIME_SECTION)
	{
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterNoStyle];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		
		cell.textLabel.text = [dateFormatter stringFromDate: self.selectedValue == nil ? [NSDate date] : self.selectedValue];
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
	
	if (indexPath.section == DATE_SECTION)
	{
		// Clear up selection...
		int rows = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
		for (int i=0; i< rows; ++i)
		{
			UITableViewCell *tmpCell = [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: i inSection: indexPath.section] ];
			tmpCell.accessoryType = UITableViewCellAccessoryNone;
			tmpCell.textLabel.textColor = [UIColor blackColor];
		}
		if (indexPath.row < predefinedDates.count)
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			cell.textLabel.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
			self.selectedValue = [predefinedDates objectAtIndex: indexPath.row ];
		}
		else {
			//Setting date....
			if (datePickerView == nil) // allocate if it's the first use...
			{
				datePickerView = [[JSDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-44-20)]; //Screen Height - NavigationBar - StatusBar
				datePickerView.delegate = self;
			}
			
			datePickerView.tag = 1;
			datePickerView.pickerMode = UIDatePickerModeDate;
			CGFloat location = cell.frame.origin.y;
			
			//NSLog(@"Cell origin: %f", location-44.0-20.0);
			[datePickerView showDatePicker:YES atLocation: location +44 + 20 withDate: self.selectedValue == nil ? [NSDate date] : self.selectedValue];
			
		}

	}
	else if (indexPath.section == TIME_SECTION)
	{
		// Clear up selection...
		if (datePickerView == nil) // allocate if it's the first use...
		{
			datePickerView = [[JSDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-44-20)]; //Screen Height - NavigationBar - StatusBar
			datePickerView.delegate = self;
		}
		
		datePickerView.tag = 2;
		datePickerView.pickerMode = UIDatePickerModeTime;
		CGFloat location = cell.frame.origin.y;
		
		[datePickerView showDatePicker:YES atLocation: location +44 + 20 withDate: self.selectedValue == nil ? [NSDate date] : self.selectedValue];
	}
	
}


- (void)dateChanged:(NSDate *)newDate tag:(NSInteger)tag;
{
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	
	NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:selectedValue];
	NSDateComponents *newComponents = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:newDate];
	
	
	
	if (tag == 1)
	{
		// Change only the date portion of the current value...
		components.year = newComponents.year;
		components.month = newComponents.month;
		components.day = newComponents.day;
		
	}
	else if (tag == 2)
	{
		// Change only the date portion of the current value...
		components.hour = newComponents.hour;
		components.minute = newComponents.minute;
	}
	
	self.selectedValue = [gregorian dateFromComponents: components];
	[gregorian release];
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

-(void)setDateOnly:(BOOL)b
{
	dateOnly = b;
	[[self tableView] reloadData];
}

-(void)setSelectedValue:(NSDate *)dt
{
	[selectedValue autorelease];
	if (dt == nil)
	{
		selectedValue = [[NSDate date] retain];
	}
	else
	{
		selectedValue = [dt retain];
	}
	[[self tableView] reloadData];
}

-(BOOL)isDateEqual:(NSDate *)dt1 to:(NSDate *)dt2
{

	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dt1Cmp = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:dt1];
	NSDateComponents *dt2Cmp = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:dt2];
	[gregorian release];
	
	if ( [dt1Cmp day]   == [dt2Cmp day] &&	[dt1Cmp month] == [dt2Cmp month] && [dt1Cmp year]  == [dt2Cmp year])
	{
		return YES;
	}
	return NO;
	
}

-(IBAction)unsetClicked:(id)sender
{
	selectedValue = nil;
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
