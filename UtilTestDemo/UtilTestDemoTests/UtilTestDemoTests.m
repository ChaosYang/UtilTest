//
//  UtilTestDemoTests.m
//  UtilTestDemoTests
//
//  Created by yangweichao on 2021/4/21.
//

#import <XCTest/XCTest.h>
#import "NSString+VTRegexp.h"
#import "UIView+Additional.h"

@interface UtilTestDemoTests : XCTestCase

@end

@implementation UtilTestDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString *str = @"17090331327";
    BOOL des = [str isValidPhoneNumber];
    XCTAssert(des, @"%@ is invalid phone number.", str);
    
}

- (void)testValidEmail {
    NSString *str = @"17090331327@163.com";
    BOOL des = [str isValidEmail];
    XCTAssert(des, @"%@ is invalid email address", str);
}

- (void)testValidDate{
    NSString *str = @"20200229122223";
    BOOL des = [str isValidDateTime:VTDateFormatDefault];
    XCTAssert(des, @"%@ is invalid date", str);
}

- (void)testViewAdditional{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [v setTop:20];
    XCTAssert(v.frame.origin.y==20, @"top set failed");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
    }];
}

@end
