//
// Created by Sergei Borisov on 20/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBDataLoaderFactoryProtocol.h"


@interface SBDataLoaderFactory : NSObject <SBDataLoaderFactoryProtocol>
- (instancetype)initWithBaseUrl:(NSString *)baseUrl suffix:(NSString *)suffix;

+ (instancetype)factoryWithBaseUrl:(NSString *)baseUrl suffix:(NSString *)suffix;

@end