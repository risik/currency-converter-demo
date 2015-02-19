//
// Created by Sergei Borisov on 19/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBCurrencyRateSaverProtocol.h"


@interface SBCurrencyRateSaverMock : NSObject <SBCurrencyRateSaverProtocol>

typedef BOOL (^SBCurrencyRateSaverMockSaveCurrenciesBlock)(NSDictionary *currenciesDictionary, NSDictionary *ratesDictionary, NSError **pError);
@property (nonatomic, copy) SBCurrencyRateSaverMockSaveCurrenciesBlock saveCurrenciesBlock;

@end