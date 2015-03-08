//
// Created by Sergei Borisov on 08/03/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import "SBChosenCurrencyDelegateMock.h"


@implementation SBChosenCurrencyDelegateMock
{

}

- (void)changedChosenCurrency:(id <SBChosenCurrencyProtocol>)chosenCurrency
{
    if (self.changedBlock) {
        self.changedBlock(chosenCurrency);
    }
}

@end