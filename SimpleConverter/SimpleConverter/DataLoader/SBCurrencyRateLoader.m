//
// Created by Sergei Borisov on 20/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import "SBCurrencyRateLoader.h"
#import "SBDataLoaderFactoryProtocol.h"
#import "SBDataLoaderProtocol.h"
#import "SBDataSaverProtocol.h"
#import "SBInternetStatusProtocol.h"
#import <TBStateMachine/TBSMStateMachine.h>


@interface SBCurrencyRateLoader () <SBInternetStatusDelegate>

@property(nonatomic, strong) TBSMState *stateStart;
@property(nonatomic, strong) TBSMState *stateNoData;
@property(nonatomic, strong) TBSMState *stateFirstRetrieving;
@property(nonatomic, strong) TBSMState *stateUpdating;
@property(nonatomic, strong) TBSMState *stateReady;
@property(nonatomic, strong) TBSMState *stateReadyOutdated;
@property(nonatomic, strong) TBSMState *stateWrong;

@property(nonatomic, strong) TBSMEvent *eventNoDataNotReachable;
@property(nonatomic, strong) TBSMEvent *eventNoDataReachable;
@property(nonatomic, strong) TBSMEvent *eventOutdatedDataReachable;
@property(nonatomic, strong) TBSMEvent *eventOutdatedNotReachable;
@property(nonatomic, strong) TBSMEvent *eventErrorLoading;
@property(nonatomic, strong) TBSMEvent *eventErrorParsing;
@property(nonatomic, strong) TBSMEvent *eventBecomeReachable;
@property(nonatomic, strong) TBSMEvent *eventLoaded;
@property(nonatomic, strong) TBSMEvent *eventRetry;

@property(nonatomic, strong) TBSMStateMachine *stateMachine;

@property(nonatomic, strong) id <SBDataLoaderFactoryProtocol> dataLoaderFactory;
@property(nonatomic, strong) id <SBDataSaverProtocol> saver;
@property(nonatomic, strong) id <SBInternetStatusProtocol> internetStatus;

@end

@implementation SBCurrencyRateLoader
{

}
- (instancetype)initWithDataLoaderFactory:(id <SBDataLoaderFactoryProtocol>)dataLoaderFactory
                                    saver:(id <SBDataSaverProtocol>)saver
                           internetStatus:(id <SBInternetStatusProtocol>)internetStatus
{
    self = [super init];
    if (self) {
        self.dataLoaderFactory = dataLoaderFactory;

        self.saver = saver;

        self.internetStatus = internetStatus;
        [self.internetStatus setDelegate:self];

        [self createStateMachine];
    }

    NSAssert(self.dataLoaderFactory, @"dataLoaderFactory required");
    NSAssert(self.saver, @"saver required");
    NSAssert(self.internetStatus, @"internetStatus required");

    return self;
}

+ (instancetype)loaderWithDataLoaderFactory:(id <SBDataLoaderFactoryProtocol>)dataLoaderFactory
                                      saver:(id <SBDataSaverProtocol>)saver
                             internetStatus:(id <SBInternetStatusProtocol>)internetStatus
{
    return [[self alloc] initWithDataLoaderFactory:dataLoaderFactory saver:saver internetStatus:internetStatus];
}

- (void)retry
{
    [self.stateMachine scheduleEvent:self.eventRetry];
}


