//
//  SBDictionaryUtilsTests.m
//  SimpleRecipes
//
//  Created by Sergei Borisov on 15/02/15.
//  Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSDictionary+Utils.h"

@interface SBDictionaryUtilsTests : XCTestCase

@end

@implementation SBDictionaryUtilsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsDictionary
{
    XCTAssertFalse([NSDictionary isDictionary:nil]);
    XCTAssertFalse([NSDictionary isDictionary:[NSNull null]]);
    XCTAssertFalse([NSDictionary isDictionary:@""]);
    XCTAssertFalse([NSDictionary isDictionary:@"aa"]);
    XCTAssertFalse([NSDictionary isDictionary:@1]);
    XCTAssertFalse([NSDictionary isDictionary:@YES]);

    XCTAssertTrue([NSDictionary isDictionary:@{}]);
    XCTAssertTrue([NSDictionary isDictionary:@{@"a":@"b"}]);

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"b"] = @"a";
    XCTAssertTrue([NSDictionary isDictionary:dict]);
}

- (void)testIsEmpty
{
    XCTAssertTrue([NSDictionary isEmpty:nil]);
    XCTAssertTrue([NSDictionary isEmpty:[NSNull null]]);
    XCTAssertTrue([NSDictionary isEmpty:@""]);
    XCTAssertTrue([NSDictionary isEmpty:@"aa"]);
    XCTAssertTrue([NSDictionary isEmpty:@1]);
    XCTAssertTrue([NSDictionary isEmpty:@YES]);

    XCTAssertTrue([NSDictionary isEmpty:@{}]);
    XCTAssertFalse([NSDictionary isEmpty:@{@"a":@"b"}]);

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"b"] = @"a";
    XCTAssertFalse([NSDictionary isEmpty:dict]);
}

@end
