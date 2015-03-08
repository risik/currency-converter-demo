//
// Created by Sergei Borisov on 07/03/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SBRateDataProtocol <NSObject>

- (NSString *)code;
- (NSNumber *)rate;
- (NSString *)name;

@end