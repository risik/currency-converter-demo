//
// Created by Sergei Borisov on 07/03/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBRateDataProtocol.h"


@interface SBRateDataMock : NSObject <SBRateDataProtocol>

- (instancetype)initWithCode:(NSString *)code name:(NSString *)name rate:(NSNumber *)rate;

+ (instancetype)mockWithCode:(NSString *)code name:(NSString *)name rate:(NSNumber *)rate;

@end