//
// Created by Sergei Borisov on 15/02/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import "NSObject+Utils.h"


@implementation NSObject (Utils)

+ (BOOL)isNil:(id)object
{
    if (object == nil) {
        return YES;
    }
    if (object == (id)[NSNull null]) {
        return YES;
    }
    return NO;
}

@end