//
// Created by Sergei Borisov on 15/02/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import "NSString+Utils.h"


@implementation NSString (Utils)

+ (BOOL)isEmpty:(id)str
{
    if (str == nil) {
        return YES;
    }
    if (str == (id)[NSNull null]) {
        return YES;
    }
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([str isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end