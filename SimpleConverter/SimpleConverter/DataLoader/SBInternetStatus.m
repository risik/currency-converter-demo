//
// Created by Sergei Borisov on 20/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import "SBInternetStatus.h"
#import <Reachability/Reachability.h>


@interface SBInternetStatus ()

@property(nonatomic, weak) id <SBInternetStatusDelegate> delegateImpl;

@property(nonatomic, strong) Reachability *reachability;

@end


@implementation SBInternetStatus
{

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.reachability = [Reachability reachabilityForInternetConnection];
        [self configBecomeReachability];
    }

    return self;
}

- (void)configBecomeReachability
{
    __weak typeof(self) weakSelf = self;
    self.reachability.reachableBlock = ^(Reachability *reachability)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegateImpl) {
            [strongSelf.delegateImpl internetBecomeReachable:strongSelf];
        }
    };
}

- (BOOL)reachable
{
    return self.reachability.currentReachabilityStatus != NotReachable;
}

- (void)setDelegate:(id <SBInternetStatusDelegate>)newDelegate
{
    self.delegateImpl = newDelegate;
}

@end