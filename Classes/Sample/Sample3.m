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
//  Sample3.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sample3.h"
#import "JSUIResourceViewController.h"
#import "Sample3ViewController.h"


@implementation Sample3
@synthesize parentController;
@synthesize client;

+(void)runSample:(JSClient *)client parentViewController: (UIViewController *)controller
{
    Sample3ViewController *sample3ViewController = [[Sample3ViewController alloc] initWithNibName:@"Sample3ViewController" bundle: nil];
    
    [sample3ViewController setParentController: controller];
    [sample3ViewController setClient: client];
    
    
    [[controller navigationController] pushViewController:sample3ViewController animated:TRUE];
    
    
    
    //Sample3 *sample = [[[Sample3 alloc] init] autorelease];
    //[client resourceInfo:@"/reports" responseDelegate: sample];
}


-(void)requestFinished:(JSOperationResult *)op
{
    // This code shows how to handle a requestFinished response
    // in case of direct use of the [client resourceInfo...] call.
    
    if ([op returnCode] == 200)
    {
      
        JSUIResourceViewController *resourceView = [[JSUIResourceViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        [resourceView setClient: self.client];
        [resourceView setDescriptor:[[op resourceDescriptors] objectAtIndex:0]];
        [[parentController navigationController] pushViewController:resourceView animated:TRUE];
    }
    else
    {
        UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat: @"An error occurred while looking up for the requested resource (%d)", [op returnCode]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
        [uiView show];
             
    }
}


@end
