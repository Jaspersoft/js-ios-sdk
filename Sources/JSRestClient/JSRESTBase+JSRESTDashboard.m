/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSRESTBase+JSRESTDashboard.h"
#import "JSDashboardComponent.h"
#import "JSInputControlDescriptor.h"
#import "JSReportParameter.h"
#import "JSDashboardExportExecutionResource.h"
#import "JSDashboardExportExecutionStatus.h"

@implementation JSRESTBase (JSRESTDashboard)

#pragma mark - Components
- (void)fetchDashboardComponentsWithURI:(NSString *)dashboardURI
                             completion:(nullable JSRequestCompletionBlock)block
{
    NSString *fullURL = [NSString stringWithFormat:@"%@%@_files/%@", kJS_REST_RESOURCES_URI, dashboardURI.hostEncodedString, @"components"];
    JSRequest *request = [[JSRequest alloc] initWithUri:fullURL];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSDashboardComponent objectMappingForServerProfile:self.serverProfile] keyPath:nil];
    request.restVersion = JSRESTVersion_2;
    request.method = JSRequestHTTPMethodGET;
    request.completionBlock = block;
    [self sendRequest:request];
}


#pragma mark - Work with Input Controls
- (void)inputControlsForDashboardWithParameters:(nullable NSArray <JSDashboardParameter *> *)params
                                completionBlock:(nonnull JSRequestCompletionBlock)block
{
    NSMutableArray *requestsArray = [NSMutableArray array];
    for (JSDashboardParameter *parameter in params) {
        NSString *fullURI = [self constructFullURIWithDashboardURI:parameter.name
                                                           inputControls:parameter.value
                                                       initialValuesOnly:NO];
        
        JSRequest *request = [[JSRequest alloc] initWithUri:fullURI];
        request.objectMapping = [JSMapping mappingWithObjectMapping:[JSInputControlDescriptor objectMappingForServerProfile:self.serverProfile] keyPath:@"inputControl"];
        request.restVersion = JSRESTVersion_2;
        [requestsArray addObject:request];
    }
    
    NSMutableArray *inputControlsArray = [NSMutableArray array];
    [self sendRequests:requestsArray withDestination:inputControlsArray completion:^(NSError *error) {
        JSOperationResult *operationResult = [JSOperationResult new];
        if (error) {
            operationResult.error = error;
        } else {
            operationResult.objects = inputControlsArray;
        }
        block(operationResult);
    }];
}

- (void) sendRequests:(NSArray *)requests withDestination:(NSMutableArray *)destination completion:(void(^)(NSError *error))completion{
    if ([requests count]) {
        JSRequest *request = [requests lastObject];
        __weak typeof(self) weakSelf = self;
        request.completionBlock = ^(JSOperationResult *result){
            if (result.error && result.error.code == JSInvalidCredentialsErrorCode) {
                if (completion) {
                    completion(result.error);
                }
            } else {
                if(!result.error) {
                    [(destination) addObjectsFromArray:result.objects];
                }
                __strong typeof(self) strongSelf = weakSelf;
                NSArray *availableRequests = [requests objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, requests.count - 1)]];
                [strongSelf sendRequests:availableRequests withDestination:destination completion:completion];
            }
        };
        [self sendRequest:request];
    } else if(completion) {
        completion(nil);
    }
}

- (void)updatedInputControlValuesForDashboardWithParameters:(nullable NSArray <JSDashboardParameter *> *)params
                                            completionBlock:(nullable JSRequestCompletionBlock)block
{
    NSMutableArray *requestsArray = [NSMutableArray array];
    for (JSDashboardParameter *parameter in params) {
        JSRequest *request = [[JSRequest alloc] initWithUri:[self constructFullURIWithDashboardURI:parameter.name
                                                                                     inputControls:nil
                                                                                 initialValuesOnly:YES]];
        request.objectMapping = [JSMapping mappingWithObjectMapping:[JSInputControlState objectMappingForServerProfile:self.serverProfile] keyPath:@"inputControlState"];
        request.method = JSRequestHTTPMethodPOST;
        request.restVersion = JSRESTVersion_2;
        [self addDashboardParametersToRequest:request withSelectedValues:parameter.value];
        [requestsArray addObject:request];
    }
    
    NSMutableArray *inputControlStatesArray = [NSMutableArray array];
    [self sendRequests:requestsArray withDestination:inputControlStatesArray completion:^(NSError *error) {
        JSOperationResult *operationResult = [JSOperationResult new];
        if (error) {
            operationResult.error = error;
        } else {
            operationResult.objects = inputControlStatesArray;
        }
        block(operationResult);
    }];
}

