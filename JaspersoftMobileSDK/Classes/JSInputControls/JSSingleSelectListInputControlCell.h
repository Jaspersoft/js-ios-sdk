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
//  JSSingleSelectListInputControlCell.h
//  Jaspersoft
//
//  Created by Giulio Toffoli on 5/29/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSInputControlCell.h"
#import "JSListSelectorViewController.h"
#import "JSClient.h"

@interface JSSingleSelectListInputControlCell : JSInputControlCell <JSListSelectorDelegate, JSResponseDelegate> {

	// The label to display the value
	UILabel *label;
    bool    loading;
	
}
@property(retain, nonatomic) NSArray *items;



- (id)initWithDescriptor:(JSResourceDescriptor *)rd tableViewController: (UITableViewController *)tv dataSourceUri: (NSString *)dsUri client: (JSClient *)client;

-(NSInteger)indexOfItemWithValue: (NSString *)val;
-(void)updateValueText;
-(void)adjustSelection;
@end
