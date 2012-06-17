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
//  Sample4ViewController.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sample6ViewController.h"


@implementation Sample6ViewController
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

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


-(IBAction)pickResourceClicked:(id)sender
{
    // 1. Create a new resource picker
    JSUIResourcePicker *resourcePicker = [[JSUIResourcePicker alloc] initWithResourceType:JSUIResourcePickerTypeAllResources];
    
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
        UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message: @"No object to delete selected" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
        [uiView show];
        
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"Are you sure you want to delete the object: %@?", [rd uri]];
        resourceToDelete = rd;
        [resourceToDelete retain];
        
        UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message: msg delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil] autorelease];
        [uiView show];        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        
        [self.client resourceDelete: [resourceToDelete uri] responseDelegate:self];
    }
    
    [resourceToDelete release];
}

-(void)requestFinished:(JSOperationResult *)op
{
    
    NSString *msg = nil;
    
    if (op != nil)
    {
        
        msg = [NSString stringWithFormat:@"Return code: %d\n%@", [op returnCode], [op message]];
        
        if ([op returnCode] == 200)
        {
            msg = @"Object deleted!";
        }
        
    }
    else
    {
        msg = @"Operation failed...";
    }
    UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message: msg  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
    [uiView show];
    
}


@end
