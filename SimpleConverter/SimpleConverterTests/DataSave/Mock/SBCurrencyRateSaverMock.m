//
// Created by Sergei Borisov on 19/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import "SBCurrencyRateSaverMock.h"


@implementation SBCurrencyRateSaverMock
{

}

- (BOOL)saveCurrencies:(NSDictionary *)currenciesDictionary andRates:(NSDictionary *)ratesDictionary error:(NSError **)pError
{
    if (self.saveCurrenciesBlock) {
        return self.saveCurrenciesBlock(currenciesDictionary, ratesDictionary, pError);
    }
    return NO;
}

@end