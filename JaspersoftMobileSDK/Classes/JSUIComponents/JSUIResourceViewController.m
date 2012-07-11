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
//  ResourceVireController.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 4/27/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSUIResourceViewController.h"
#import "JSUIResourcePreviewController.h"
#import "JSUILoadingView.h"
#import "JSUIRepositoryViewController.h"


@implementation JSUIResourceViewController

@synthesize descriptor, client;
@synthesize nameCell, labelCell, descriptionCell, typeCell, previewCell;
@synthesize toolsCell;

#pragma mark -
#pragma mark View lifecycle

#define CONST_Cell_height 44.0f
#define CONST_Cell_Content_width 200.0f
#define CONST_Cell_Label_width 200.0f
#define CONST_Cell_width 280.0f


#define CONST_labelFontSize    12
#define CONST_detailFontSize   15

#define COMMON_SECTION      0
#define TOOLS_SECTION       1
#define PROPERTIES_SECTION  2
#define RESOURCES_SECTION   3

static UIFont *labelFont;
static UIFont *detailFont;




- (void)viewDidLoad {
	
	if (descriptor != nil)
	{
		self.title = [descriptor label];
	}	
	[super viewDidLoad];	
}

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    descriptor = nil;
    resourceLoaded = NO;
    client = nil;
    deleting = false;

	return self;
	
}



-(void)requestFinished:(JSOperationResult *)res {
	
	
    if (deleting) {
        
        NSLog(@"Resource deleted %@", res);
        [JSUILoadingView hideLoadingView];
        
        if (res == nil)
        {
            UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message:@"Error deleting the resource" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
            [uiView show];
            return;
        }
        else {
            
            // close this view and refresh the parent view...
            [self resourceDeleted];
        }
        
        
    }
    
    if (res == nil)
	{
		UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message:@"Error reading the response" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[uiView show];
		//NSLog(@"Error reading response...");
	}
    else if ([res returnCode] > 400)
    {
        UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message:@"Error reading the response" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[uiView show];
    }
	else {
		
        if ([[res resourceDescriptors] count] > 0)
		{
				descriptor = [[res resourceDescriptors] objectAtIndex:0];
		}
	}
	
	// Update the table...
	resourceLoaded = true;
	[[self tableView] reloadData];
	
    [JSUILoadingView hideLoadingView];
    
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	if (descriptor != nil)
	{
		[self performSelector:@selector(updateTableContent) withObject:nil afterDelay:0.0];
	}
	
}

-(void)updateTableContent {
	
	if (client == nil) return;
	
	if ([self descriptor] != nil)
	{
		self.navigationItem.title=[NSString stringWithFormat:@"%@", [descriptor label]];
		
		
		// load this view...
		[JSUILoadingView showLoadingInView:self.view];
		
		[client resourceInfo:[descriptor uri] responseDelegate: self];  
	}
		
}


- (UIFont*) LabelFont;
{
	if (!labelFont) labelFont = [UIFont boldSystemFontOfSize:CONST_labelFontSize];
	return labelFont;
}

- (UIFont*) DetailFont;
{
	if (!detailFont) detailFont = [UIFont systemFontOfSize:CONST_detailFontSize];
	return detailFont;
}

- (UITableViewCell*) createCell :(NSString*)cellIdentifier
{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
													reuseIdentifier:cellIdentifier] autorelease];
	
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.font = [self LabelFont];
	
	cell.detailTextLabel.numberOfLines = 0;
	cell.detailTextLabel.font = [self DetailFont];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}


- (int) heightOfCellWithText :(NSString*)text
{
	CGSize size = {0, 0};
	
	if (text && ![text isEqualToString:@""]) 
		size = [text sizeWithFont:[self DetailFont] 
						  constrainedToSize:CGSizeMake(CONST_Cell_Label_width, 4000) 
							  lineBreakMode:UILineBreakModeWordWrap];
	
	size.height += 10;
	return (size.height < CONST_Cell_height ? CONST_Cell_height : size.height);

}

