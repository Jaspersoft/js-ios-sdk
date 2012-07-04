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

#import "JSUIReportUnitParametersViewController.h"
#import "JSInputControlCell.h"
#import "JSUIResourceViewController.h"
#import "JSUIReportUnitViewController.h"



@implementation JSUIReportUnitParametersViewController

@synthesize descriptor;
@synthesize client;

#pragma mark -
#pragma mark View lifecycle

#define CONST_Cell_height 44.0f
#define CONST_Cell_Content_width 200.0f
#define CONST_Cell_Label_width 200.0f
#define CONST_Cell_width 280.0f


#define CONST_labelFontSize    12
#define CONST_detailFontSize   15

#define INPUT_CONTROLS_SECTION  0
#define TOOLS_SECTION       1

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
	if ((self = [super initWithStyle:style]))
	{
		
		UIBarButtonItem *infoButton = [[[UIBarButtonItem alloc] 
						   initWithTitle: @"Info"
						   style: UIBarButtonItemStylePlain
						   target:self action:@selector(infoClicked:)] autorelease];
		
		self.navigationItem.rightBarButtonItem = infoButton;
		
		descriptor = nil;
		resourceLoaded = NO;
		inputControls = [[NSMutableArray alloc] initWithCapacity:0];
		inputControlCells = [[NSMutableArray alloc] initWithCapacity:0];
		
	}
	return self;
	
}

