//
//  ViewController.m
//  UtilTestDemo
//
//  Created by yangweichao on 2021/4/21.
//

#import "ViewController.h"
#import "UIAlertController+VTAlert.h"
#import "NSString+VTRegexp.h"
#import "RuntimeUtils.h"
#import "UIView+Additional.h"
#import "UIDevice+Additional.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [RuntimeUtils getAllIVars:[UIAlertAction class]];
//    [RuntimeUtils getAllIVars:[UIAlertController class]];
//    [RuntimeUtils getAllIVars:[CBPeripheral class]];
    NSLog(@"%d", [UIDevice currentDevice].isIphoneX);
    NSLog(@"%d", [UIDevice currentDevice].isIphoneX);
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    UIAlertController *alert = [UIAlertController vt_alertWithTitle:@"testTitle" message:@"testMessage" messageAlignment:NSTextAlignmentCenter];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"testTitle" message:@"testMessage" preferredStyle:UIAlertControllerStyleActionSheet];;
    [alert resetTitleColor:[UIColor redColor]];
//    UIAlertAction *aa0 = [UIAlertAction vt_actionWithTitle:@"我是测试文字" titleColor:[UIColor darkGrayColor] titleAlignment:NSTextAlignmentLeft style:UIAlertActionStyleDefault handler:nil];
//    UIAlertAction *aa1 = [UIAlertAction vt_actionWithTitle:@"我是测试文字" titleColor:nil titleAlignment:NSTextAlignmentCenter style:UIAlertActionStyleDestructive handler:nil];
//    UIAlertAction *aa2 = [UIAlertAction vt_actionWithTitle:@"我是测试文字" titleColor:[UIColor greenColor] titleAlignment:NSTextAlignmentRight style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:aa0];
//    [alert addAction:aa1];
//    [alert addAction:aa2];
//    [self presentViewController:alert animated:YES completion:nil];
}


@end
