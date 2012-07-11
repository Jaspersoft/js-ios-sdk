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
//  JSUIRepositoryViewController.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSUIBaseRepositoryViewController.h"
#import "JSClient.h"
#import "JSUILoadingView.h"
#import "JSUtils.h"


@implementation JSUIBaseRepositoryViewController

@synthesize descriptor;
@synthesize client;
@synthesize resources;


#pragma mark -
#pragma mark View lifecycle


-(id)init
{
    self = [super init];
    resources = nil;    
    descriptor = nil;
    client = nil;
    
    return self;
}

- (void)viewDidLoad {
	
    
   	if (descriptor != nil)
	{
		resourecInfoButton = [[[UIBarButtonItem alloc]
                               initWithTitle: @"Info"
                               style: UIBarButtonItemStylePlain
                               target:self action:@selector(resourceInfoClicked:)] autorelease];
		
		self.navigationItem.rightBarButtonItem = resourecInfoButton;
	}
    
	[super viewDidLoad];	
}

-(IBAction)resourceInfoClicked:(id)sender {
	
	//if (descriptor != nil)
	//{
	//	ResourceViewController *rvc = [[ResourceViewController alloc] initWithNibName:@"ResourceViewController" bundle:nil];
	//	[rvc setDescriptor: descriptor];
	//	[self.navigationController pushViewController: rvc animated: YES];
	//}
    
}


-(void)requestFinished:(JSOperationResult *)res {
	
	
	
	if (res == nil)
	{
		UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message:@"Error reading the response" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[uiView show];
		//NSLog(@"Error reading response...");
	}
    else if ([res returnCode] > 400 || [res error] != nil)
    {
        NSMutableString *errorMsg = [NSMutableString stringWithFormat: @""];
 
        if ([[res message] length] > 0 )
        {
            [errorMsg appendFormat:@"%@\n",[res message]]; 
        }
        
        
        if ([res error])
        {
            [errorMsg appendFormat:@"%@\n", [[res error] localizedDescription]]; 
        }
        
        UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"Error reading the response" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[uiView show];
    }
	else {
		resources = [[NSMutableArray alloc] initWithCapacity:0];
		
		// Show resources....
		for (NSUInteger i=0; i < [[res resourceDescriptors] count]; ++i)
		{
			JSResourceDescriptor *rd = [[res resourceDescriptors] objectAtIndex:i];
			[resources addObject:rd];
		}
	}
	
	// Update the table...
	
	[[self tableView] beginUpdates];
	[[self tableView] reloadSections: [NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
	[[self tableView] endUpdates];
	
	[JSUILoadingView hideLoadingView];
    
	
}



- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setToolbarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}


-(void)clear {
    
	if (resources != nil) 
	{
		[resources release];
	
        resources = nil;

        [[self tableView] reloadData];

    }
    
    
	descriptor = nil;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	if (descriptor != nil)
	{
		[self performSelector:@selector(updateTableContent) withObject:nil afterDelay:0.0];
	}
	
}

-(void)refreshContent
{
    if (resources != nil)
	{
		[resources release];
        resources = nil;
    }
    
    
    
    [self updateTableContent];
}

-(void)updateTableContent {
    
	if (self.client == nil) return;
    
    if (![JSUtils checkNetwork: true client: self.client]) return;
    
    if (resources == nil)
	{
		NSString *uri = @"/";
		if ([self descriptor] != nil)
		{
			uri =  [descriptor uri];
			self.navigationItem.title=[NSString stringWithFormat:@"%@", [descriptor label]];
		}
		else
		{
			self.navigationItem.title=[NSString stringWithFormat:@"%@", [self.client.jsServerProfile alias] ];
		}
		// load this view...
		[JSUILoadingView showLoadingInView:self.view];
        
        [self.client resources:uri responseDelegate: self];  
		
	}
	
	
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
	
	if (resources != nil)
	{
		return [resources count];
	}
	
    return 0; // section is 0?
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    
	JSResourceDescriptor *rd = (JSResourceDescriptor *)[resources objectAtIndex: [indexPath indexAtPosition:1]];
	cell.textLabel.text =  [rd label];
	cell.detailTextLabel.text =  [rd uri];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
	
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	//JSResourceDescriptor *rd = [resources  objectAtIndex: [indexPath indexAtPosition:1]];
	
    // You can override this method to decide what to do in response of a selection. 
    
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


- (void)dealloc {

	if (descriptor != nil)
	{
		[descriptor release];
	}
	
	if (resources != nil)
	{
		[resources release];
	}
	
    [super dealloc];
}


@end

