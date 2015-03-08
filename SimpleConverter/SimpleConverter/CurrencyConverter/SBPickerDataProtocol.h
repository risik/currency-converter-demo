//
// Created by Sergei Borisov on 07/03/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SBPickerDataProtocol <NSObject>

- (NSUInteger)count;

- (NSString *)stringForIndex:(NSUInteger)index;

- (void)selectIndex:(NSUInteger)index;

@end