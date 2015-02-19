//
// Created by Sergei Borisov on 20/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SBDataLoaderProtocol;

@protocol SBDataLoaderFactoryProtocol <NSObject>

- (id<SBDataLoaderProtocol>)createDataLoaderWithUrl:(NSString *)url;

@end