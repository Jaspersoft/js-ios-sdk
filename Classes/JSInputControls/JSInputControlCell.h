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
//  ParameterCell.h
//  Jaspersoft
//
//  Created by Giulio Toffoli on 5/25/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import "JSResourceDescriptor.h"
#import "JSClient.h"



#define JS_LBL_DEFAULT_WIDTH                  180.0f

#define JS_LBL_WIDTH                          self.nameLabel.frame.size.width
#define JS_CELL_WIDTH                         self.frame.size.width
#define JS_CELL_PADDING                       15.0f

// Left and right padding
#define JS_CONTENT_PADDING					   10.0f


@interface JSInputControlCell : UITableViewCell  {

	//UITableViewController *_tableViewController;
	UILabel *nameLabel;
	CGFloat height;
	NSMutableArray *targetActionsOnChange;
	NSMutableArray *dependetByInputControls;
}
@property(retain, nonatomic) JSResourceDescriptor *descriptor;
@property(readonly) bool mandatory;
@property(readonly) bool readonly;
@property(readonly) bool selectable;

/** 
 * Client is used only by query based input controls 
 */
@property(retain, nonatomic) JSClient *client;

// Return the list of named parameters from which this control depends
// If there are no dependencies, or there is no query defined in this input control the property returns nil
@property(readonly) NSArray *dependsBy;


// The uri to be used when performing a get on a query based input control
// It is supposed to be the Report Unit data source, and it is passed to the get service
// as value for the parameter IC_GET_QUERY_DATA
@property(retain, nonatomic) NSString *dataSourceUri; 


// The label which holds the main text
@property(readonly) UILabel *nameLabel;

// The most appropriate height of this cell
@property(readonly) CGFloat height;


@property(readonly) UITableViewController *tableViewController;

// This is the list of selected value(s). It is a generic id, since it could be 
// NSString, NSMutableArray, NSDate;
// Numbers are stored as NSString, since this is what is expected by JasperReports Server.
// Boolean values are stored as "true" and "false"
@property(retain, nonatomic) id selectedValue;


// Create the most appropriate input control
+(id)inputControlWithDescriptor:(JSResourceDescriptor *)rd tableViewController: (UITableViewController *)tv dataSourceUri: (NSString *)dsUri client:(JSClient *)client;

- (id)initWithDescriptor:(JSResourceDescriptor *)rd tableViewController: (UITableViewController *)tv;
- (id)initWithDescriptor:(JSResourceDescriptor *)rd tableViewController: (UITableViewController *)tv dataSourceUri: (NSString *)dsUri;


// Add an object to be notified when the selectedValue of this inputControl changes
// The action is expected to get a parameter (the sender input control which is changed)
-(void)addTarget:(id)aTarget withAction:(SEL)anAction;


// Add a dependency to another input control. If required, this input control will reload its data
// when the dependent input control changes.
// Under the scenes, this inputcontrols based on a query will add itself as target to the passed input control
-(void)addDependency:(JSInputControlCell *)inputControlCell;

// Invoked (if selectable is true) when the user taps this cell
- (void)cellDidSelected;

-(void)createNameLabel;

// Find the data type descriptor of an inputControl descriptor
+(JSResourceDescriptor *)findDataType:(JSResourceDescriptor *)rd forClient:(JSClient *)client;


// Update the records displayed based on the selection....
// The default implementation does nothing
// Of parameters is nil, it is ignored.
-(void)reloadInputControlQueryData:(NSDictionary *)parameters;


@end
