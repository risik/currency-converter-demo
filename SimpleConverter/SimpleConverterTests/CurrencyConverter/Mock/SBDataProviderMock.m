//
// Created by Sergei Borisov on 07/03/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import "SBDataProviderMock.h"

@implementation SBDataProviderMock
{

}

- (NSUInteger)count
{
    if (self.countBlock) {
        return self.countBlock();
    }
    return 0;
}

- (id <SBRateDataProtocol>)rateByCode:(NSString *)currencyCode
{
    if (self.rateByCodeBlock) {
        return self.rateByCodeBlock(currencyCode);
    }
    return nil;
}

- (id <SBRateDataProtocol>)rateByIndex:(NSUInteger)index
{
    if (self.rateByIndexBlock) {
        return self.rateByIndexBlock(index);
    }
    return nil;
}

@end