//
//  SBCurrencyRateSaverTests.m
//  SimpleConverter
//
//  Created by Sergei Borisov on 18/02/15.
//  Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+Testing.h"
#import "SBCurrencyRateSaver.h"
#import "SBRate.h"

@interface SBCurrencyRateSaverTests : XCTestCase

@property NSManagedObjectContext *context;

@end

@implementation SBCurrencyRateSaverTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSError *error = nil;
    self.context = [NSManagedObjectContext testing_inMemoryContext:NSMainQueueConcurrencyType
                                                             error:&error];
    NSUndoManager *undoManager = [[NSUndoManager alloc] init];
    [self.context setUndoManager:undoManager];

    XCTAssertNil(error, @"error creating managed context");
    XCTAssertNotNil(self.context);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateWithNilContext
{
    XCTAssertThrows([SBCurrencyRateSaver saverWithContext:nil]);
}

- (void)testCreateNoUndo
{
    NSError *error = nil;
    NSManagedObjectContext *context = [NSManagedObjectContext testing_inMemoryContext:NSMainQueueConcurrencyType
                                                                                error:&error];
    XCTAssertNil(error, @"error creating managed context");
    XCTAssertNotNil(context);

    XCTAssertThrows([SBCurrencyRateSaver saverWithContext:nil]);
}

- (void)testEmpty
{
    NSArray *rates = [self getAllRates];

    XCTAssertTrue(rates.count == 0);
}

- (void)testAddNilCurrency
{
    id <SBCurrencyRateSaverProtocol> saver = [SBCurrencyRateSaver saverWithContext:self.context];
    NSError *error = nil;
    XCTAssertFalse([saver saveCurrencies:nil andRates:self.rates1 error:&error]);
    XCTAssertNotNil(error);

    XCTAssertTrue([self getAllRates].count == 0);
}

- (void)testAddNonDictionaryCurrency
{
    id <SBCurrencyRateSaverProtocol> saver = [SBCurrencyRateSaver saverWithContext:self.context];

    NSError *error = nil;
    XCTAssertFalse([saver saveCurrencies:(id) @"" andRates:self.rates1 error:&error]);
    XCTAssertNotNil(error);

    XCTAssertTrue([self getAllRates].count == 0);
}

- (void)testAddEmptyDictionaryCurrency
{
    id <SBCurrencyRateSaverProtocol> saver = [SBCurrencyRateSaver saverWithContext:self.context];

    NSError *error = nil;
    XCTAssertFalse([saver saveCurrencies:@{} andRates:self.rates1 error:&error]);
    XCTAssertNotNil(error);

    XCTAssertTrue([self getAllRates].count == 0);
}

- (void)testAddNilRate
{
    id <SBCurrencyRateSaverProtocol> saver = [SBCurrencyRateSaver saverWithContext:self.context];
    NSError *error = nil;
    XCTAssertFalse([saver saveCurrencies:self.currencies1 andRates:nil error:&error]);
    XCTAssertNotNil(error);

    XCTAssertTrue([self getAllRates].count == 0);
}

- (void)testAddNonDictionaryRate
{
    id <SBCurrencyRateSaverProtocol> saver = [SBCurrencyRateSaver saverWithContext:self.context];

    NSError *error = nil;
    XCTAssertFalse([saver saveCurrencies:self.currencies1 andRates:(id) @"" error:&error]);
    XCTAssertNotNil(error);

    XCTAssertTrue([self getAllRates].count == 0);
}

- (void)testAddEmptyDictionaryRate
{
    id <SBCurrencyRateSaverProtocol> saver = [SBCurrencyRateSaver saverWithContext:self.context];

    NSError *error = nil;
    XCTAssertFalse([saver saveCurrencies:self.currencies1 andRates:@{} error:&error]);
    XCTAssertNotNil(error);

    XCTAssertTrue([self getAllRates].count == 0);
}

- (void)testAddTwiceSame
{
    id <SBCurrencyRateSaverProtocol> saver = [SBCurrencyRateSaver saverWithContext:self.context];

    NSError *error = nil;
    XCTAssertTrue([saver saveCurrencies:self.currencies1 andRates:self.rates1 error:&error], @"error: %@", error);
    XCTAssertNil(error);

    XCTAssertTrue([self getAllRates].count == 3);
    XCTAssertTrue([[self getRateWithCode:@"AED"].name isEqualToString:@"United Arab Emirates Dirham"]);
    XCTAssertTrue([[self getRateWithCode:@"AFN"].name isEqualToString:@"Afghan Afghani"]);
    XCTAssertTrue([[self getRateWithCode:@"ALL"].name isEqualToString:@"Albanian Lek"]);
    XCTAssertTrue([[self getRateWithCode:@"AED"].rate isEqualToNumber:@3.67343]);
    XCTAssertTrue([[self getRateWithCode:@"AFN"].rate isEqualToNumber:@57.411375]);
    XCTAssertTrue([[self getRateWithCode:@"ALL"].rate isEqualToNumber:@123.545401]);

    XCTAssertTrue([saver saveCurrencies:self.currencies1 andRates:self.rates1 error:&error]);
    XCTAssertNil(error);

    XCTAssertTrue([self getAllRates].count == 3, @"records count: %d", [self getAllRates].count);
    XCTAssertTrue([[self getRateWithCode:@"AED"].name isEqualToString:@"United Arab Emirates Dirham"]);
    XCTAssertTrue([[self getRateWithCode:@"AFN"].name isEqualToString:@"Afghan Afghani"]);
    XCTAssertTrue([[self getRateWithCode:@"ALL"].name isEqualToString:@"Albanian Lek"]);
    XCTAssertTrue([[self getRateWithCode:@"AED"].rate isEqualToNumber:@3.67343]);
    XCTAssertTrue([[self getRateWithCode:@"AFN"].rate isEqualToNumber:@57.411375]);
    XCTAssertTrue([[self getRateWithCode:@"ALL"].rate isEqualToNumber:@123.545401]);
}

