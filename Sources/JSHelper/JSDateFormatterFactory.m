/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


#import "JSDateFormatterFactory.h"

@interface JSDateFormatterFactory()
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSDateFormatter *> *formatters;
@end

@implementation JSDateFormatterFactory

+ (instancetype)sharedFactory {
    static JSDateFormatterFactory *sharedFactory;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedFactory = [JSDateFormatterFactory new];
        sharedFactory.formatters = [NSMutableDictionary new];
    });
    return sharedFactory;
}

- (NSDateFormatter *)formatterWithPattern:(NSString *)pattern
{
    NSDateFormatter *formatter = [self formatterWithPattern:pattern timeZone:nil];
    return formatter;
}

- (NSDateFormatter *)formatterWithPattern:(NSString *)pattern timeZone:(NSTimeZone *)timeZone
{
    NSString *formatterKey = [timeZone name] ? [pattern stringByAppendingFormat:@".%@", [timeZone name]] : pattern;
    NSDateFormatter *formatter = self.formatters[formatterKey];
    if (!formatter) {
        formatter = [self createFormatterWithPattern:pattern timeZone:timeZone];
        self.formatters[formatterKey] = formatter;
    }
    return formatter;
}

#pragma mark - Helpers
- (NSDateFormatter *)createFormatterWithPattern:(NSString *)pattern timeZone:(NSTimeZone *)timeZone
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    if (timezone) {
        formatter.timeZone = timeZone;
    }
    formatter.dateFormat = pattern;
    return formatter;
}

@end
