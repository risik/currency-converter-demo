//
// Created by Sergei Borisov on 15/02/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import "NSDictionary+Utils.h"


@implementation NSDictionary (Utils)

+ (BOOL)isDictionary:(id)object
{
    if (object == nil) {
        return NO;
    }
    if (object == (id)[NSNull null]) {
        return NO;
    }
    if (![object isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    return YES;
}

+ (BOOL)isEmpty:(id)object
{
    if (![NSDictionary isDictionary:object]) {
        return YES;
    }

    NSDictionary *dict = object;
    if (dict.count == 0) {
        return YES;
    }

    return NO;
}


@end