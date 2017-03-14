/*
 * Copyright © 2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.6
 */

#import <Foundation/Foundation.h>
#import "JSRESTBase.h"

@interface JSFileSaver : NSObject
+ (void)downloadResourceWithRestClient:(nonnull JSRESTBase *)restClient
                         fromURLString:(nonnull NSString *)resourceURLString
                       destinationPath:(nonnull NSString *)destinationPath
                            completion:(void(^_Nullable)(NSError * _Nullable error))completion;

@end
