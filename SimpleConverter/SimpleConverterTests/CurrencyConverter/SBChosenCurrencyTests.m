//
//  SBChosenCurrencyTests.m
//  SimpleConverter
//
//  Created by Sergei Borisov on 07/03/15.
//  Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SBRateDataMock.h"
#import "SBChosenCurrency.h"
#import "SBDataProviderMock.h"
#import "SBChosenCurrencyDelegateMock.h"
#import "AGAsyncTestHelper.h"

@interface SBChosenCurrencyTests : XCTestCase

@property SBDataProviderMock *dataProviderMock;

@property NSArray *ratesArray;

@property NSDictionary *ratesDictionary;

@property SBChosenCurrencyDelegateMock *chosenCurrencyDelegateMock;
@end

@implementation SBChosenCurrencyTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.dataProviderMock = [[SBDataProviderMock alloc] init];

    SBRateDataMock *rate0 = [SBRateDataMock mockWithCode:@"aaa" name:@"aaa name" rate:@2.0];
    SBRateDataMock *rate1 = [SBRateDataMock mockWithCode:@"bbb" name:@"bbb name" rate:@1.0];
    SBRateDataMock *rate2 = [SBRateDataMock mockWithCode:@"ccc" name:@"ccc name" rate:@3.0];

    self.ratesArray = @[
            rate0,
            rate1,
            rate2,
    ];
    self.ratesDictionary = @{
            rate0.code : rate0,
            rate1.code : rate1,
            rate2.code : rate2,
    };

    self.dataProviderMock.countBlock = ^NSUInteger
    {
        return self.ratesArray.count;
    };

    self.dataProviderMock.rateByIndexBlock = ^id <SBRateDataProtocol>(NSUInteger index)
    {
        if (index >= self.ratesArray.count) {
            XCTFail(@"invalid index used for data provider");
            return nil;
        }
        else {
            return self.ratesArray[index];
        }
    };

    self.dataProviderMock.rateByCodeBlock = ^id <SBRateDataProtocol>(NSString *currencyCode)
    {
        return self.ratesDictionary[currencyCode];
    };

    self.chosenCurrencyDelegateMock = [[SBChosenCurrencyDelegateMock alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRateDataMock
{
    SBRateDataMock *rate1 = [SBRateDataMock mockWithCode:@"aaa" name:@"bbb" rate:@1.0];

    XCTAssertNotNil(rate1);
    XCTAssertTrue([rate1.rate isEqualToNumber:@1.0]);
    XCTAssertTrue([rate1.code isEqualToString:@"aaa"]);
    XCTAssertTrue([rate1.name isEqualToString:@"bbb"]);
}

- (void)testCheckDataProvider
{
    XCTAssertThrows([SBChosenCurrency currencyWithCurrentCurrencyCode:nil dataProvider:nil]);
    XCTAssertThrows([SBChosenCurrency currencyWithCurrentCurrencyCode:@"aaa" dataProvider:nil]);
}

- (void)testCreateWithNoCurrentCurrency
{
    SBChosenCurrency *chosenCurrency = [SBChosenCurrency currencyWithCurrentCurrencyCode:nil
                                                                            dataProvider:self.dataProviderMock];
    XCTAssertTrue([chosenCurrency.currentRate.code isEqualToString:@"aaa"]);
}

- (void)testCreateWithCurrentCurrency
{
    SBChosenCurrency *chosenCurrency = [SBChosenCurrency currencyWithCurrentCurrencyCode:@"bbb"
                                                                            dataProvider:self.dataProviderMock];
    XCTAssertTrue([chosenCurrency.currentRate.code isEqualToString:@"bbb"]);
}

- (void)testChoosing
{
    SBChosenCurrency *chosenCurrency = [SBChosenCurrency currencyWithCurrentCurrencyCode:@"bbb"
                                                                            dataProvider:self.dataProviderMock];
    [chosenCurrency setDelegate:self.chosenCurrencyDelegateMock];

    // set to 0
    __block BOOL changedBlockCalled = NO;
    self.chosenCurrencyDelegateMock.changedBlock = ^(id <SBChosenCurrencyProtocol> chosen)
    {
        XCTAssertTrue([chosenCurrency.currentRate.code isEqualToString:@"aaa"], @"chosenCurrency: %@", chosenCurrency);
        changedBlockCalled = YES;
    };
    [chosenCurrency selectIndex:0];
    AGWW_WAIT_WHILE(!changedBlockCalled, 10.0);

    // set to 0 again
    self.chosenCurrencyDelegateMock.changedBlock = ^(id <SBChosenCurrencyProtocol> chosen)
    {
        XCTFail(@"don't fire delegate if currency actually not changed");
    };
    [chosenCurrency selectIndex:0];

    // set too large
    self.chosenCurrencyDelegateMock.changedBlock = ^(id <SBChosenCurrencyProtocol> chosen)
    {
        XCTFail(@"don't fire delegate if currency actully not changed");
    };
    XCTAssertThrows([chosenCurrency selectIndex:self.ratesArray.count]);

    // set to last
    __block BOOL changedBlockCalled2 = NO;
    self.chosenCurrencyDelegateMock.changedBlock = ^(id <SBChosenCurrencyProtocol> chosen)
    {
        XCTAssertTrue([chosenCurrency.currentRate.code isEqualToString:@"ccc"]);
        changedBlockCalled2 = YES;
    };
    [chosenCurrency selectIndex:self.ratesArray.count-1];
    AGWW_WAIT_WHILE(!changedBlockCalled2, 10.0);
}

@end
