//
// Created by Sergei Borisov on 20/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SBDataLoaderCompletion)(NSData *, NSError *);
@protocol SBDataLoaderProtocol <NSObject>

- (void)loadDataWithCompletion:(SBDataLoaderCompletion)completion;

@end