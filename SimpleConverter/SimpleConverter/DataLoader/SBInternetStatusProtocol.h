//
// Created by Sergei Borisov on 20/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SBInternetStatusDelegate;

@protocol SBInternetStatusProtocol <NSObject>

- (BOOL)reachable;

- (void)setDelegate:(id<SBInternetStatusDelegate>)newDelegate;

@end

@protocol SBInternetStatusDelegate

- (void)internetBecomeReachable:(id<SBInternetStatusProtocol>)internetReachable;

@end
