//
//  haitaoTests.m
//  haitaoTests
//
//  Created by pwy on 15-7-13.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface haitaoTests : XCTestCase

@end

@implementation haitaoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
    NSString *partner=@"seller_id=\"caiwu@quekua.com\"&out_trade_no=\"36\"&subject=\"&body=\"&total_fee=\"0.01\"&notify_url=\"http://www.peikua.com/plugins/pk_alipay/pk_return_url.php\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"p1hJdDmHqRMiFRvFbEQi/Q2MQLiK3VI1NkEY3MWRyF1VY/Gp2vc2BJbmiFOLRVFu5imtxdNP9wThvhKaklrBTEyAttbo2cTS4pxLTBhdiNu5Wb4pKMwHuqK5aWjCgE/kINmD2+Hvus8iz6jPiMlrEmh9DapOIpl8DKnvmjFdKnU=\"";
    if ([partner rangeOfString:@"success=\"true\""].location != NSNotFound) {
        NSLog(@"这个字符串中有\n");
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
