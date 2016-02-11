/*
 * Jaspersoft Mobile SDK
 * Copyright (C) 2011 - 2016 Jaspersoft Corporation. All rights reserved.
 * http://community.jaspersoft.com/project/mobile-sdk-ios
 *
 * Unless you have purchased a commercial license agreement from Jaspersoft,
 * the following license terms apply:
 *
 * This program is part of Jaspersoft Mobile SDK for iOS.
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
 * along with Jaspersoft Mobile SDK for iOS. If not, see
 * <http://www.gnu.org/licenses/lgpl>.
 */

//
//  JSRESTBase+JSRESTDashboard.h
//  Jaspersoft Corporation
//

#import "JSRESTBase+JSRESTDashboard.h"
#import "JSDashboardComponent.h"
#import "JSInputControlDescriptor.h"
#import "JSReportParameter.h"


@implementation JSRESTBase (JSRESTDashboard)


#pragma mark - Components
- (void)fetchDashboardComponentsWithURI:(NSString *)dashboardURI
                             completion:(nullable JSRequestCompletionBlock)block
{
    NSString *fullURL = [NSString stringWithFormat:@"%@%@_files/%@", kJS_REST_RESOURCES_URI, dashboardURI, @"components"];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.expectedModelClass = [JSDashboardComponent class];
    request.restVersion = JSRESTVersion_2;
    request.method = JSRequestHTTPMethodGET;
    request.completionBlock = block;
    [self sendRequest:request];
}


#pragma mark - Work with Input Controls
- (void)inputControlsForDashboardWithURI:(nonnull NSString *)dashboardURI
                                     ids:(nullable NSArray <NSString *> *)ids
                          selectedValues:(nullable NSArray <JSReportParameter *> *)selectedValues
                                   async:(BOOL)async
                         completionBlock:(nullable JSRequestCompletionBlock)block
{
    NSString *fullURI = [self constructFullURIWithDashboardURI:dashboardURI
                                                 inputControls:ids
                                             initialValuesOnly:NO];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURI];
    request.expectedModelClass = [JSInputControlDescriptor class];
    request.restVersion = JSRESTVersion_2;
    request.method = JSRequestHTTPMethodGET;
    request.completionBlock = block;
    [self addDashboardParametersToRequest:request withSelectedValues:selectedValues];
    request.asynchronous = async;
    [self sendRequest:request];
}


- (void)updatedInputControlValuesForDashboardWithURI:(NSString *)dashboardURI
                                                 ids:(NSArray <NSString *> *)ids
                                      selectedValues:(NSArray <JSReportParameter *> *)selectedValues
                                               async:(BOOL)async
                                     completionBlock:(JSRequestCompletionBlock)block
{
    JSRequest *request = [[JSRequest alloc] initWithUri:[self constructFullURIWithDashboardURI:dashboardURI
                                                                                 inputControls:ids
                                                                             initialValuesOnly:YES]];
    request.expectedModelClass = [JSInputControlState class];
    request.method = JSRequestHTTPMethodPOST;
    request.restVersion = JSRESTVersion_2;
    [self addDashboardParametersToRequest:request withSelectedValues:selectedValues];
    request.completionBlock = block;
    request.asynchronous = async;
    [self sendRequest:request];
}

#pragma mark - Private API
- (NSString *)constructFullURIWithDashboardURI:(NSString *)uri
                             inputControls:(NSArray <NSString *> *)dependencies
                             initialValuesOnly:(BOOL)initialValuesOnly
{
    NSString *fullReportsUri = [NSString stringWithFormat:@"%@%@%@", kJS_REST_REPORTS_URI, (uri ?: @""), kJS_REST_INPUT_CONTROLS_URI];

    if (dependencies && dependencies.count) {
        NSMutableString *dependenciesUriPart = [[NSMutableString alloc] initWithString:@"/"];
        for (NSString *dependency in dependencies) {
            [dependenciesUriPart appendFormat:@"%@;", dependency];
        }
        fullReportsUri = [fullReportsUri stringByAppendingString:dependenciesUriPart];
    }

    if (initialValuesOnly) {
        fullReportsUri = [fullReportsUri stringByAppendingString:kJS_REST_VALUES_URI];
    }

    return fullReportsUri;
}

- (void) addDashboardParametersToRequest:(JSRequest *)request withSelectedValues:(NSArray *)selectedValues {
    for (JSReportParameter *parameter in selectedValues) {
        [request addParameter:parameter.name withArrayValue:parameter.value];
    }
}

@end