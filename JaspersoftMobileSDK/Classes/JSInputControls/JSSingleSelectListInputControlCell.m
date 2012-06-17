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
//  JSSingleSelectListInputControlCell.m
//  Jaspersoft
//
//  Created by Giulio Toffoli on 5/29/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSSingleSelectListInputControlCell.h"
#import "JSListSelectorViewController.h"
#import "JaspersoftAppDelegate.h"
#import "JSUtils.h"

#define JS_LBL_VALUE_WIDTH		160.0f

@implementation JSSingleSelectListInputControlCell

@synthesize items;

- (id)initWithDescriptor:(JSResourceDescriptor *)rd tableViewController: (UITableViewController *)tv
{
	return [self initWithDescriptor:rd tableViewController: tv dataSourceUri: nil];
}

- (id)initWithDescriptor:(JSResourceDescriptor *)rd tableViewController: (UITableViewController *)tv dataSourceUri: (NSString *)dsUri client: (JSClient *)cli;
{
	if ((self = [super initWithDescriptor: rd tableViewController: tv dataSourceUri: dsUri]))
	{
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.client = cli;
        loading = FALSE;
        
		NSString *inputControlType = [rd resourcePropertyValue:JS_PROP_INPUTCONTROL_TYPE];
		
		if ([inputControlType isEqualToString:JS_IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES] ||
			[inputControlType isEqualToString:JS_IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES_RADIO])
		{
			// Look for the LOV resource...
			for (int i=0; i< [[rd resourceDescriptors] count]; ++i)
			{
				JSResourceDescriptor *rdChild = [[rd resourceDescriptors] objectAtIndex:i];
				if ( [[rdChild wsType] isEqualToString:JS_TYPE_LOV])
				{
					self.items = [rdChild listOfItems];
					break;
				}
			}
		}
		else if ([inputControlType isEqualToString:JS_IC_TYPE_SINGLE_SELECT_QUERY] ||
			[inputControlType isEqualToString:JS_IC_TYPE_SINGLE_SELECT_QUERY_RADIO])
		{
            
            // Look for a more appropriate datasource if available for this input control...
            NSString *newDsUri = [JSUtils findDataSourceUri:rd withClient:cli];
            
            
            
            if (newDsUri != nil)
            {
                self.dataSourceUri = newDsUri;
            }
            
			// Get the date from the input control...
			// We need to reload the input control to get the data...
			[self reloadInputControlQueryData: nil];
		}
		
		
		self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y, JS_LBL_VALUE_WIDTH, self.nameLabel.frame.size.height);
        self.selectedValue = nil;
		self.nameLabel.backgroundColor = [UIColor clearColor];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(
															  JS_CELL_PADDING + JS_CONTENT_PADDING + JS_LBL_VALUE_WIDTH, 10.0, 
															  JS_CELL_WIDTH - (2*JS_CELL_PADDING + JS_CONTENT_PADDING + JS_LBL_VALUE_WIDTH) - 20.0f, 21.0)];
			
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
		label.textAlignment = UITextAlignmentRight;
		label.tag = 100;
		label.font = [UIFont systemFontOfSize:14.0];
		label.textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
        label.backgroundColor = [UIColor clearColor];
		[self updateValueText];
		
		if (self.readonly)
		{
			label.frame = CGRectMake(246.0, 10.0, 53.0, 21.0);
		}
		else {
			
			self.selectionStyle = UITableViewCellSelectionStyleBlue;
			self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}	
		[self addSubview:label];
	}
	
	return self;
}

-(void)dealloc
{
	[items autorelease];
	[label release];
	[super dealloc];
}


// Specifies if the user can select this cell
-(bool)selectable
{
	return !self.readonly;
}


// User touched the InputControl cell....
-(void)cellDidSelected
{
	if (self.readonly) return;
	
	//if (self.mandatory)
	//{
	//	
	//}
	//else {
		
		NSMutableArray *selectedVals = [NSMutableArray arrayWithCapacity:0];
		if (self.selectedValue != nil)
		{
			[selectedVals addObject: [NSNumber numberWithInt: [self indexOfItemWithValue: self.selectedValue] ]];
		}
		
        JSListSelectorViewController *rvc = [[JSListSelectorViewController alloc] initWithStyle:UITableViewStyleGrouped];
		rvc.values  = self.items;
	    rvc.mandatory = self.mandatory;
		rvc.selectedValues = selectedVals;
		rvc.selectionDelegate = self;
		[self.tableViewController.navigationController pushViewController: rvc animated: YES];
		[rvc release];
	//}
}


-(void)setSelectedValue:(id)vals
{
	if (self.selectedValue ==  vals) return;
	[super setSelectedValue:vals];
	
	[self updateValueText];
}