- (int) heightOfPropertyCellWithLabel: (NSString*)label andText:(NSString*)text
{
	CGSize size = {0, 0};
	CGSize sizeLabel = {0, 0};

	if (label && ![label isEqualToString:@""]) 
		sizeLabel = [text sizeWithFont:[self LabelFont] 
				constrainedToSize:CGSizeMake(CONST_Cell_width, 4000) 
					lineBreakMode:UILineBreakModeCharacterWrap];

	
	if (text && ![text isEqualToString:@""]) 
		size = [text sizeWithFont:[self DetailFont] 
				constrainedToSize:CGSizeMake(CONST_Cell_width, 4000) 
					lineBreakMode:UILineBreakModeCharacterWrap];

	
	
	size.height += 10 + sizeLabel.height;
	return (size.height < CONST_Cell_height ? CONST_Cell_height : size.height);
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == PROPERTIES_SECTION || (section == RESOURCES_SECTION && resourceLoaded && [descriptor.resourceDescriptors count] > 0))
	{
		return (CGFloat)22.f; //[tableView sectionHeaderHeight];
	}
	return (CGFloat)0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if ([indexPath section] == COMMON_SECTION && indexPath.row == 1) { return [self heightOfCellWithText: [descriptor label]]; }
	if ([indexPath section] == COMMON_SECTION && indexPath.row == 2) { return [self heightOfCellWithText: [descriptor description]]; }
	
	if ([indexPath section] == PROPERTIES_SECTION) { 
		
		JSResourceProperty *rp = (JSResourceProperty *)[[descriptor resourceProperties] objectAtIndex: indexPath.row];
								  
		return [self heightOfPropertyCellWithLabel: [rp name] andText: [rp value]];
	}
	
	if ([indexPath section] == TOOLS_SECTION) { return 44; }
	
	return [tableView rowHeight];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	NSUInteger baseSections = 2;
	
	baseSections++; // Tools
	baseSections++; // Resource descriptors
    
	return baseSections;
}


