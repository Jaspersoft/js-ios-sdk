/*
 * Copyright ©  2016 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.5
 */


#import <Foundation/Foundation.h>
#import "EKObjectMapping.h"
#import "JSProfile.h"

/**
 Declares method that a class must implement so that it can provide support of
 representing object as string
 */

@protocol JSObjectMappingsProtocol <NSObject>

@required
/**
 Returns a `EKObjectMapping` object for serialize/deserialize objects of the class.
 @param serverProfile Server Profile for configuring mapping according to server version
 @return A `EKObjectMapping` object for serialize/deserialize objects of the class.
 */
+ (nonnull EKObjectMapping *)objectMappingForServerProfile:(nonnull JSProfile *)serverProfile;

@optional

/**
 Returns a keyPath of `NSString` type for serializing objects of the class to request.
 @return a keyPath of `NSString` type for serializing objects of the class to request.
 */
+ (nonnull NSString *)requestObjectKeyPath;

@end
