//
// Created by Sergei Borisov on 14/02/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import "NSNumber+Utils.h"


@implementation NSNumber (Utils)

+ (BOOL)isNumber:(NSNumber *)object
{
    if (object == nil) {
        return NO;
    }
    if (object == (id)[NSNull null]) {
        return NO;
    }
    if (![object isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    return YES;
}

@end