//
//  SBDataSaverTests.m
//  SimpleConverter
//
//  Created by Sergei Borisov on 19/02/15.
//  Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SBCurrencyRateSaverMock.h"
#import "SBDataSaverProtocol.h"
#import "SBDataSaver.h"

@interface SBDataSaverTests : XCTestCase

@property SBCurrencyRateSaverMock *currencyRateSaverMock;

@end

@implementation SBDataSaverTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.currencyRateSaverMock = [[SBCurrencyRateSaverMock alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNilCurrencyRateSaver
{
    XCTAssertThrows([SBDataSaver saverWithCurrencyRateSaver:nil]);
}

- (void)testNormal
{
    __block BOOL blockCalled = NO;
    self.currencyRateSaverMock.saveCurrenciesBlock = ^BOOL(NSDictionary *currenciesDictionary, NSDictionary *ratesDictionary, NSError **pError)
    {
        XCTAssertTrue([currenciesDictionary[@"AED"] isEqualToString:@"United Arab Emirates Dirham"]);
        XCTAssertTrue([currenciesDictionary[@"AFN"] isEqualToString:@"Afghan Afghani"]);
        XCTAssertTrue([currenciesDictionary[@"ALL"] isEqualToString:@"Albanian Lek"]);
        XCTAssertTrue([ratesDictionary[@"AED"] isEqualToNumber:@3.67343]);
        XCTAssertTrue([ratesDictionary[@"AFN"] isEqualToNumber:@57.411375]);
        XCTAssertTrue([ratesDictionary[@"ALL"] isEqualToNumber:@123.545401]);

        blockCalled = YES;

        return YES;
    };
    id <SBDataSaverProtocol> saver = [SBDataSaver saverWithCurrencyRateSaver:self.currencyRateSaverMock];

    NSError *error = nil;
    XCTAssertTrue([saver saveCurrencies:self.currencies1 andRates:self.rates1 error:&error]);
    XCTAssertNil(error, @"error: %@", error);

    XCTAssertTrue(blockCalled);
}

- (void)testNilCurrencyData
{
    id <SBDataSaverProtocol> saver = [SBDataSaver saverWithCurrencyRateSaver:self.currencyRateSaverMock];

    NSError *error = nil;
    XCTAssertFalse([saver saveCurrencies:nil andRates:self.rates1 error:&error]);
    XCTAssertNotNil(error, @"error: %@", error);
}

- (void)testNilRatesData
{
    id <SBDataSaverProtocol> saver = [SBDataSaver saverWithCurrencyRateSaver:self.currencyRateSaverMock];

    NSError *error = nil;
    XCTAssertFalse([saver saveCurrencies:self.currencies1 andRates:nil error:&error]);
    XCTAssertNotNil(error, @"error: %@", error);
}

- (void)testInvalidRates
{
    id <SBDataSaverProtocol> saver = [SBDataSaver saverWithCurrencyRateSaver:self.currencyRateSaverMock];

    NSError *error = nil;
    XCTAssertFalse([saver saveCurrencies:self.currencies1 andRates:self.rates2 error:&error]);
    XCTAssertNotNil(error, @"error: %@", error);
}

- (void)testHasDataNo
{
    self.currencyRateSaverMock.hasDataBlock = ^BOOL
    {
        return NO;
    };

    id <SBDataSaverProtocol> saver = [SBDataSaver saverWithCurrencyRateSaver:self.currencyRateSaverMock];
    XCTAssertFalse(saver.hasData);
}

- (void)testHasDataYes
{
    self.currencyRateSaverMock.hasDataBlock = ^BOOL
    {
        return YES;
    };

    id <SBDataSaverProtocol> saver = [SBDataSaver saverWithCurrencyRateSaver:self.currencyRateSaverMock];
    XCTAssertTrue(saver.hasData);
}

#pragma mark internal

- (NSData *)currencies1
{
    NSDictionary *dictionary = @{
            @"AED" : @"United Arab Emirates Dirham",
            @"AFN" : @"Afghan Afghani",
            @"ALL" : @"Albanian Lek",
    };
    return [NSJSONSerialization dataWithJSONObject:dictionary
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];
}

- (NSData *)rates1
{
    NSDictionary *dictionary = @{
            @"disclaimer" : @"rjjkrh",
            @"license" : @"sjkfhjrh",
            @"timestamp" : @1424264462,
            @"base" : @"USD",
            @"rates" : @{
                    @"AED" : @3.67343,
                    @"AFN" : @57.411375,
                    @"ALL" : @123.545401,
            }
    };
    return [NSJSONSerialization dataWithJSONObject:dictionary
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];
}

- (NSData *)rates2
{
    NSDictionary *dictionary = @{
            @"disclaimer" : @"rjjkrh",
            @"license" : @"sjkfhjrh",
            @"timestamp" : @1424264462,
            @"base" : @"USD",
    };
    return [NSJSONSerialization dataWithJSONObject:dictionary
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];
}

@end