-(IBAction)infoClicked:(id)sender
{
	JSUIResourceViewController *rvc = [[JSUIResourceViewController alloc]  initWithStyle: UITableViewStyleGrouped];
    [rvc setClient:self.client];
	[rvc setDescriptor: descriptor];
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
    else if ([res returnCode] > 400)
    {
        UIAlertView *uiView =[[[UIAlertView alloc] initWithTitle:@"" message:@"Error reading the response" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[uiView show];
    }
	else {
		//NSLog( @"Code: %d, Message: %@", [res returnCode], [res message] );  
		
		if ([[res resourceDescriptors] count] > 0)
		{
			descriptor = [[res resourceDescriptors] objectAtIndex:0];
			
			NSString *reportUnitDsUri = nil;
			// Find the data source uri...
			for (int i=0; i< self.descriptor.resourceDescriptors.count; ++i)
			{
				JSResourceDescriptor *rd = (JSResourceDescriptor *)[self.descriptor.resourceDescriptors objectAtIndex: i];
				if ([[rd wsType] isEqualToString: JS_TYPE_DATASOURCE] )
				{
					reportUnitDsUri = [rd resourcePropertyValue:JS_PROP_FILERESOURCE_REFERENCE_URI];
				}
				else if ([[rd wsType] isEqualToString: JS_TYPE_DATASOURCE_BEAN] ||
						 [[rd wsType] isEqualToString: JS_TYPE_DATASOURCE_CUSTOM] ||
						 [[rd wsType] isEqualToString: JS_TYPE_DATASOURCE_JDBC] ||
						 [[rd wsType] isEqualToString: JS_TYPE_DATASOURCE_JNDI])
				{
					reportUnitDsUri = [rd uri];
				}
			}
			
			
			// Load inputControls....
			for (int i=0; i< self.descriptor.resourceDescriptors.count; ++i)
			{
				JSResourceDescriptor *rd = (JSResourceDescriptor *)[self.descriptor.resourceDescriptors objectAtIndex: i];
				if ([[rd wsType] isEqualToString:JS_TYPE_INPUT_CONTROL])
				{
					// Add the input control to this list only if it is visible...
					if ([[rd resourcePropertyValue:JS_PROP_INPUTCONTROL_IS_VISIBLE withDefault:@"true"] isEqualToString:@"true"])
					{	
						[inputControls addObject:rd];
						JSInputControlCell *cell = [JSInputControlCell inputControlWithDescriptor:rd tableViewController: self dataSourceUri: reportUnitDsUri client: self.client];
						
                        
                        [inputControlCells addObject:cell];
					}
				}
			}
			
			// Update the dependencies of parameters...
			for (int i=0; i < [inputControlCells count]; i++) {
				JSInputControlCell *cell = [inputControlCells objectAtIndex:i];
				NSArray *dependentByParameters = [cell dependsBy];
				if (dependentByParameters != nil && [dependentByParameters count] > 0)
				{
					for (int index = 0; index < [dependentByParameters count]; ++index)
					{
						NSString *paramName = [dependentByParameters objectAtIndex:index];
						
						for (int j=0; j < [inputControlCells count]; j++) {
							
							JSInputControlCell *dependencyParameterCell = [inputControlCells objectAtIndex:j];
							if (dependencyParameterCell == cell) continue;
							if ([[[dependencyParameterCell descriptor] name] isEqualToString: paramName])
							{
								[cell addDependency:dependencyParameterCell];
							}
						}
					}
				}
			}
			
			
		}
	}
	
	// Update the table...
	resourceLoaded = true;
	[[self tableView] reloadData];
	
    [JSUILoadingView hideLoadingView];
	
	
    
    //// To run the report immediatly, in case there are not parameters to set, uncomment this lines
	//if ([inputControls count] == 0)
	//{
	//	[self runReport];
	//}
	
}


-(void)inputControlChanged:(id)sender
{
	//JSInputControlCell *icc = (JSInputControlCell *)sender;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	if (resourceLoaded) return;
	if (descriptor != nil)
	{
		[self performSelector:@selector(updateTableContent) withObject:nil afterDelay:0.0];
	}
	
}

-(void)updateTableContent {
	
	if ([self client] == nil) return;
	
	if ([self descriptor] != nil)
	{
		self.navigationItem.title=[NSString stringWithFormat:@"%@", [descriptor label]];
		
		
		// load this view...
        [JSUILoadingView showLoadingInView:self.view];
        
		NSDictionary *arguments  = [NSDictionary dictionaryWithObject:@"true" forKey:@"IC_GET_QUERY_DATA"];

		[[self client] resourceInfo:[descriptor uri] withArguments: arguments responseDelegate: self];  
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == INPUT_CONTROLS_SECTION && resourceLoaded && [inputControls count] > 0)
	{
		return (CGFloat)22.f; //[tableView sectionHeaderHeight];
	}
	return (CGFloat)0.f;
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	int baseSections = 0;
	if (resourceLoaded) baseSections = 2; // Input parameters and Tools...
	return baseSections;
}


// Customize the number of rows in the table view.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == INPUT_CONTROLS_SECTION && resourceLoaded && [inputControls count] > 0)
	{
		return @"Input parameters";
	}
	return @"";
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	// Name, Label, Description, type, Preview
	if (descriptor == nil || !resourceLoaded) return 0;
	
	if (section == INPUT_CONTROLS_SECTION)
	{
		return [inputControls count];
	}
	
	if (section == TOOLS_SECTION)
	{
		return 2;
	}
	
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([indexPath section] == INPUT_CONTROLS_SECTION && resourceLoaded)
	{   // User details...
		return [inputControlCells objectAtIndex:indexPath.row];
	}
	else if ([indexPath section] == TOOLS_SECTION) {   // User details...
		
        if (indexPath.row == 0)
        {
            UITableViewCell *formatCell =  [tableView dequeueReusableCellWithIdentifier:@"FormatCell"];
            if (formatCell == nil) {
                
                formatCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FormatCell"];
                //formatCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40) reuseIdentifier: @"FormatCell"];
                
                UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
                backView.backgroundColor = [UIColor clearColor];
                //self.toolsCell.backgroundColor = [UIColor clearColor];
                formatCell.backgroundView = backView;
               
                NSArray *segments = [NSArray arrayWithObjects:@"HTML",@"PDF", nil];
                
                segmentedControl = [[UISegmentedControl alloc] initWithItems: segments];

                [segmentedControl setSelectedSegmentIndex:0];
                int buttonWidth = self.tableView.frame.size.width -20;
                
                CGRect frame = CGRectMake(0, 0, buttonWidth, 40);
                segmentedControl.frame = frame;
                [segmentedControl addTarget:self action:@selector(setFormat) forControlEvents:UIControlEventTouchUpInside];
                [formatCell.contentView addSubview:segmentedControl];
            }
            return formatCell;

        }
        else
        {
            UITableViewCell *toolsCell =  [tableView dequeueReusableCellWithIdentifier:@"ToolsCell"];
            if (toolsCell == nil) {
                
                toolsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ToolsCell"];
                //toolsCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40) reuseIdentifier: @"ToolsCell"];

                UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
                backView.backgroundColor = [UIColor clearColor];
                //self.toolsCell.backgroundColor = [UIColor clearColor];
                toolsCell.backgroundView = backView;
                   
                int buttons = 1;
                int padding = 6;
                int buttonWidth = (self.tableView.frame.size.width -20 -((padding)*(buttons-1))) / buttons;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                CGRect frame = CGRectMake(0, 0, buttonWidth, 40);
                button.frame = frame;
                button.tag = 1;
                [button setTitle:@"Run" forState:UIControlStateNormal];
                [button setTag:indexPath.row];
                [button addTarget:self action:@selector(runReport) forControlEvents:UIControlEventTouchUpInside];
                [toolsCell.contentView addSubview:button];
            }
            return toolsCell;
		}
		
	}
	// We shouldn't reach this point, but return an empty cell just in case
    return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoCell"] autorelease];

}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	if ([indexPath section] == TOOLS_SECTION)
	{
		return nil; // the touch is handled by the button inside the cell
	}
	
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	if ([cell isKindOfClass: [JSInputControlCell class]]) return   [(JSInputControlCell *)cell selectable] ? indexPath : nil;

	
	
		
	return indexPath;
	
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	if (indexPath.section == INPUT_CONTROLS_SECTION)
	{
		// get selected cell...
		if (inputControlCells != nil && inputControlCells.count > indexPath.row)
		{
			UITableViewCell *cell = [inputControlCells objectAtIndex:indexPath.row];
			if ([cell isKindOfClass: [JSInputControlCell class]])
			{
				return [(JSInputControlCell *)cell height];
			}
		}
	}
	else if ([indexPath section] == TOOLS_SECTION) { 
		return 44.0f; 
	}
	
	return [self.tableView rowHeight];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == INPUT_CONTROLS_SECTION)
	{
		// get selected cell...
		UITableViewCell *cell = [inputControlCells objectAtIndex:indexPath.row];
		if ([cell isKindOfClass: [JSInputControlCell class]])
		{
			[(JSInputControlCell *)cell cellDidSelected];
		}
	}
}


