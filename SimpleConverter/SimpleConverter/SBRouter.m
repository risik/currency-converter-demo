//
// Created by Sergei Borisov on 20/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import "SBRouter.h"
#import <UIKit/UIKit.h>

#import "SBCurrencyRateLoader.h"
#import "SBInternetStatus.h"
#import "SBDataSaver.h"
#import "SBCurrencyRateSaver.h"
#import "SBDataLoaderFactory.h"
#import "SBConverterMainViewController.h"


@interface SBRouter () <SBCurrencyRateLoaderDelegate, SBConverterMainViewControllerDelegate>

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property(nonatomic, strong) UIWindow *window;

@property(nonatomic, strong) SBConverterMainViewController *mainVC;

@property(nonatomic, strong) SBCurrencyRateLoader *loader;

@end

@implementation SBRouter
{

}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext window:(UIWindow *)window
{
    self = [super init];
    if (self) {
        self.managedObjectContext = managedObjectContext;
        self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
        self.window = window;
    }

    return self;
}

+ (instancetype)routerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext window:(UIWindow *)window
{
    return [[self alloc] initWithManagedObjectContext:managedObjectContext window:window];
}

- (void)start
{
    NSString *baseUrl = @"http://dhdcompany.com/2gis-demo/currency";
    id <SBDataLoaderFactoryProtocol> dataLoaderFactory = [[SBDataLoaderFactory alloc] initWithBaseUrl:baseUrl
                                                                                               suffix:nil];
    id <SBCurrencyRateSaverProtocol> currencyRateSaver = [SBCurrencyRateSaver saverWithContext:self.managedObjectContext];
    id <SBDataSaverProtocol> dataSaver = [SBDataSaver saverWithCurrencyRateSaver:currencyRateSaver];
    id <SBInternetStatusProtocol> internetStatus = [[SBInternetStatus alloc] init];

    self.mainVC = [[SBConverterMainViewController alloc] initWithContext:self.managedObjectContext];
    self.mainVC.delegate = self;

    [self makeRootController:self.mainVC];

    self.loader = [SBCurrencyRateLoader loaderWithDataLoaderFactory:dataLoaderFactory
                                                              saver:dataSaver
                                                     internetStatus:internetStatus];
    self.loader.delegate = self;
}

- (void)makeRootController:(UIViewController *)viewController
{
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];

}

#pragma mark data loader delegate methods

- (void)dataLoaderStartUpdating:(SBCurrencyRateLoader *)dataLoader
{
    [self.mainVC showBusy];
}

- (void)dataLoaderReachReady:(SBCurrencyRateLoader *)dataLoader
{
    [self.mainVC makeReady];
}

- (void)dataLoaderReachOutdated:(SBCurrencyRateLoader *)dataLoader
{
    [self showWarning];
    [self.mainVC makeReady];
}

- (void)dataLoaderReachNoData:(SBCurrencyRateLoader *)dataLoader
{
    [self.mainVC enableRetry];
    [self showErrorNoData];
}

- (void)dataLoaderReachWrong:(SBCurrencyRateLoader *)dataLoader
{
    [self.mainVC enableRetry];
    [self showErrorSomethingWentWrong];
}

#pragma mark main view controller's delegates

- (void)retryPressed
{
    [self.loader retry];
}

#pragma mark internal

- (void)showWarning
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Currency exchange rate outdated but no internet connection to load data"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showErrorSomethingWentWrong
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Something went wrong"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)showErrorNoData
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"No data loaded. No internet connection to load data"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


@end