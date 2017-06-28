//
//  CustomNavigationController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/6/14.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

/// 定制导航。只支持竖屏。其实如果不自定义导航的话，默认是支持横屏、竖屏的。
@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 屏幕方向
// 是否支持转屏。
- (BOOL)shouldAutorotate {
    return NO;
}

// 支持哪些转屏方向。
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// 默认的屏幕方向。
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
