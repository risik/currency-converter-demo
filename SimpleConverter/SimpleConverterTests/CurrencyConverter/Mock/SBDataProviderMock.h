//
// Created by Sergei Borisov on 07/03/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBDataProviderProtocol.h"


@interface SBDataProviderMock : NSObject <SBDataProviderProtocol>

typedef NSUInteger(^SBDataProviderMockCountBlock)();

@property(nonatomic, copy) SBDataProviderMockCountBlock countBlock;


typedef id <SBRateDataProtocol> (^SBDataProviderMockRateByCodeBlock)(NSString *currencyCode);

@property(nonatomic, copy) SBDataProviderMockRateByCodeBlock rateByCodeBlock;


typedef id <SBRateDataProtocol> (^SBDataProviderMockRateByIndexBlock)(NSUInteger index);

@property(nonatomic, copy) SBDataProviderMockRateByIndexBlock rateByIndexBlock;

@end