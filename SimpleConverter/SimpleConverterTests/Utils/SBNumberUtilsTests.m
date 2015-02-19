//
//  SBNumberUtilsTests.m
//  SimpleConverter
//
//  Created by Sergei Borisov on 15/02/15.
//  Copyright (c) 2015 Sergei Borisov . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSNumber+Utils.h"

@interface SBNumberUtilsTests : XCTestCase

@end

@implementation SBNumberUtilsTests

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

- (void)testIsNumber
{
    XCTAssertFalse([NSNumber isNumber:nil]);
    XCTAssertFalse([NSNumber isNumber:(NSNumber *)[NSNull null]]);
    XCTAssertFalse([NSNumber isNumber:(NSNumber *)@""]);
    XCTAssertFalse([NSNumber isNumber:(NSNumber *)@"aa"]);
    XCTAssertTrue([NSNumber isNumber:@1]);
    XCTAssertTrue([NSNumber isNumber:@YES]);
}

@end