- (void)createStateMachine
{
    self.stateStart = [TBSMState stateWithName:@"stateStart"];
    self.stateNoData = [TBSMState stateWithName:@"stateNoData"];;
    self.stateFirstRetrieving = [TBSMState stateWithName:@"stateFirstRetrieving"];;
    self.stateUpdating = [TBSMState stateWithName:@"stateUpdating"];;
    self.stateReady = [TBSMState stateWithName:@"stateReady"];;
    self.stateReadyOutdated = [TBSMState stateWithName:@"stateReadyOutdated"];;
    self.stateWrong = [TBSMState stateWithName:@"stateWrong"];;

    self.eventNoDataNotReachable = [TBSMEvent eventWithName:@"eventNoDataNotReachable"];
    self.eventNoDataReachable = [TBSMEvent eventWithName:@"eventNoDataReachable"];
    self.eventOutdatedDataReachable = [TBSMEvent eventWithName:@"eventOutdatedDataReachable"];
    self.eventOutdatedNotReachable = [TBSMEvent eventWithName:@"eventOutdatedNotReachable"];
    self.eventErrorLoading = [TBSMEvent eventWithName:@"eventErrorLoading"];
    self.eventErrorParsing = [TBSMEvent eventWithName:@"eventErrorParsing"];
    self.eventBecomeReachable = [TBSMEvent eventWithName:@"eventBecomeReachable"];
    self.eventLoaded = [TBSMEvent eventWithName:@"eventLoaded"];
    self.eventRetry = [TBSMEvent eventWithName:@"eventRetry"];

    __weak typeof(self) weakSelf = self;

    self.stateStart.enterBlock = ^(TBSMState *sourceState, TBSMState *destinationState, NSDictionary *data)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.saver.hasData) {
            if (strongSelf.internetStatus.reachable) {
                [strongSelf.stateMachine scheduleEvent:strongSelf.eventOutdatedDataReachable];
            }
            else {
                [strongSelf.stateMachine scheduleEvent:strongSelf.eventOutdatedNotReachable];
            }
        }
        else {
            if (strongSelf.internetStatus.reachable) {
                [strongSelf.stateMachine scheduleEvent:strongSelf.eventNoDataReachable];
            }
            else {
                [strongSelf.stateMachine scheduleEvent:strongSelf.eventNoDataNotReachable];
            }
        }
    };

    self.stateNoData.enterBlock = ^(TBSMState *sourceState, TBSMState *destinationState, NSDictionary *data)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate dataLoaderReachNoData:strongSelf];
        }
    };

    self.stateReady.enterBlock = ^(TBSMState *sourceState, TBSMState *destinationState, NSDictionary *data)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate dataLoaderReachReady:strongSelf];
        }
    };

    self.stateWrong.enterBlock = ^(TBSMState *sourceState, TBSMState *destinationState, NSDictionary *data)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate dataLoaderReachWrong:strongSelf];
        }
    };

    [self.stateStart registerEvent:self.eventNoDataNotReachable target:self.stateNoData];

    [self.stateStart registerEvent:self.eventNoDataReachable target:self.stateFirstRetrieving action:^(TBSMState *sourceState, TBSMState *destinationState, NSDictionary *data)
    {
        NSLog(@"transit from: %@ to %@", sourceState.name, destinationState.name);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf loadAndSaveData];
    }];

    [self.stateStart registerEvent:self.eventOutdatedDataReachable target:self.stateUpdating action:^(TBSMState *sourceState, TBSMState *destinationState, NSDictionary *data)
    {
        NSLog(@"transit from: %@ to %@", sourceState.name, destinationState.name);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf loadAndSaveData];
    }];

    [self.stateStart registerEvent:self.eventOutdatedNotReachable target:self.stateReadyOutdated action:^(TBSMState *sourceState, TBSMState *destinationState, NSDictionary *data)
    {
        NSLog(@"transit from: %@ to %@", sourceState.name, destinationState.name);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate dataLoaderReachOutdated:strongSelf];
        }
    }];

    [self.stateFirstRetrieving registerEvent:self.eventErrorLoading target:self.stateNoData];
    [self.stateFirstRetrieving registerEvent:self.eventErrorParsing target:self.stateWrong];
    [self.stateFirstRetrieving registerEvent:self.eventLoaded target:self.stateReady];

    [self.stateNoData registerEvent:self.eventBecomeReachable target:self.stateFirstRetrieving];

    [self.stateUpdating registerEvent:self.eventErrorLoading target:self.stateReadyOutdated];
    [self.stateUpdating registerEvent:self.eventErrorParsing target:self.stateWrong];
    [self.stateUpdating registerEvent:self.eventLoaded target:self.stateReady];

    [self.stateReadyOutdated registerEvent:self.eventBecomeReachable target:self.stateUpdating];

    [self.stateWrong registerEvent:self.eventRetry target:self.stateStart];


    self.stateMachine = [TBSMStateMachine stateMachineWithName:@"SBCurrencyRateLoader"];
    self.stateMachine.states = @[
            self.stateStart,
            self.stateNoData,
            self.stateFirstRetrieving,
            self.stateUpdating,
            self.stateReady,
            self.stateReadyOutdated,
            self.stateWrong,
    ];
#pragma clang diagnostic push
#pragma ide diagnostic ignored "SetterForReadonlyProperty"
    [self.stateMachine setInitialState:self.stateStart];
#pragma clang diagnostic pop
    [self.stateMachine setUp];

}

- (void)loadAndSaveData
{
    if (self.delegate) {
        [self.delegate dataLoaderStartUpdating:self];
    }

    id <SBDataLoaderProtocol> currencyLoader = [self.dataLoaderFactory createDataLoaderWithUrl:@"currencies.json"];
    [currencyLoader loadDataWithCompletion:^(NSData *data, NSError *error)
    {
        if (error) {
            NSLog(@"Load error: %@", error);
            [self.stateMachine scheduleEvent:self.eventErrorLoading];
            return;
        }

        [self processCurrenciesLoadedWithData:data];
    }];
}

- (void)processCurrenciesLoadedWithData:(NSData *)currenciesData
{
    id <SBDataLoaderProtocol> ratesLoader = [self.dataLoaderFactory createDataLoaderWithUrl:@"latest.json"];
    [ratesLoader loadDataWithCompletion:^(NSData *ratesData, NSError *error)
    {
        if (error) {
            NSLog(@"Load error: %@", error);
            [self.stateMachine scheduleEvent:self.eventErrorLoading];
            return;
        }

        [self processRatesLoadedWithCurrenciesData:currenciesData ratesData:ratesData];
    }];
}

- (void)processRatesLoadedWithCurrenciesData:(NSData *)currenciesData ratesData:(NSData *)ratesData
{
    NSError *error = nil;
    if (![self.saver saveCurrencies:currenciesData andRates:ratesData error:&error]) {
        NSLog(@"Load error: %@", error);
        [self.stateMachine scheduleEvent:self.eventErrorParsing];
        return;
    }

    [self.stateMachine scheduleEvent:self.eventLoaded];
}

- (void)internetBecomeReachable:(id <SBInternetStatusProtocol>)internetReachable
{
    if (self.stateMachine.currentState == self.stateReadyOutdated) {
        [self.stateMachine scheduleEvent:self.eventBecomeReachable];
    }

    if (self.stateMachine.currentState == self.stateNoData) {
        [self.stateMachine scheduleEvent:self.eventBecomeReachable];
    }
}

@end