#pragma mark -
#pragma mark Report Execution

-(void)runReport
{
    
    // collect parameters...
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	
	for (int i=0; i< [inputControlCells count]; ++i)
	{
		UITableViewCell *cell = [inputControlCells objectAtIndex:i];
		if ([cell isKindOfClass: [JSInputControlCell class]])
		{
			id value = [(JSInputControlCell *)cell selectedValue];
			if (value != nil)
			{
				[params setObject:value forKey: [[(JSInputControlCell *)cell descriptor] name]];
            }
		}
	}
    
    
    UIViewController *reportViewer = nil;
    
    NSString *format = @"PDF";
    if ([segmentedControl selectedSegmentIndex] == 0)
    {
        format = @"HTML";
    }
    
    
        JSUIReportUnitViewController *reportPdfViewer = [[JSUIReportUnitViewController alloc] initWithNibName:@"JSUIReportUnitViewController" bundle:nil];
        [reportPdfViewer setDescriptor: self.descriptor];
        [reportPdfViewer setClient: self.client];
        [reportPdfViewer setPreviousController:self];
    [reportPdfViewer setFormat:format];
        
        [reportPdfViewer setParameters:params];
    
    reportViewer = reportPdfViewer;
	
   
    [self presentModalViewController:reportViewer animated:YES];

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
	
	[inputControls release];
	[inputControlCells release];
	if (descriptor != nil)
	{
		[descriptor release];
	}
    [segmentedControl release];
	
    [super dealloc];
}


@end

