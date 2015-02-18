//
//  SBArrayUtilsTests.m
//  SimpleRecipes
//
//  Created by Sergei Borisov on 15/02/15.
//  Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSArray+Utils.h"

@interface SBArrayUtilsTests : XCTestCase

@end

@implementation SBArrayUtilsTests

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

- (void)testArrayIsEmpty
{
    XCTAssertTrue([NSArray isEmpty:nil]);
    XCTAssertTrue([NSArray isEmpty:(NSArray *)[NSNull null]]);
    XCTAssertTrue([NSArray isEmpty:@[]]);
    XCTAssertFalse([NSArray isEmpty:@[@1]]);
    XCTAssertFalse([NSArray isEmpty:@[@""]]);
}

@end
