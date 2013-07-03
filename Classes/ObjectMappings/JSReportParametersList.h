//
//  JSReportParametersList.h
//  jaspersoft-sdk
//
//  Created by Vlad Zavadskii on 07.11.12.
//  Copyright (c) 2012 Jaspersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @author Vlad Zavadskii vzavadskii@jaspersoft.com
 @since 1.4
 */
@interface JSReportParametersList : NSObject

@property (nonatomic, retain) NSArray* /*<JSReportParameter>*/ reportParameters;

- (id)initWithReportParameters:(NSArray *)reportParameters;

@end
