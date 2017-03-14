/*
 * Copyright © 2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSRequest.h"

@interface JSRequest()
@property (nonatomic, retain) NSMutableDictionary *parameters;
@end

@implementation JSRequest

- (nonnull instancetype)initWithUri:(nonnull NSString *)uri {
    if (self = [super init]) {
        self.uri = uri;
        self.method = JSRequestHTTPMethodGET;
        self.serializationType = JSRequestSerializationType_JSON;
        self.responseAsObjects = YES;
        self.restVersion = JSRESTVersion_1;
        self.parameters = [NSMutableDictionary dictionary];
        self.redirectAllowed = YES;
        self.shouldResendRequestAfterSessionExpiration = YES;
    }

    return self;
}

- (void)addParameter:(nonnull NSString *)parameter withStringValue:(nonnull NSString *)value {
    if (value.length) {
        [self.parameters setObject:value forKey:parameter];
    }
}

- (void)addParameter:(nonnull NSString *)parameter withIntegerValue:(NSInteger)value {
    [self.parameters setObject:[NSNumber numberWithInteger:value] forKey:parameter];
}

- (void)addParameter:(nonnull NSString *)parameter withArrayValue:(nonnull NSArray *)value {
    if (value) {
        [self.parameters setObject:value forKey:parameter];
    }
}

- (NSDictionary *)params {
    if (self.method == JSRequestHTTPMethodGET || self.method == JSRequestHTTPMethodHEAD || self.method == JSRequestHTTPMethodDELETE) {
        NSMutableDictionary *paramsDictionary = [NSMutableDictionary dictionary];
        for (NSString *key in self.parameters) {
            id value = [self.parameters objectForKey:key];
            if ([value isKindOfClass:[NSArray class]]) {
                value = [NSSet setWithArray:value];
            }
            [paramsDictionary setObject:value forKey:key];
        }
        return [NSDictionary dictionaryWithDictionary:paramsDictionary];
    }
    return [NSDictionary dictionaryWithDictionary:self.parameters];
}

#pragma mark - Accessors

- (NSString *)fullURI {
    NSString *restServiceUri = nil;
    
    switch (self.restVersion) {
        case JSRESTVersion_2:
            restServiceUri = kJS_REST_SERVICES_V2_URI;
            break;
        case JSRESTVersion_1:
            restServiceUri = kJS_REST_SERVICES_URI;
            break;
        default:
            restServiceUri = @"";
    }
    
    // Remove all [] for query params (i.e. query &PL_Country_multi_select[]=Mexico&PL_Country_multi_select[]=USA will
    // be changed to &PL_Country_multi_select=Mexico&PL_Country_multi_select=USA without any [])
    NSString *brackets = @"[]";
    if ([self.uri rangeOfString:brackets].location != NSNotFound) {
        self.uri = [self.uri stringByReplacingOccurrencesOfString:brackets withString:@""];
    }
    
    return [NSString stringWithFormat:@"%@%@", restServiceUri, (self.uri ?: @"")];
}

+ (nonnull NSString *)httpMethodStringRepresentation:(JSRequestHTTPMethod)method {
    switch (method) {
        case JSRequestHTTPMethodGET:
            return @"GET";
        case JSRequestHTTPMethodDELETE:
            return @"DELETE";
        case JSRequestHTTPMethodHEAD:
            return @"HEAD";
        case JSRequestHTTPMethodPOST:
            return @"POST";
        case JSRequestHTTPMethodPUT:
            return @"PUT";
        case JSRequestHTTPMethodPATCH:
            return @"PATCH";
    }
}

@end
