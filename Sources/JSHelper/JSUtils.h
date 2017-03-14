/*
 * Copyright © 2015 - 2017. TIBCO Software Inc. All Rights Reserved. Confidential & Proprietary.
 */


/**
 @author Oleksii Gubariev ogubarie@tibco.com
 @since 2.3
 */


#import <Foundation/Foundation.h>

@class JSReportParameter, JSInputControlDescriptor;

@interface JSUtils : NSObject

/**
 Get string representation for Boolean value
 
 @param aBOOL A Boolean value
 @return A new string @"true" or @"false" depends on provided Boolean value
 
 @since 2.3
 */
+ (nonnull NSString *)stringFromBOOL:(BOOL)aBOOL;

/**
 Get Bolean representation for string value
 
 @param aString A String value @"true" or @"false"
 @return A BOOL depends on provided string value
 
 @since 2.3
 */
+ (BOOL)BOOLFromString:(nonnull NSString *)aString;

/**
 Get string identifier for Keychain
 
 @return A string identifier for Keychain in format <YOUR_APP_BUNDLE_ID.GenericKeychainSuite>
 
 @since 2.3
 */
+ (nonnull NSString *)keychainIdentifier;

/**
 Get localized string if it's available or english string if it doesn't found
 
 @param key A key for localisation
 @return A localized string if it's available or english string if it doesn't found
 
 @since 2.3
 */
+ (nonnull NSString *)localizedStringForKey:(nonnull NSString *)key comment:(nullable NSString *)comment;

/**
 Get array of report parameters from array of input controls
 
 @param inputControls An array of JSInputControlDescriptor
 @return An array of JSReportParameter, generated from inputControls.
 
 @since 2.3
 */
+ (nonnull NSArray <JSReportParameter *> *)reportParametersFromInputControls:(nonnull NSArray <JSInputControlDescriptor *> *)inputControls;

/**
 @name REST API Preferences
 */

/**
 Get Content-Type, used for communicating with JRS instance
 
 @return A Content-Type string, used for communicating with JRS instance
 
 @since 2.3
 */
+ (nonnull NSString *)usedMimeType;

/**
 Get timeout interval for check server availability in seconds
 
 @return A timeout interval for check server availability in seconds
 
 @since 2.3
 */
+ (NSTimeInterval) checkServerConnectionTimeout;

/**
 Get dictionary with all supported locales in app
 
 @return A dictionary with all supported locales in app
 
 @since 2.3
 */
+ (nonnull NSDictionary *)supportedLocales;

/**
 Get background session configuration identifier, used for background tasks
 
 @return A background session configuration identifier, used for background tasks
 
 @since 2.3
 */
+ (nonnull NSString *)backgroundSessionConfigurationIdentifier;

/**
 Get minimal supported version of JRS
 
 @return A minimal supported version of JRS
 
 @since 2.5
 */
+ (float) minSupportedServerVersion;

@end

/**
 Get localized string if it's available or english string if it doesn't found
 
 @param key A key for localisation
 @return A localized string if it's available or english string if it doesn't found
 
 @since 2.3
 */
NSString *__nonnull JSCustomLocalizedString(NSString *__nonnull key, NSString *__nullable comment);
