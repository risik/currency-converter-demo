//
// Created by Sergei Borisov on 19/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import "SBDataSaver.h"
#import "SBCurrencyRateSaverProtocol.h"
#import "NSDictionary+Utils.h"


@interface SBDataSaver ()

@property(nonatomic, strong) id <SBCurrencyRateSaverProtocol> currencyRateSaver;

@end


@implementation SBDataSaver
{

}

- (instancetype)initWithCurrencyRateSaver:(id <SBCurrencyRateSaverProtocol>)currencyRateSaver
{
    self = [super init];
    if (self) {
        self.currencyRateSaver = currencyRateSaver;
    }

    NSAssert(self.currencyRateSaver, @"currencyRateSaver required");

    return self;
}

+ (instancetype)saverWithCurrencyRateSaver:(id <SBCurrencyRateSaverProtocol>)currencyRateSaver
{
    return [[self alloc] initWithCurrencyRateSaver:currencyRateSaver];
}

- (BOOL)saveCurrencies:(NSData *)currenciesData andRates:(NSData *)ratesData error:(NSError **)pError
{
    NSError *error;

    if (currenciesData == nil) {
        [self fillError:pError withErrorCode:SBDataSaverErrorInvalidDictionary withUserInfo:nil];
        return NO;
    }

    NSDictionary *currenciesDictionary = [NSJSONSerialization JSONObjectWithData:currenciesData
                                                                         options:0
                                                                           error:&error];
    if (error) {
        *pError = error;
        return NO;
    }

    if (ratesData == nil) {
        [self fillError:pError withErrorCode:SBDataSaverErrorInvalidDictionary withUserInfo:nil];
        return NO;
    }

    NSDictionary *ratesDictionary = [NSJSONSerialization JSONObjectWithData:ratesData
                                                                    options:0
                                                                      error:&error];
    if (error) {
        *pError = error;
        return NO;
    }

    if ([NSDictionary isEmpty:ratesDictionary]) {
        NSLog(@"Couldn't parsing rates: not dictionary");
        [self fillError:pError withErrorCode:SBDataSaverErrorInvalidDictionary withUserInfo:nil];
        return NO;
    }

    NSDictionary *internalRates = ratesDictionary[@"rates"];

    if ([NSDictionary isEmpty:internalRates]) {
        NSLog(@"Couldn't parsing rates: not dictionary");
        [self fillError:pError withErrorCode:SBDataSaverErrorInvalidDictionary withUserInfo:nil];
        return NO;
    }

    return [self.currencyRateSaver saveCurrencies:currenciesDictionary andRates:internalRates error:pError];
}

- (BOOL)hasData
{
    return self.currencyRateSaver.hasData;
}


#pragma mark internal

- (void)fillError:(NSError **)pError withErrorCode:(int)errorCode withUserInfo:(NSDictionary *)userInfo
{
    if (!pError) {
        return;
    }
    *pError = [NSError errorWithDomain:@"SBDataSaver" code:errorCode userInfo:userInfo];
}

@end