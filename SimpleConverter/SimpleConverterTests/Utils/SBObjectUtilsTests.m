//
//  SBObjectUtilsTests.m
//  SimpleRecipes
//
//  Created by Sergei Borisov on 15/02/15.
//  Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSObject+Utils.h"

@interface SBObjectUtilsTests : XCTestCase

@end

@implementation SBObjectUtilsTests

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

- (void)testObjectIsNil
{
    XCTAssertTrue([NSObject isNil:nil]);
    XCTAssertTrue([NSObject isNil:[NSNull null]]);
    XCTAssertFalse([NSObject isNil:@"aa"]);
    XCTAssertFalse([NSObject isNil:@1]);
}

@end
