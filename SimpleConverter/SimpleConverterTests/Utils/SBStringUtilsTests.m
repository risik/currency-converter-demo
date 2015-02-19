//
//  SBStringUtilsTests.m
//  SimpleConverter
//
//  Created by Sergei Borisov on 15/02/15.
//  Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+Utils.h"

@interface SBStringUtilsTests : XCTestCase

@end

@implementation SBStringUtilsTests

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

- (void)testStringEmpty
{
    XCTAssertTrue([NSString isEmpty:nil]);
    XCTAssertTrue([NSString isEmpty:NULL]);
    XCTAssertTrue([NSString isEmpty:[NSNull null]]);
    XCTAssertTrue([NSString isEmpty:@""]);
    XCTAssertTrue([NSString isEmpty:@1]);
    XCTAssertFalse([NSString isEmpty:@"aa"]);
}

@end
