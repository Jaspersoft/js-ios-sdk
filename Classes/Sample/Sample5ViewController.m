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
//  Sample5ViewController.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sample5ViewController.h"


@implementation Sample5ViewController
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


-(IBAction)pickFolderClicked:(id)sender
{
    // 1. Create a new resource picker
    JSUIResourcePicker *folderPicker = [[JSUIResourcePicker alloc] initWithResourceType:JSUIResourcePickerTypeFolderOnly];
    
    // 2. Set the client (the class which contains the server settings)
    [folderPicker setClient: client];
    
    // 3. Set the delegated
    [folderPicker setDelegate:self];
    
    UINavigationController *picker = [[UINavigationController alloc] initWithRootViewController:folderPicker];
    
    // Push the new view
    [[self.parentController navigationController] presentModalViewController:picker animated: TRUE];
    
    // Force an update.
    [folderPicker updateTableContent];
    
    [folderPicker release];
    [picker release];
    
}

-(IBAction)pickImageClicked:(id)sender
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
	
	
	// Create a thumbnail version of the image for the recipe object.
	CGSize size = selectedImage.size;
	CGFloat ratio = 0;
	if (size.width > size.height) {
		ratio = 88.0 / size.width;
	} else {
		ratio = 88.0 / size.height;
	}
	CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
	
	UIGraphicsBeginImageContext(rect.size);
	[selectedImage drawInRect:rect];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	    
    [imageView setImage: img];
    
    // Resize the image to upload....
    if (size.width > size.height) {
		ratio = 640.0 / size.width;
	} else {
		ratio = 640.0 / size.height;
	}
    rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
    
    UIGraphicsBeginImageContext(rect.size);
	[selectedImage drawInRect:rect];
    if (imageToUpload != nil) [imageToUpload release];
	imageToUpload = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    [imageToUpload retain];
    
    [self dismissModalViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)resourcePicked:(JSResourceDescriptor *)rd
{
    
    if (rd != nil)
    {
        [parentFolderTextfield setText: [rd uri]];
    }
    
}

-(IBAction)uploadImageClicked:(id)sender
{
    NSString *parentFolder = [[parentFolderTextfield text] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    NSString *imageName = [[nameTextfield text] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 1. Prepare the descriptor for the folder...
    
        
    if (imageToUpload == nil)
    {
        UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message: @"Please select an image first"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
        [uiView show]; 
        return;
    }
    
    
    JSResourceDescriptor *rd = [[JSResourceDescriptor alloc] init];
    [rd setName: imageName];
    [rd setUri: [NSString stringWithFormat: @"%@/%@", parentFolder, imageName]];
    [rd setWsType: JS_TYPE_IMAGE];
    [rd setLabel: imageName];

    
    NSData *data = UIImagePNGRepresentation(imageToUpload);
    
    [statusLabel setText:@"Uploading, please wait..."];
    [self.client resourceCreate: parentFolder resourceDescriptor:rd data: data responseDelegate:self];
    
    
    
}

-(void)slideTextfieldUp:(BOOL)b
{
    
    [UIView beginAnimations:@"slide" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3f];
    self.view.frame = CGRectOffset(self.view.frame,0, 80 * ((b) ? -1 : 1));
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == nameTextfield)
    {
        [self slideTextfieldUp: YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == nameTextfield)
    {
        [self slideTextfieldUp: NO];
    }
}



-(void)requestFinished:(JSOperationResult *)op
{

    //[imageView setImage:nil];
    
    //[imageToUpload release];
    //imageToUpload = nil;
    
    [statusLabel setText:@" "];
    NSString *msg = nil;
    
    if (op != nil)
    {
        
        msg = [NSString stringWithFormat:@"Return code: %d\n%@", [op returnCode], [op message]];
        
    }
    else
    {
        msg = @"Operation failed...";
    }
    UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message: msg  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease];
    [uiView show];
    
}


@end
