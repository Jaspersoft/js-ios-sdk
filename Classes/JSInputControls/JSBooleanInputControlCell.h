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
//  JSBooleanInputControlCell.h
//  Jaspersoft
//
//  Created by Giulio Toffoli on 5/28/11.
//  Copyright 2011 Jaspersoft Corp.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSInputControlCell.h"
#import "JSListSelectorViewController.h"



@interface JSBooleanInputControlCell : JSInputControlCell<JSListSelectorDelegate> {

	// The label to display the value
	// In this boolean input control is only present if the boolean has 3 states
	// which are No set, Yes or No.
	UILabel *label;
	UISwitch *switchButton;
	
}

@end
