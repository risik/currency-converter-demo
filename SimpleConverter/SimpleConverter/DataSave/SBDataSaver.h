//
// Created by Sergei Borisov on 19/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBDataSaverProtocol.h"

@protocol SBCurrencyRateSaverProtocol;


@interface SBDataSaver : NSObject <SBDataSaverProtocol>

- (instancetype)initWithCurrencyRateSaver:(id <SBCurrencyRateSaverProtocol>)currencyRateSaver;

+ (instancetype)saverWithCurrencyRateSaver:(id <SBCurrencyRateSaverProtocol>)currencyRateSaver;

@end