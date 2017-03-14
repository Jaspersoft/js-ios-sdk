/*
 * Copyright ©  2014 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSOperationResult.h"
#import "JSRequest.h"

@interface JSOperationResult()
@property (nonatomic, strong, readwrite) NSString *bodyAsString;

@end

@implementation JSOperationResult

- (nonnull instancetype)initWithStatusCode:(NSInteger)statusCode
                           allHeaderFields:(nonnull NSDictionary *)allHeaderFields
                                  MIMEType:(nonnull NSString *)MIMEType{
    if (self = [super init]) {
        _statusCode = statusCode;
        _allHeaderFields = allHeaderFields;
        _MIMEType = MIMEType;
    }
    
    return self;
}

- (id)init {
    return [self initWithStatusCode:-1 allHeaderFields:[NSDictionary dictionary] MIMEType:@""];
}

- (BOOL)isSuccessful {
    return self.statusCode >= 200 && self.statusCode < 300;
}

- (NSString *)bodyAsString {
    if (!_bodyAsString && self.body) {
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _bodyAsString = [[NSString alloc] initWithData:self.body encoding:NSUTF8StringEncoding];
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    }
    return _bodyAsString;
}
@end
