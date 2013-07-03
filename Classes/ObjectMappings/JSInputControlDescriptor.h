//
//  JSInputControlDescriptor.h
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 01.11.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSValidationRules.h"
#import "JSInputControlState.h"
#import <Foundation/Foundation.h>

/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.4
 */
@interface JSInputControlDescriptor : NSObject

@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *mandatory;
@property (nonatomic, retain) NSString *readOnly;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *uri;
@property (nonatomic, retain) NSString *visible;
@property (nonatomic, retain) NSArray /*<NSString>*/ *masterDependencies;
@property (nonatomic, retain) NSArray /*<NSString>*/ *slaveDependencies;
@property (nonatomic, retain) JSInputControlState *state;
@property (nonatomic, retain) JSValidationRules *validationRules;

// This is temporary properties used as fix for RestKit bug? The problem is that if
// slave dependencies in Input Control Descriptor XML contains 2 and more values
// (i.e. <slaveDependencies><controlId>Cascading_name_single_select</controlId>
// <controlId>Cascading_state_multi_select</controlId></slaveDependencies>)
// mapping will be performed correctly and as a result there will be NSArray with
// 2 or more objecs. But, if slave dependencies contains only 1 object
// (i.e. <slaveDependencies><controlId>Cascading_name_single_select</controlId></slaveDependencies>)
// the result of the mapping will be "nil".
//
// In this case "those" single input control id maps to NSString instead NSArray
@property (nonatomic, retain) NSString *masterSingleInputControlID;
@property (nonatomic, retain) NSString *slaveSingleInputControlID;

- (NSArray *)selectedValues;

@end
