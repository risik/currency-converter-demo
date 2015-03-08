//
// Created by Sergei Borisov on 07/03/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import "SBRateDataMock.h"


@implementation SBRateDataMock
{
    NSString *_code;
    NSString *_name;
    NSNumber *_rate;
}

- (instancetype)initWithCode:(NSString *)code name:(NSString *)name rate:(NSNumber *)rate
{
    self = [super init];
    if (self) {
        _code = code;
        _name = name;
        _rate = rate;
    }

    return self;
}

+ (instancetype)mockWithCode:(NSString *)code name:(NSString *)name rate:(NSNumber *)rate
{
    return [[self alloc] initWithCode:code name:name rate:rate];
}

- (NSString *)code
{
    return _code;
}

- (NSNumber *)rate
{
    return _rate;
}

- (NSString *)name
{
    return _name;
}


@end