//
// Created by Sergei Borisov on 07/03/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import "SBChosenCurrency.h"
#import "SBDataProviderProtocol.h"
#import "SBRateDataProtocol.h"


@interface SBChosenCurrency ()

@property(nonatomic, copy) NSString *currentCurrencyCode;

@property(nonatomic, strong) id <SBDataProviderProtocol> dataProvider;

@property(nonatomic, weak) id <SBChosenCurrencyDelegate> delegate;

@end

@implementation SBChosenCurrency
{

}

- (instancetype)initWithCurrentCurrencyCode:(NSString *)currentCurrencyCode
                               dataProvider:(id <SBDataProviderProtocol>)dataProvider
{
    self = [super init];
    if (self) {
        self.currentCurrencyCode = currentCurrencyCode;
        self.dataProvider = dataProvider;

        if (self.currentCurrencyCode == nil) {
            self.currentCurrencyCode = [self.dataProvider rateByIndex:0].code;
        }
    }

    NSAssert(self.currentCurrencyCode, @"currentCurrencyCode must be not nil");
    NSAssert(self.dataProvider, @"dataProvider must be not nil");

    return self;
}

+ (instancetype)currencyWithCurrentCurrencyCode:(NSString *)currentCurrencyCode
                                   dataProvider:(id <SBDataProviderProtocol>)dataProvider
{
    return [[self alloc] initWithCurrentCurrencyCode:currentCurrencyCode dataProvider:dataProvider];
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.currentCurrencyCode=%@", self.currentCurrencyCode];
    [description appendFormat:@", self.dataProvider=%@", self.dataProvider];
    [description appendString:@">"];
    return description;
}

#pragma mark implement SBChosenCurrencyProtocol

- (id <SBRateDataProtocol>)currentRate
{
    return [self.dataProvider rateByCode:self.currentCurrencyCode];
}

#pragma mark implement SBPickerDataProtocol

- (NSUInteger)count
{
    return self.dataProvider.count;
}

- (NSString *)stringForIndex:(NSUInteger)index
{
    return [self.dataProvider rateByIndex:index].name;
}

- (void)selectIndex:(NSUInteger)index
{
    if (index >= self.dataProvider.count) {
        NSString *message = [NSString stringWithFormat:@"Index %d more then count %d", index, self.dataProvider.count];
        @throw [NSException exceptionWithName:@"SBChoosenCurrencyOutOfOndex"
                                       reason:message
                                     userInfo:nil];
    }

    id<SBRateDataProtocol> newCurrency = [self.dataProvider rateByIndex:index];
    if ([newCurrency.code isEqualToString:self.currentCurrencyCode]) {
        return;
    }

    self.currentCurrencyCode = newCurrency.code;

    [self fireChanged];
}

#pragma mark internal

- (void)fireChanged
{
    if (!self.delegate) {
        return;
    }
    [self.delegate changedChosenCurrency:self];
}

@end