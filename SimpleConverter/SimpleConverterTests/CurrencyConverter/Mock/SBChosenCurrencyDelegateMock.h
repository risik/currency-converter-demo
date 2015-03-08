//
// Created by Sergei Borisov on 08/03/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBChosenCurrencyProtocol.h"


@interface SBChosenCurrencyDelegateMock : NSObject <SBChosenCurrencyDelegate>

typedef void(^SBChosenCurrencyDelegateMockChangedBlock)(id <SBChosenCurrencyProtocol> chosenCurrency);

@property (nonatomic, copy) SBChosenCurrencyDelegateMockChangedBlock changedBlock;

@end