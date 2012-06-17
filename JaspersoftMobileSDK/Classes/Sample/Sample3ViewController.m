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
//  Sample3ViewController.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sample3ViewController.h"
#import "JSUIResourceViewController.h"


@implementation Sample3ViewController
@synthesize parentController;
@synthesize client;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)pickClicked:(id)sender
{
    // 1. Create a new resource picker
    JSUIResourcePicker *resourcePicker = [[JSUIResourcePicker alloc] initWithResourceType:JSUIResourcePickerTypeDefault];
    
    // 2. Set the client (the class which contains the server settings)
    [resourcePicker setClient: self.client];
    
    // 3. Set the delegated
    [resourcePicker setDelegate:self];
    
    // 4. Prepare a navigation controller to display the picker as modal view...
    UINavigationController *picker = [[UINavigationController alloc] initWithRootViewController:resourcePicker];
    
    // Push the new view
    [[self.parentController navigationController] presentModalViewController:picker animated: TRUE];
    
    // Force an update.
    [resourcePicker updateTableContent];
    
    [resourcePicker release];
    [picker release];
    
    // Once the user picks a resource, the callback resourcePicked (protocol JRUIResourcePickerDelefate) is invoked.

}


-(void)resourcePicked:(JSResourceDescriptor *)rd
{
    
    // Check the result...

    if (rd == nil) {
        UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message: @"No resource selected" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
        [uiView show];

    }
    else
    {
        // At this point we already have a resource descriptor thanks to the resource picked.
        // If we would like to get a resource descriptor without the use of the picker, we can
        // perform a call like:
        //
        // [client resourceInfo:@"/reports" responseDelegate: aDelegate];
        //
        // where aDelegate is a JSResponseDelegate. The response is provided in the requestFinished method.
        
        JSUIResourceViewController *resourceView = [[JSUIResourceViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        // Show the new view
        [resourceView setClient: self.client];
        [resourceView setDescriptor:rd];
        [[self navigationController] pushViewController: resourceView animated:TRUE];
        
    }
    
    
}


@end
