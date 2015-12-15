//
//  JSReportExecutorConfiguration.h
//  JaspersoftSDK
//
//  Created by Oleksii Gubariev on 12/15/15.
//
//

#import <Foundation/Foundation.h>
#import "JSReportPagesRange.h"

@class JSRESTBase;

@interface JSReportExecutorConfiguration : NSObject

@property (nonatomic, strong, nonnull) JSRESTBase *restClient;

@property (nonatomic, assign) BOOL asyncExecution;
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, assign) BOOL freshData;
@property (nonatomic, assign) BOOL saveDataSnapshot;
@property (nonatomic, assign) BOOL ignorePagination;
@property (nonatomic, strong, nullable) NSString *transformerKey;
@property (nonatomic, strong, nonnull) NSString *outputFormat;
@property (nonatomic, strong, nonnull) NSString *attachmentsPrefix;
@property (nonatomic, strong, nonnull) JSReportPagesRange *pagesRange;


+(nonnull instancetype)defaultConfigurationWithRestClient:(nonnull JSRESTBase *)restClient;

+(nonnull instancetype)saveReportConfigurationWithRestClient:(nonnull JSRESTBase *)restClient;

@end
