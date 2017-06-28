//
//  BallView.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/5.
//  Copyright © 2017年 刘明. All rights reserved.
//

#define kBallIsBlank1 0 // 红字白球背景
#define kBallIsBlank2 1 // 蓝字白球背景
#define kBallIsRed 2    // 白字红球背景
#define kBallIsBlue 3   // 白字蓝球背景

#import <UIKit/UIKit.h>

@interface BallView : UIView

- (instancetype)initWithPosition:(CGPoint)position;

/// 文字标签。球的数字内容（红：01-33、蓝：01-16）。也可以只显示普通数字内容。
@property (nonatomic, strong) UILabel *textLabel;
/// 背景视图
@property (nonatomic, strong) UIImageView *backgroundView;
/// 状态设置。0:白底红字、1:白底蓝字、2:红底白字、3:蓝底白字
@property (nonatomic) NSUInteger state;

@end
