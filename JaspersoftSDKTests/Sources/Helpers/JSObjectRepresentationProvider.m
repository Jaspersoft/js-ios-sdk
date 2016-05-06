//
//  JSObjectRepresentationProvider.m
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 4/26/16.
//
//

#import "JSObjectRepresentationProvider.h"

@implementation JSObjectRepresentationProvider

+ (id)JSONObjectForClass:(Class)class {
    NSString *className = NSStringFromClass(class);
    NSString *jsonFileName = [className substringFromIndex:2];
    
    return [self JSONObjectFromFileNamed:jsonFileName];
}

+ (id)JSONObjectFromFileNamed:(NSString *)fileName {
    NSString *filePath = [self filePathWithFileName:fileName extension:@"json"];
    if ([filePath length] == 0) {
        @throw ([NSException exceptionWithName:@"FileNotFound"
                                        reason:[NSString stringWithFormat:@"File can't be found: %@", fileName]
                                      userInfo:nil]);
    }
 
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:fileData
                                           options:0
                                             error:&error];
    if (error) {
        @throw ([NSException exceptionWithName:@"JSONCorrupted"
                                        reason:[NSString stringWithFormat:@"JSON is corrupted in file: %@", fileName]
                                      userInfo:nil]);
    }
    return JSONObject;
}

+ (NSString *)filePathWithFileName:(NSString *)fileName extension:(NSString *)extension
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:extension];
    return filePath;
}
@end
