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


#import <UIKit/UIKit.h>

@protocol JSDatePickerViewControllerDelegate
@optional
- (void)dateChanged:(NSDate *)date tag:(NSInteger) tag;

@required
- (UITableView *)tableView;
- (UIView *)view;
@end

@interface JSDatePickerView : UIView {
@private
	id<JSDatePickerViewControllerDelegate> delegate;
	UIView *datePickerView;
	UIDatePicker *datePicker;
	UIToolbar *pickerToolbar;
	NSInteger parentOldOffset;
	NSDate *date;
}

@property (nonatomic, retain) id<JSDatePickerViewControllerDelegate> delegate;
@property (nonatomic, retain) UIView *datePickerView;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic) UIDatePickerMode pickerMode;
@property (nonatomic) NSInteger tag;

- (void)slideDownDidStop;
- (void)showDatePicker:(BOOL)show atLocation:(CGFloat)loc;
- (void)showDatePicker:(BOOL)show atLocation:(CGFloat)loc withDate:(NSDate *)dt;


@end
