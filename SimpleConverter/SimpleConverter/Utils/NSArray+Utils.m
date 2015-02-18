//
// Created by Sergei Borisov on 14/02/15.
// Copyright (c) 2015 Sergei Borisov . All rights reserved.
//

#import "NSArray+Utils.h"
#import "NSObject+Utils.h"


@implementation NSArray (Utils)

+ (BOOL)isEmpty:(NSArray *)object
{
    if ([NSObject isNil:object]) {
        return YES;
    }
    if (![object isKindOfClass:[NSArray class]]) {
        return YES;
    }
    NSArray *array = object;
    if (array.count == 0) {
        return YES;
    }
    return NO;
}


@end