-(void)updateValueText
{
    if (loading)
    {
        label.text = @"Loading...";
        return;
    }
    
	if (self.selectedValue == nil) {
		label.text = @"Not set";
	}
	//else if ([self.selectedValue isKindOfClass: NSArray])
	//{ }
	else
	{
		NSInteger index = [self indexOfItemWithValue: self.selectedValue];
		if (index >= 0 && index < [items count])
		{
			label.text = [(JSListItem *)[items objectAtIndex: index] name];
		}
		else {
			label.text = @"?";
		}
	}
}




// This method is invoked by the ListSelectorView
-(void)setSelectedIndexes:(NSMutableArray *)indexes
{
	if (indexes.count == 0)
	{
		self.selectedValue = nil;
	}
	else {
		
		NSString *str =  [(JSListItem *)[self.items objectAtIndex: [[indexes objectAtIndex:0] intValue]] value];
		self.selectedValue = str;
       
	}
}


// Return the first item in items with the given value...
-(NSInteger)indexOfItemWithValue: (NSString *)val
{
	for (int i=0; i<self.items.count; ++i)
	{
		if ( [[(JSListItem *)[self.items objectAtIndex:i] value] isEqualToString:val]) return i;
	}
	return -1;
}


// Update the records displayed based on the selection....
// if parameters is nil, it is ignored.
-(void)reloadInputControlQueryData:(NSDictionary *)parameters
{
    if (self.client == nil) return;
	
    loading = TRUE;
	[self updateValueText];
    
    NSString *dsUriString =  (self.dataSourceUri == nil) ? @"null" : self.dataSourceUri;
	NSMutableDictionary *arguments  = [NSMutableDictionary dictionaryWithObject:dsUriString forKey:@"IC_GET_QUERY_DATA"];
	
    if (parameters != nil)
	{
		NSEnumerator *enumerator = [parameters keyEnumerator];
		id objKey;
		
		while ((objKey = [enumerator nextObject])) {
			
			id value = [parameters objectForKey:objKey];
			
			if (value == nil) continue;
			if ([value isKindOfClass:[NSArray class]])
			{
				[arguments setValue:value 
								   forKey: [NSString stringWithFormat:@"PL_%@",objKey]];
			}
			else if ([value isKindOfClass:[NSDate class]])
			{
				// Dates should be passed to the service as numbers...
				NSDate *dateValue = (NSDate *)value;
				NSTimeInterval interval = [dateValue timeIntervalSince1970];
				[arguments setValue:[NSString stringWithFormat:@"%.0f", interval*1000] 
							 forKey: [NSString stringWithFormat:@"P_%@",objKey]];
			}
			else
			{
				[arguments setValue:value forKey: [NSString stringWithFormat:@"P_%@",objKey]];
			}
		}
		
	}
    
    [[self client] resourceInfo:[self.descriptor uri] withArguments: arguments responseDelegate: self]; 
	
}

-(void)requestFinished:(JSOperationResult *)res {
	
    loading = FALSE;
    if (res == nil || [[res resourceDescriptors] count] == 0)
	{
        [label setTextColor:[UIColor redColor] ];
		label.text = @"#ERROR";
	}
	else {
		
		// Get the data from the descriptor...
		// Data is stored in a structured form, let's take a look at it...
        
        self.descriptor = [[res resourceDescriptors] objectAtIndex:0]; // Get the first descriptor...
		
		// load the items in memory...
		self.items = [NSMutableArray arrayWithCapacity:0];
		
		// We treat the query data rows just like list items, but we need a little conversion first...
		NSMutableArray *myItems = [NSMutableArray array];
		NSArray *dataRows = [self.descriptor queryData]; // This method look inside the descriptor and creates a temporary array of
																// data rows...
		
		for (int i=0; i< [dataRows count]; ++i)
		{
			JSInputControlQueryDataRow *dataRow = [dataRows objectAtIndex:i];
			
			NSString *labelString = @"";
			
			int count = [[dataRow labels] count];
			for (int j=0; j < count; ++j)
			{
				if (j > 0) 
				{
					
				}
				labelString = [labelString stringByAppendingFormat:@"%@%@", (j > 0 && j < count) ? @" \u2022 " : @"", [[dataRow labels] objectAtIndex:j]];
			}
			
			JSListItem *item = [[JSListItem alloc] initWithName:labelString andValue: [dataRow value]];
			
			[myItems addObject:item];
		}
		
		self.items = myItems;
		
		[self adjustSelection];
		
	}
}


// This method is used when data for this input control is changed, and we want to be sure that at least one
// element from the selection is actually selected if the input control is mandatory
// If a selection is already available, it tries to recycle it, otherwise the selection will be cleanup...
-(void)adjustSelection
{
    NSString *newValue = self.selectedValue;
	if (newValue != nil)
	{
		NSInteger index = [self indexOfItemWithValue: newValue];
		if (index < 0)
		{
			newValue = nil;
		}
	}
	
	if (newValue == nil && self.mandatory && self.items.count > 0)
	{
		newValue = [(JSListItem *)[self.items objectAtIndex:0] value];
	}
	
	if (self.selectedValue != newValue)
	{
		self.selectedValue = newValue;
	}
	else {
		[self updateValueText];
	}

	
	
}




@end