- (void)runDashboardExportExecutionWithURI:(nonnull NSString *)dashboardURI
                                  toFormat:(nullable NSString *)format
                                parameters:(nullable NSArray <JSDashboardParameter *> *)params
                                completion:(nullable JSRequestCompletionBlock)block
{
    JSDashboardExportExecutionResource *resource = [JSDashboardExportExecutionResource new];
    resource.uri = dashboardURI;
    resource.format = format;
    resource.parameters = params;

    JSRequest *request = [[JSRequest alloc] initWithUri:kJS_REST_DASHBOARD_EXECUTION_URI];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSDashboardExportExecutionResource objectMappingForServerProfile:self.serverProfile] keyPath:nil];
    request.method = JSRequestHTTPMethodPOST;
    request.restVersion = JSRESTVersion_2;
    request.body = resource;
    request.completionBlock = block;
    [self sendRequest:request];
}

- (void)dashboardExportExecutionStatusWithJobID:(nonnull NSString *)jobID
                                     completion:(nullable JSRequestCompletionBlock)block
{
    NSString *uri = [NSString stringWithFormat:@"%@/%@%@", kJS_REST_DASHBOARD_EXECUTION_URI, jobID, kJS_REST_DASHBOARD_EXECUTION_STATUS_URI];
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.objectMapping = [JSMapping mappingWithObjectMapping:[JSDashboardExportExecutionStatus objectMappingForServerProfile:self.serverProfile] keyPath:nil];
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    request.shouldResendRequestAfterSessionExpiration = NO;
    
    [self sendRequest:request];
}

- (void)cancelDashboardExportExecutionWithJobID:(nonnull NSString *)jobID
                                     completion:(nullable JSRequestCompletionBlock)block
{
    NSString *uri = [NSString stringWithFormat:@"%@%@", kJS_REST_DASHBOARD_EXECUTION_URI, jobID];
    JSRequest *request = [[JSRequest alloc] initWithUri:uri];
    request.method = JSRequestHTTPMethodDELETE;
    request.restVersion = JSRESTVersion_2;
    request.completionBlock = block;
    request.shouldResendRequestAfterSessionExpiration = NO;
    
    [self sendRequest:request];
}

- (NSString *)generateDashboardOutputUrl:(NSString *)jobID {
    return [NSString stringWithFormat:@"%@/%@%@/%@/outputResource", self.serverProfile.serverUrl, kJS_REST_SERVICES_V2_URI, kJS_REST_DASHBOARD_EXECUTION_URI, jobID];
}

#pragma mark - Private API
- (NSString *)constructFullURIWithDashboardURI:(NSString *)uri
                             inputControls:(NSArray <NSString *> *)dependencies
                             initialValuesOnly:(BOOL)initialValuesOnly
{
    NSString *fullReportsUri = [NSString stringWithFormat:@"%@%@%@", kJS_REST_REPORTS_URI, (uri.hostEncodedString ?: @""), kJS_REST_INPUT_CONTROLS_URI];

    if (dependencies && dependencies.count) {
        NSMutableString *dependenciesUriPart = [[NSMutableString alloc] initWithString:@"/"];
        for (NSString *dependency in dependencies) {
            [dependenciesUriPart appendFormat:@"%@;", dependency.hostEncodedString];
        }
        fullReportsUri = [fullReportsUri stringByAppendingString:dependenciesUriPart];
    }

    if (initialValuesOnly) {
        fullReportsUri = [fullReportsUri stringByAppendingString:kJS_REST_VALUES_URI];
    }

    return fullReportsUri;
}

- (void) addDashboardParametersToRequest:(JSRequest *)request withSelectedValues:(NSArray *)selectedValues {
    for (JSDashboardParameter *parameter in selectedValues) {
        [request addParameter:parameter.name withArrayValue:parameter.value];
    }
}

@end
