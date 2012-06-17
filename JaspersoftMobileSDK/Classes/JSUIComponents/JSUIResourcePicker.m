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
//  JSUIResourcePicker.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSUIResourcePicker.h"


@implementation JSUIResourcePicker
@synthesize delegate;



-(id)initWithResourceType:(int)tp
{
    self = [super init];
    type = tp;
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                               target:self action:@selector(cancelPickClicked:)] autorelease];
		
    self.navigationItem.rightBarButtonItem = cancelButton;
	
}

-(IBAction)cancelPickClicked:(id)sender {
	
    [self.navigationController dismissModalViewControllerAnimated:TRUE];
	[self.delegate resourcePicked: nil];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	JSResourceDescriptor *rd = (JSResourceDescriptor *)[self.resources objectAtIndex: [indexPath indexAtPosition:1]];
	cell.textLabel.text =  [rd label];
	cell.detailTextLabel.text =  [rd uri];
    
    if ([[rd wsType] isEqualToString: JS_TYPE_FOLDER])
    {
        
        if (type == JSUIResourcePickerTypeResourcesOnly)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;		
        }
	}
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

 


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
    // If the resource selected is a folder, navigate in the folder....
	JSResourceDescriptor *rd = [self.resources  objectAtIndex: [indexPath indexAtPosition:1]];
	
	if (rd != nil)
	{	
        if (type == JSUIResourcePickerTypeResourcesOnly && [[rd wsType] isEqualToString: JS_TYPE_FOLDER])
        {
            JSUIResourcePicker *rvc = [[JSUIResourcePicker alloc] initWithNibName:nil bundle:nil];
            [rvc setClient: self.client];
            [rvc setDescriptor:rd];
            [rvc setDelegate:self.delegate];
            [self.navigationController pushViewController: rvc animated: YES];
            [rvc release];
        }
        else 
        {
            [self.navigationController dismissModalViewControllerAnimated:TRUE];
            [self.delegate resourcePicked:rd];
        }
	}
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    JSResourceDescriptor *rd = [self.resources  objectAtIndex: [indexPath indexAtPosition:1]];
    
    JSUIResourcePicker *rvc = [[JSUIResourcePicker alloc] initWithNibName:nil bundle:nil];
    [rvc setClient: self.client];
    [rvc setDescriptor:rd];
    [rvc setDelegate:self.delegate];
    [self.navigationController pushViewController: rvc animated: YES];
    [rvc release];
}





-(void)requestFinished:(JSOperationResult *)res {

	if (res == nil)
	{
		UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message:@"Error reading the response" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[uiView show];
		//NSLog(@"Error reading response...");
	}
	else {
		[self setResources: [[NSMutableArray alloc] initWithCapacity:0]];
		
        
        if (self.descriptor == nil && type == JSUIResourcePickerTypeFolderOnly)
        {
            JSResourceDescriptor *rootRd = [JSResourceDescriptor resourceDescriptor];
            [rootRd setName:@""];
            [rootRd setUri:@"/"];
            [rootRd setLabel:@"<root>"];
            [self.resources addObject: rootRd];
        }
        
		// Show resources....
		for (NSUInteger i=0; i < [[res resourceDescriptors] count]; ++i)
		{
			JSResourceDescriptor *rd = [[res resourceDescriptors] objectAtIndex:i];
            
            if (type == JSUIResourcePickerTypeFolderOnly)
            {
                if ([[rd wsType] isEqualToString: JS_TYPE_FOLDER])
                {
                    [self.resources addObject:rd];
                }
            }
            else
            {
                [self.resources addObject:rd];
            }
            
        }
	}
	
	// Update the table...
	
	[[self tableView] beginUpdates];
	[[self tableView] reloadSections: [NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
	[[self tableView] endUpdates];
	
    
    [JSUILoadingView hideLoadingView];
    
}


/*
 This would be the most logic way to get only folders from JasperReports Server, but there is currently
 a problem preventing it to work on the server side.
 
 -(void)updateTableContent {
 
 if (self.client == nil) return;
 
 if (resources == nil)
 {
 NSString *uri = @"/";
 if ([self descriptor] != nil)
 {
 uri =  [self.descriptor uri];
 self.navigationItem.title=[NSString stringWithFormat:@"%@", [self.descriptor label]];
 }
 else
 {
 self.navigationItem.title=[NSString stringWithFormat:@"%@", [self.client alias] ];
 }
 // load this view...
 if (busyView == nil)
 busyView = [JSUILoadingView loadingViewInView:[self.view.window.subviews objectAtIndex:0]];
 
 NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:1];
 [args setObject:@"folder" forKey:@"type"];
 //[args setObject:@"1" forKey:@"recursive"];
 
 [self.client resources: uri withArguments:args responseDelegate: self];  
 
 }
 
 }
 */

@end
