//
// Created by Sergei Borisov on 20/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SBCurrencyRateLoaderDelegate;
@protocol SBDataLoaderFactoryProtocol;
@protocol SBDataSaverProtocol;
@protocol SBInternetStatusProtocol;

@interface SBCurrencyRateLoader : NSObject

@property (nonatomic, weak) id<SBCurrencyRateLoaderDelegate> delegate;

- (instancetype)initWithDataLoaderFactory:(id <SBDataLoaderFactoryProtocol>)dataLoaderFactory
                                    saver:(id <SBDataSaverProtocol>)saver
                           internetStatus:(id <SBInternetStatusProtocol>)internetStatus;

+ (instancetype)loaderWithDataLoaderFactory:(id <SBDataLoaderFactoryProtocol>)dataLoaderFactory
                                      saver:(id <SBDataSaverProtocol>)saver
                             internetStatus:(id <SBInternetStatusProtocol>)internetStatus;


@end

@protocol SBCurrencyRateLoaderDelegate

- (void)dataLoaderStartUpdating:(SBCurrencyRateLoader *)dataLoader;

- (void)dataLoaderReachReady:(SBCurrencyRateLoader *)dataLoader;

- (void)dataLoaderReachOutdated:(SBCurrencyRateLoader *)dataLoader;

- (void)dataLoaderReachNoData:(SBCurrencyRateLoader *)dataLoader;

- (void)dataLoaderReachWrong:(SBCurrencyRateLoader *)dataLoader;

@end
