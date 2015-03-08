//
//  SBDataProviderTests.m
//  SimpleConverter
//
//  Created by Sergei Borisov on 08/03/15.
//  Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

#import "NSManagedObjectContext+Testing.h"
#import "SBDataProvider.h"
#import "SBRate.h"
#import "SBRateDataProtocol.h"

@interface SBDataProviderTests : XCTestCase

@property NSManagedObjectContext *context;

@end

@implementation SBDataProviderTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    NSError *error = nil;
    self.context = [NSManagedObjectContext testing_inMemoryContext:NSMainQueueConcurrencyType
                                                             error:&error];

    XCTAssertNil(error, @"error creating managed context");
    XCTAssertNotNil(self.context);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateWithEmptyContext
{
    XCTAssertThrows([SBDataProvider providerWithManagedContext:nil]);
}

- (void)testFillEmptyDB
{
    SBDataProvider *provider = [SBDataProvider providerWithManagedContext:self.context];

    XCTAssertEqual(provider.count, 0);

    XCTAssertThrows([provider rateByIndex:0]);
    XCTAssertThrows([provider rateByIndex:1]);

    XCTAssertThrows([provider rateByCode:@"aaa"]);
    XCTAssertThrows([provider rateByCode:@"zzz"]);
    XCTAssertThrows([provider rateByCode:nil]);
    XCTAssertThrows([provider rateByCode:@""]);

    [self createDefaultDB];
    [self checkDefaultDbWithProvider:provider];
}

- (void)testFilledDb
{
    [self createDefaultDB];
    SBDataProvider *provider = [SBDataProvider providerWithManagedContext:self.context];

    [self checkDefaultDbWithProvider:provider];
}

#pragma mark internal

- (void)checkDefaultDbWithProvider:(SBDataProvider *)provider
{
    XCTAssertEqual(provider.count, 3);

    XCTAssertTrue([self checkRate:[provider rateByIndex:0] hasCode:@"aaa" name:@"aaa name" rate:2.0]);
    XCTAssertTrue([self checkRate:[provider rateByIndex:1] hasCode:@"bbb" name:@"bbb name" rate:1.0]);
    XCTAssertTrue([self checkRate:[provider rateByIndex:2] hasCode:@"ccc" name:@"ccc name" rate:3.0]);
    XCTAssertThrows([provider rateByIndex:3]);
    XCTAssertThrows([provider rateByIndex:-1]);

    XCTAssertTrue([self checkRate:[provider rateByCode:@"aaa"] hasCode:@"aaa" name:@"aaa name" rate:2.0]);
    XCTAssertTrue([self checkRate:[provider rateByCode:@"bbb"] hasCode:@"bbb" name:@"bbb name" rate:1.0]);
    XCTAssertTrue([self checkRate:[provider rateByCode:@"ccc"] hasCode:@"ccc" name:@"ccc name" rate:3.0]);
    XCTAssertThrows([provider rateByCode:@"zzz"]);
    XCTAssertThrows([provider rateByCode:nil]);
    XCTAssertThrows([provider rateByCode:@""]);
}

- (BOOL)checkRate:(id <SBRateDataProtocol>)rate
          hasCode:(NSString *)expectedCode
             name:(NSString *)expectedName
             rate:(double)expectedRate
{
    if (![rate.code isEqualToString:expectedCode]) {
        NSLog(@"actual code '%@' not match expected '%@'", rate.code, expectedCode);
        return NO;
    }
    if (rate.rate.doubleValue != expectedRate) {
        NSLog(@"actual rate '%f' not match expected '%f'", rate.rate.doubleValue, expectedRate);
        return NO;
    }
    if (![rate.name isEqualToString:expectedName]) {
        NSLog(@"actual name '%@' not match expected '%@'", rate.name, expectedName);
        return NO;
    }
    return YES;
}

- (void)createDefaultDB
{
    [self addRecordWithCode:@"bbb" name:@"bbb name" rate:1.0];
    [self addRecordWithCode:@"aaa" name:@"aaa name" rate:2.0];
    [self addRecordWithCode:@"ccc" name:@"ccc name" rate:3.0];

    NSError *error = nil;
    if (![self.context save:&error]) {
        XCTFail(@"couldn't save data to DB");
    }
}

- (void)addRecordWithCode:(NSString *)code name:(NSString *)name rate:(double)rate
{
    SBRate *sbRate;
    sbRate = [NSEntityDescription insertNewObjectForEntityForName:@"SBRate" inManagedObjectContext:self.context];
    sbRate.code = code;
    sbRate.name = name;
    sbRate.rate = @(rate);
}

@end
