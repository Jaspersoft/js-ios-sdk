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
//  ServersViewController.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 4/11/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "ServersViewController.h"
#import "JSClient.h"
#import "JaspersoftAppDelegate.h"


@implementation ServersViewController


#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
	
	[[self tableView] setAllowsSelectionDuringEditing: YES];
	self.title = @"Servers";
	
	editDoneButton = [[[UIBarButtonItem alloc] initWithTitle: @"Edit"
					   style: UIBarButtonItemStylePlain
					   target:self action:@selector(editClicked:)] autorelease];
	
	editMode = false;
	self.navigationItem.rightBarButtonItem = editDoneButton;
	
	if ([[[JaspersoftAppDelegate sharedInstance] servers] count] == 0)
	{
		[self editClient:nil];
	}
	
    UIBarButtonItem *infoButton = [[[UIBarButtonItem alloc] initWithTitle: @"Info"
                                      style: UIBarButtonItemStylePlain
                                      target:self action:@selector(infoClicked:)] autorelease];
    
    
	self.navigationItem.rightBarButtonItem = editDoneButton;
    self.navigationItem.leftBarButtonItem = infoButton;
    
	[super viewDidLoad];	
}

-(void)editClicked:(id)sender {
	
	editDoneButton.title = @"Done";
	editDoneButton.action = @selector(doneClicked:);
	editMode = true;
	
	
	[[self tableView] beginUpdates];
	[[self tableView] reloadSections: [NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
	[[self tableView] endUpdates];
	
	[[self tableView] setEditing:true animated:YES];
    
    
    if ([[[JaspersoftAppDelegate sharedInstance] servers] count] == 0)
    {
        // Run the view to configure something...
        ServerSettingsViewController *vc  = [[ServerSettingsViewController alloc] initWithNibName: @"ServerSettingsViewController" bundle:nil];
        vc.previousViewController = self;
        [self.navigationController pushViewController: vc animated: YES];
        [vc release];	 
    }
    
}

-(void)infoClicked:(id)sender {
	
	
    UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message: @"Jaspersoft Mobile v.1.1\n\nManagement tool and report viewer for JasperReports Server 4.2.0 and greater.\n\nFor more information visit:\nwww.jasperforge.org/projects/mobile\n\n(c) 2011-2012 Jaspersoft Corp." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
    [uiView show];
    
    
}


-(void)doneClicked:(id)sender {
	
	editDoneButton.title = @"Edit";
	editDoneButton.action = @selector(editClicked:);
	editMode = false;
	
	[[self tableView] setEditing:false animated:YES];
	
	[[self tableView] beginUpdates];
	[[self tableView] reloadSections: [NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
	[[self tableView] endUpdates];
	
}


 

 - (void)viewDidAppear:(BOOL)animated {
	 [super viewDidAppear:animated];	 
}


/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
	return @"JasperReports Server accounts";
		
}


// Customize the number of rows in the table view.
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (!editMode)
    {
        NSInteger serversCount = [[[JaspersoftAppDelegate sharedInstance] servers] count];
        
        if (serversCount == 1)
        {
            JSClient *client = [[[JaspersoftAppDelegate sharedInstance] servers] objectAtIndex:0];
            if ([client.alias isEqualToString:@"Jaspersoft Mobile Demo"])
            {
                return @"\n\nYou can add and configure your own server by tapping Edit, or you can select the demo server provided by Jaspersoft to quickly try out how the app works.";
            }
        }
        else if (serversCount == 0)
        {
            return @"Please add and configure a JasperReports Server account by tapping Edit.";
        }
    }
    
    return NULL;
}


// Customize the number of rows in the table view.
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	return (CGFloat)35.f;
//}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (editMode)
		return [[[JaspersoftAppDelegate sharedInstance] servers] count] + 1; // section is 0?
	
	return [[[JaspersoftAppDelegate sharedInstance] servers] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	static NSString *CellAddAccount = @"AddAccount";
    
	if ([indexPath indexAtPosition: 1] >= [[[JaspersoftAppDelegate sharedInstance] servers] count])
	{
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellAddAccount];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellAddAccount] autorelease];
		}
		cell.textLabel.text = @"New server account...";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
	}
	
	if (editMode)
	{
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
			}
			
			// Configure the cell.
			JSClient *client = [[[JaspersoftAppDelegate sharedInstance] servers] objectAtIndex:[indexPath indexAtPosition:1]];
			cell.textLabel.text = client.alias;
			cell.detailTextLabel.text = client.baseUrl;
			cell.accessoryType = UITableViewCellAccessoryNone;
			return cell;
	}
	else {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// Configure the cell.
		JSClient *client = [[[JaspersoftAppDelegate sharedInstance] servers] objectAtIndex:[indexPath indexAtPosition:1]];
		cell.textLabel.text = client.alias;
		cell.detailTextLabel.text = client.baseUrl;
		cell.accessoryType = UITableViewCellAccessoryNone;
		return cell;
	}

    
}



 // Override to support conditional editing of the table view.
 - (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
 
	 if (editMode == YES && [indexPath indexAtPosition: 1] < [[[JaspersoftAppDelegate sharedInstance] servers] count])
	 {
		return UITableViewCellEditingStyleDelete;
	 }
	 return UITableViewCellEditingStyleNone;
 }
 



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
	 if (editMode)
	 {
		 if (editingStyle == UITableViewCellEditingStyleDelete) {
			 // Delete the row from the data source.
			 JSClient *client = [[[JaspersoftAppDelegate sharedInstance] servers] objectAtIndex:[indexPath indexAtPosition:1]];
			 NSInteger index = [[[JaspersoftAppDelegate sharedInstance] servers] indexOfObject:client];
			 if (index >= 0)
			 {
				 [[[JaspersoftAppDelegate sharedInstance] servers] removeObjectAtIndex:index];
				 [[JaspersoftAppDelegate sharedInstance] saveServers];
			 }
			 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
             
             // If the client is currently in use... remove it...
             [[JaspersoftAppDelegate sharedInstance] setClient: nil];
             
		 }
	 }
 }



/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	JSClient *client = nil;
	if ([indexPath indexAtPosition: 1] < [[[JaspersoftAppDelegate sharedInstance] servers] count])
	{
		// Get the info of this client....
		client = [[[JaspersoftAppDelegate sharedInstance] servers] objectAtIndex:[indexPath indexAtPosition:1]];
	}
	
	if (!editMode)
	{
		if (client == nil) return;
		// pick a server and come back...
		[[JaspersoftAppDelegate sharedInstance] setClient:client];
		[[JaspersoftAppDelegate sharedInstance] configureServersDone:self];
		return;
	}
	
	[self editClient: client];
	
}
		 
-(void)editClient:(JSClient *)client
{
	ServerSettingsViewController *vc  = [[ServerSettingsViewController alloc] initWithNibName: @"ServerSettingsViewController" bundle:nil];
	vc.client = client;
	vc.previousViewController = self;
	[self.navigationController pushViewController: vc animated: YES];
	[vc release];	 
}


-(void)addServer:(JSClient *)client
{
	[[[JaspersoftAppDelegate sharedInstance] servers] addObject:client];
	[[JaspersoftAppDelegate sharedInstance] saveServers];
	
    [[self tableView] beginUpdates];
	[[self tableView] reloadSections: [NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
	[[self tableView] endUpdates];
}

-(void)updateServer:(JSClient *)client
{
	[[JaspersoftAppDelegate sharedInstance] saveServers];
	[[self tableView] beginUpdates];
	[[self tableView] reloadSections: [NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
	[[self tableView] endUpdates];
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
    [super dealloc];
}

@end