- (void)testAddTwiceDifferent
{
    id <SBCurrencyRateSaverProtocol> saver = [SBCurrencyRateSaver saverWithContext:self.context];

    NSError *error = nil;
    XCTAssertTrue([saver saveCurrencies:self.currencies1 andRates:self.rates1 error:&error], @"error: %@", error);
    XCTAssertNil(error);

    XCTAssertTrue([self getAllRates].count == 3);
    XCTAssertTrue([[self getRateWithCode:@"AED"].name isEqualToString:@"United Arab Emirates Dirham"]);
    XCTAssertTrue([[self getRateWithCode:@"AFN"].name isEqualToString:@"Afghan Afghani"]);
    XCTAssertTrue([[self getRateWithCode:@"ALL"].name isEqualToString:@"Albanian Lek"]);
    XCTAssertTrue([[self getRateWithCode:@"AED"].rate isEqualToNumber:@3.67343]);
    XCTAssertTrue([[self getRateWithCode:@"AFN"].rate isEqualToNumber:@57.411375]);
    XCTAssertTrue([[self getRateWithCode:@"ALL"].rate isEqualToNumber:@123.545401]);

    XCTAssertTrue([saver saveCurrencies:self.currencies2 andRates:self.rates2 error:&error]);
    XCTAssertNil(error);

    XCTAssertTrue([self getAllRates].count == 3, @"records count: %d", [self getAllRates].count);
    XCTAssertTrue([[self getRateWithCode:@"AED"].name isEqualToString:@"United Arab Emirates Dirham2"]);
    XCTAssertTrue([[self getRateWithCode:@"ALL"].name isEqualToString:@"Albanian Lek"]);
    XCTAssertTrue([[self getRateWithCode:@"AMD"].name isEqualToString:@"Armenian Dram"]);
    XCTAssertTrue([[self getRateWithCode:@"AED"].rate isEqualToNumber:@3.67343]);
    XCTAssertTrue([[self getRateWithCode:@"ALL"].rate isEqualToNumber:@123.545401]);
    XCTAssertTrue([[self getRateWithCode:@"AMD"].rate isEqualToNumber:@479.14]);
}

- (void)testAddDifferentDictionary1
{
    id <SBCurrencyRateSaverProtocol> saver = [SBCurrencyRateSaver saverWithContext:self.context];

    NSError *error = nil;
    XCTAssertFalse([saver saveCurrencies:self.currencies1 andRates:self.rates3 error:&error]);
    XCTAssertNotNil(error);

    error = nil;
    XCTAssertFalse([saver saveCurrencies:self.currencies3 andRates:self.rates1 error:&error]);
    XCTAssertNotNil(error);
}


#pragma mark internal

- (SBRate *)getRateWithCode:(NSString *)code
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    request.entity = [NSEntityDescription entityForName:@"SBRate" inManagedObjectContext:self.context];
    request.predicate = [NSPredicate predicateWithFormat:@"code = %@", code];

    NSError *error = nil;
    SBRate *sbRate = [[self.context executeFetchRequest:request error:&error] lastObject];

    if (error) {
        NSLog(@"error during get currency rate from DB: %@", error.localizedDescription);
        return nil;
    }

    return sbRate;
}

- (NSArray *)getAllRates
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    request.entity = [NSEntityDescription entityForName:@"SBRate" inManagedObjectContext:self.context];

    NSError *error = nil;
    NSArray *result = [self.context executeFetchRequest:request error:&error];

    if (error) {
        NSLog(@"error during get currency rate from DB: %@", error.localizedDescription);
        return nil;
    }

    return result;
}

- (NSDictionary *)currencies1
{
    return @{
            @"AED" : @"United Arab Emirates Dirham",
            @"AFN" : @"Afghan Afghani",
            @"ALL" : @"Albanian Lek",
    };
}

- (NSDictionary *)currencies2
{
    return @{
            @"AED" : @"United Arab Emirates Dirham2",
            @"ALL" : @"Albanian Lek",
            @"AMD" : @"Armenian Dram",
    };
}

- (NSDictionary *)currencies3
{
    return @{
            @"AED" : @"United Arab Emirates Dirham2",
            @"AFN" : @"Afghan Afghani",
            @"ALL" : @"Albanian Lek",
            @"AMD" : @"Armenian Dram",
    };
}

- (NSDictionary *)rates1
{
    return @{
            @"AED" : @3.67343,
            @"AFN" : @57.411375,
            @"ALL" : @123.545401,
    };
}

- (NSDictionary *)rates2
{
    return @{
            @"AED" : @3.67343,
            @"ALL" : @123.545401,
            @"AMD" : @479.14,
    };
}

- (NSDictionary *)rates3
{
    return @{
            @"AED" : @3.67343,
            @"AFN" : @57.411375,
            @"ALL" : @123.545401,
            @"AMD" : @479.14,
    };
}

@end
