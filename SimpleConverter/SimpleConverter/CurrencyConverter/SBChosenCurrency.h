//
// Created by Sergei Borisov on 07/03/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBChosenCurrencyProtocol.h"
#import "SBPickerDataProtocol.h"

@protocol SBDataProviderProtocol;


@interface SBChosenCurrency : NSObject
        <
        SBChosenCurrencyProtocol,
        SBPickerDataProtocol
        >
- (instancetype)initWithCurrentCurrencyCode:(NSString *)currentCurrencyCode
                               dataProvider:(id <SBDataProviderProtocol>)dataProvider;

- (NSString *)description;

+ (instancetype)currencyWithCurrentCurrencyCode:(NSString *)currentCurrencyCode
                                   dataProvider:(id <SBDataProviderProtocol>)dataProvider;

@end