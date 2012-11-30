//
//  JSInputControlDescriptor.m
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 01.11.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import "JSConstants.h"
#import "JSInputControlOption.h"
#import "JSInputControlDescriptor.h"

@implementation JSInputControlDescriptor

@synthesize uuid = _uuid;
@synthesize label = _label;
@synthesize mandatory = _mandatory;
@synthesize readOnly = _readOnly;
@synthesize type = _type;
@synthesize uri = _uri;
@synthesize visible = _visible;
@synthesize masterDependencies = _masterDependencies;
@synthesize slaveDependencies = _slaveDependencies;
@synthesize state = _state;
@synthesize validationRules = _validationRules;
@synthesize masterSingleInputControlID = _masterSingleInputControlID;
@synthesize slaveSingleInputControlID = _slaveSingleInputControlID;

- (NSArray *)masterDependencies {
    if (!_masterDependencies.count && _masterSingleInputControlID.length) {
        _masterDependencies = [[NSArray alloc] initWithObjects:_masterSingleInputControlID, nil];
    }
    
    return _masterDependencies;
}

- (NSArray *)slaveDependencies {
    if (!_slaveDependencies.count && _slaveSingleInputControlID.length) {
        _slaveDependencies = [[NSArray alloc] initWithObjects:_slaveSingleInputControlID, nil];
    }
    
    return _slaveDependencies;
}

- (NSArray *)selectedValues {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    JSConstants *constants = [JSConstants sharedInstance];
    NSString *type = self.type;
    
    if ([constants.ICD_TYPE_BOOL isEqualToString:type] ||
        [constants.ICD_TYPE_SINGLE_VALUE_TEXT isEqualToString:type] ||
        [constants.ICD_TYPE_SINGLE_VALUE_NUMBER isEqualToString:type] ||
        [constants.ICD_TYPE_SINGLE_VALUE_DATE isEqualToString:type] ||
        [constants.ICD_TYPE_SINGLE_VALUE_DATETIME isEqualToString:type]) {
        if (self.state.value) {
            [values addObject:self.state.value];
        }
    } else if ([constants.ICD_TYPE_SINGLE_SELECT isEqualToString:type] ||
               [constants.ICD_TYPE_SINGLE_SELECT_RADIO isEqualToString:type]) {
        for (JSInputControlOption *option in self.state.options) {
            if (option.selected.boolValue) {
                [values addObject:option.value];
                break;
            }
        }
    } else if ([constants.ICD_TYPE_MULTI_SELECT isEqualToString:type] ||
               [constants.ICD_TYPE_MULTI_SELECT_CHECKBOX isEqualToString:type]) {
        for (JSInputControlOption *option in self.state.options) {
            if (option.selected.boolValue) {
                [values addObject:option.value];
            }
        }
    }
    
    return values;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Report Descriptor - uuid: %@; URI: %@; Mandatory: %@; Read Only %@; Type: %@; Visible: %@;\n\tState: %@, Master Dependencies: %@, Slave Dependencies: %@", self.uuid, self.uri, self.mandatory, self.readOnly, self.type, self.visible, self.state, self.masterDependencies, self.slaveDependencies];
}

@end
