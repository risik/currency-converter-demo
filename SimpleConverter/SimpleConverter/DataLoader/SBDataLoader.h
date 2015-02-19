//
// Created by Sergei Borisov on 15/02/15.
// Copyright (c) 2015 Redmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBDataLoaderProtocol.h"

@interface SBDataLoader : NSObject <SBDataLoaderProtocol>

- (instancetype)initWithUrl:(NSString *)url;

+ (instancetype)dataLoaderWithUrl:(NSString *)url;

@end