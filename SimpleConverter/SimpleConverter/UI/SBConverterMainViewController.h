//
//  SBConverterMainViewController.h
//  SimpleConverter
//
//  Created by Sergei Borisov on 20/02/15.
//  Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SBConverterMainViewControllerDelegate;
@interface SBConverterMainViewController : UIViewController

@property (nonatomic, weak) id<SBConverterMainViewControllerDelegate> delegate;

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

+ (instancetype)controllerWithContext:(NSManagedObjectContext *)context;


- (void)showBusy;

- (void)makeReady;

- (void)enableRetry;
@end

@protocol SBConverterMainViewControllerDelegate

- (void)retryPressed;

@end