// Customize the number of rows in the table view.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == PROPERTIES_SECTION)
	{
		return @"Resource properties";
	}
	
	if (section == RESOURCES_SECTION && resourceLoaded && [descriptor.resourceDescriptors count] > 0)
	{
		return @"Nested resources";
    }
	return @"";
		
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	// Name, Label, Description, type, Preview
	if (descriptor == nil) return 0;
	
	if (section == COMMON_SECTION)
	{
		return 5;
	}
	
	if (section == TOOLS_SECTION)
	{
		return 1;
	}
	
	if (section == PROPERTIES_SECTION)
	{
		return (resourceLoaded ? [[descriptor resourceProperties] count] : 1);
	}
	
	if (section == RESOURCES_SECTION)
	{
		return (resourceLoaded ? [[descriptor resourceDescriptors] count] : 0);
    }
	
	
	//if ( [[descriptor wsType] compare: @"img"] == 0 && section == 1)
	//{
	//	// Display the preview of the image....
	//	return 1;
	//}
	
	//if ( section == 2)
	//{
	//	
	//	NSLog(@"Number of propes: %d", [[descriptor resourceProperties] count]);
	//	return [[descriptor resourceProperties] count];
	//}
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath section] == COMMON_SECTION) {   // User details...
		
		if (indexPath.row == 0) {
			self.nameCell = [tableView dequeueReusableCellWithIdentifier:@"NameCell"];
			if (self.nameCell == nil) {
				
				self.nameCell = [[self createCell: @"NameCell"] autorelease];
				self.nameCell.textLabel.text = NSLocalizedString(@"Name", @"");
				self.nameCell.detailTextLabel.text = [descriptor name];
				
				
				//aliasTextField.placeholder = NSLocalizedString(@"My server", @"");
				//aliasTextField = [self newTextFieldForCell:self.aliasCell];
				//aliasTextField.placeholder = NSLocalizedString(@"My server", @"");
				//aliasTextField.keyboardType = UIKeyboardTypeURL;
				//aliasTextField.returnKeyType = UIReturnKeyNext;
				//if(client != nil && client.alias != nil)
				//	aliasTextField.text = client.alias;
				//[self.nameCell addSubview:label];
			}
			
			return self.nameCell;
		}
		else if (indexPath.row == 1) {
			
			self.labelCell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell"];
			if (self.labelCell == nil) {
				self.labelCell = [[self createCell: @"LabelCell"] autorelease];
				self.labelCell.textLabel.text = NSLocalizedString(@"Label", @"");
				self.labelCell.detailTextLabel.text = [descriptor label];
			}
			
			return self.labelCell;
		}
		else if (indexPath.row == 2) {
			
			self.descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell"];
			if (self.descriptionCell == nil) {
				self.descriptionCell = [[self createCell: @"DescriptionCell"] autorelease];
				self.descriptionCell.textLabel.text = NSLocalizedString(@"Description", @"");
				self.descriptionCell.detailTextLabel.text = [descriptor description];
			}
			
			return self.descriptionCell;
		}
		else if (indexPath.row == 3) {
			
			self.typeCell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell"];
			if (self.typeCell == nil) {
				self.typeCell = [[self createCell: @"TypeCell"] autorelease];
				self.typeCell.textLabel.text = NSLocalizedString(@"Type", @"");
				self.typeCell.detailTextLabel.text = [descriptor wsType];

			}
			
			return self.typeCell;
		}
		else if (indexPath.row == 4) {
			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Type2Cell"];
			if (cell == nil) {
				cell = [self createCell: @"Type2Cell"];
				cell.textLabel.text = NSLocalizedString(@"Resources", @"");
			}
			cell.detailTextLabel.text = @"Loading";
			if (resourceLoaded)
			{
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[descriptor.resourceDescriptors count]];
			}
			else {
				cell.detailTextLabel.text = @"?";
			}				
			
			return cell;
		}
	}
	else if ([indexPath section] == 1 && !resourceLoaded)
	{
	
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaitCell"];
		
		
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WaitCell"] autorelease];
		
			cell.textLabel.text = @"Loading....";
		}
		
		return cell;
	}
	else if ([indexPath section] == PROPERTIES_SECTION && resourceLoaded)
	{   // User details...
		
		if (indexPath.row < [[descriptor resourceProperties] count])
		{
			JSResourceProperty *rp = [[descriptor resourceProperties] objectAtIndex:indexPath.row];
			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropCell"];
			
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PropCell"];
				
				cell.textLabel.font = [self LabelFont];
				cell.detailTextLabel.font = [self DetailFont];
				cell.textLabel.lineBreakMode =  UILineBreakModeCharacterWrap;
				cell.textLabel.numberOfLines=0;
				cell.detailTextLabel.lineBreakMode =  UILineBreakModeCharacterWrap;
				cell.detailTextLabel.numberOfLines=0;
				//cell.backgroundColor = [UIColor colorWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				

				//cell = [[self createCell: @"PropCell"] autorelease];
			}
			cell.textLabel.text = [rp name];
			cell.detailTextLabel.text = [rp value];
			
			return cell;
		}
	}
	else if ([indexPath section] == TOOLS_SECTION) {   // User details...
		
		self.toolsCell = [tableView dequeueReusableCellWithIdentifier:@"ToolsCell"];
		if (self.toolsCell == nil) {
			
            self.toolsCell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ToolsCell"];
            //self.toolsCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40) reuseIdentifier: @"ToolsCell"];

			UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
			backView.backgroundColor = [UIColor clearColor];
			//self.toolsCell.backgroundColor = [UIColor clearColor];
			self.toolsCell.backgroundView = backView;
			   
			int buttons = 2; //3;
			int padding = 6;
			int buttonWidth = (self.tableView.frame.size.width -20 -((padding)*(buttons-1))) / buttons;
			
			UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			CGRect frame = CGRectMake(0, 0, buttonWidth, 40);
			button.frame = frame;
			button.tag = 1;
			[button setTitle:@"View" forState:UIControlStateNormal];
			[button addTarget:self action:@selector(viewButtonPressed:forEvent:) forControlEvents:UIControlEventTouchUpInside];
			[button setTag:indexPath.row];
			[self.toolsCell.contentView addSubview:button];

			
            /*
			
			UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			frame = CGRectMake(buttonWidth+padding, 0, buttonWidth, 40);
			button2.frame = frame;
			button2.tag = 2;
			[button2 setTitle:@"Edit" forState:UIControlStateNormal];
			
			//[button2 addTarget:self action:@selector(buttonPressed:withEvent:) forControlEvents:UIControlEventTouchUpInside];
			//[button2 setTag:indexPath.row];
			[self.toolsCell.contentView addSubview:button2];
			
            */
			
			UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			frame = CGRectMake(1*(buttonWidth+padding), 0, buttonWidth, 40);
			button3.frame = frame;
			button3.tag = 3;
			button3.enabled = YES;
			[button3 setTitle:@"Delete" forState:UIControlStateNormal];
			
            [button3 addTarget:self action:@selector(deleteButtonPressed:forEvent:) forControlEvents:UIControlEventTouchUpInside];
			[button3 setTag:indexPath.row];
			[self.toolsCell.contentView addSubview:button3];

			
            

		}
		return self.toolsCell;
	}
	else if ([indexPath section] == RESOURCES_SECTION) {   // User details...

		static NSString *CellIdentifier = @"ResourceCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// Configure the cell.
		JSResourceDescriptor *rd = (JSResourceDescriptor *)[descriptor.resourceDescriptors objectAtIndex: indexPath.row];
		cell.textLabel.text =  [rd label];
		cell.detailTextLabel.text =  [rd uri];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
		
		return cell;
	}
	// We shouldn't reach this point, but return an empty cell just in case
    return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoCell"] autorelease];

}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath section] == COMMON_SECTION) return nil;
	if ([indexPath section] == PROPERTIES_SECTION) return nil;
	if ([indexPath section] == TOOLS_SECTION) return nil;
		
	return indexPath;
	
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == RESOURCES_SECTION)
		{
		// If the resource selected is a folder, navigate in the folder....
		JSResourceDescriptor *rd = [descriptor.resourceDescriptors  objectAtIndex: indexPath.row];
		
		if (rd != nil)
		{		
			//NSLog(@"res type: %@", [rd wsType]);
			JSUIResourceViewController *rvc = [[JSUIResourceViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [rvc setClient: client];
			[rvc setDescriptor: rd];
			[self.navigationController pushViewController: rvc animated: YES];
			[rvc release];
		}
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


- (void)dealloc {
	
	if (descriptor != nil)
	{
		[descriptor release];
	}
	
    [super dealloc];
}


- (IBAction)viewButtonPressed:(id)sender forEvent:(UIEvent *)event
{
	
	JSUIResourcePreviewController *rvc = [[JSUIResourcePreviewController alloc] init];
    [rvc setClient: self.client];
	[rvc setDescriptor: self.descriptor];
	[self.navigationController pushViewController: rvc animated: YES];
	[rvc release];
	
	
}

- (IBAction)editButtonPressed:(id)sender forEvent:(UIEvent *)event
{

	
}

- (IBAction)deleteButtonPressed:(id)sender forEvent:(UIEvent *)event
{
	
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleting resource" message:@"Are you sure you want to delete this resource?" delegate:self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Yes, delete!", nil];
    
    [alert setTag: 101]; // A tag to know this is the DELETE alert in the clickedButtonAtIndex...
    [alert show];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( [alertView tag] != 101 ) return;
    
    if (buttonIndex == 1)
    {
        deleting = true;
        [JSUILoadingView showLoadingInView:self.view];
        [[self client] resourceDelete: [self.descriptor uri] responseDelegate: self];
    }
    
    
}

-(void)resourceDeleted
{
    // By default we have to go back of two view controllers and refresh it...
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    if ([viewControllers count] < 2) return; // We need at least 2 view controllers here...
        
        
    // Find the first controller which has a different uri than the one just deleted...
    for (int i = [viewControllers count]-1; i>=0; --i)
    {
        UIViewController *controller = [viewControllers objectAtIndex:i];
        if ([controller respondsToSelector:@selector(descriptor)])
        {
            JSResourceDescriptor *rd = (JSResourceDescriptor *)[controller performSelector:@selector(descriptor)];
            if (rd != nil && [[rd uri] isEqualToString:[self.descriptor uri]])
            {
                continue;
            }
            else
            {
                
                
                [self.navigationController popToViewController:controller animated:true];
                
                if ([controller respondsToSelector:@selector(refreshContent)])
                {
                    [controller performSelector:@selector(refreshContent) withObject:nil afterDelay:0.0];
                }
                
            }
        }
        
    }
    
}



@end

