//
//  WinningTest.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/11.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Winning.h"

@interface WinningTest : XCTestCase
@property (nonatomic, strong) Winning *winning;
@end

@implementation WinningTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSString *testHtml = @"<tr class=\"t_tr1\"><td class=\"t_tr1\">17024</td><td class=\"cfont2\">21</td><td class=\"cfont2\">23</td><td class=\"cfont2\">29</td><td class=\"cfont2\">32</td><td class=\"cfont2\">35</td><td class=\"cfont4\">11</td><td class=\"cfont4\">12</td><td class=\"t_tr1\">3,471,058,022</td><td class=\"t_tr1\">3</td><td class=\"t_tr1\">10,000,000</td><td class=\"t_tr1\">73</td><td class=\"t_tr1\">131,828</td><td class=\"t_tr1\">206,593,265</td><td class=\"t_tr1\">2017-03-04</td></tr>";
    _winning = [[Winning alloc] initWithHtmlContent:testHtml];
}

- (void)tearDown {
    _winning = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/// 初始化获奖信息（解析html）。
- (void)testInit {
    XCTAssertNotNil(_winning, @"winning是nil，没有解析出来");
    XCTAssert([_winning.term isEqualToString:@"17024"],
              @"期号错误。\n预期：17024\n结果：%@", _winning.term);
//    XCTAssert([_winning.reds isEqualToArray:@[@"21", @"23", @"29", @"32", @"35"]],
//              @"红球错误。\n预期：[21 23 29 32 35]\n结果：%@", _winning.reds);
//    XCTAssert([_winning.blues isEqualToArray:[@"11", @"12"]],
//              @"红球错误。\n预期：[11 12]\n结果：%@", _winning.blues);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
