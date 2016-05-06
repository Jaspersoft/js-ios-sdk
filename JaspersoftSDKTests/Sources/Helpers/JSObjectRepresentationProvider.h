//
//  JSObjectRepresentationProvider.h
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 4/26/16.
//
//

#import <Foundation/Foundation.h>

@interface JSObjectRepresentationProvider : NSObject

+ (id)JSONObjectForClass:(Class)class;

+ (id)JSONObjectFromFileNamed:(NSString *)fileName;

@end
