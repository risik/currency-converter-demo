//
// Created by Sergei Borisov on 14/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SBCurrencyRateSaverProtocol <NSObject>

- (BOOL)saveCurrencies:(NSDictionary *)currenciesDictionary
              andRates:(NSDictionary *)ratesDictionary
                 error:(NSError **)pError;

@end