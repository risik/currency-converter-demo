//
// Created by Sergei Borisov on 19/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SBDataSaverErrorOk = 0,
    SBDataSaverErrorInvalidDictionary,
} SBDataSaverError;

@protocol SBDataSaverProtocol <NSObject>

- (BOOL)saveCurrencies:(NSData *)currenciesData
              andRates:(NSData *)ratesData
                 error:(NSError **)pError;

@end