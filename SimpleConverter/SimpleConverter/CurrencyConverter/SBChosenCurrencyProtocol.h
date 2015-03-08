//
// Created by Sergei Borisov on 07/03/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SBChosenCurrencyDelegate;
@protocol SBRateDataProtocol;

@protocol SBChosenCurrencyProtocol <NSObject>

- (id <SBRateDataProtocol>)currentRate;

- (void)setDelegate:(id<SBChosenCurrencyDelegate>)delegate;

@end

@protocol SBChosenCurrencyDelegate

- (void)changedChosenCurrency:(id<SBChosenCurrencyProtocol>)chosenCurrency;

@end