//
//  WinningBaseView.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/5.
//  Copyright © 2017年 刘明. All rights reserved.
//

#define kIsSSQ 0    // 双色球
#define kIsDLT 1    // 大乐透
#define kWinningBaseViewDefaultWidth    280.0f  // 默认宽度
#define kWinningBaseViewDefaultHeight   40.0f   // 默认高度

#import <UIKit/UIKit.h>

/// 获奖基本视图（N个红球+N个蓝球）。
@interface WinningBaseView : UIView
#pragma mark - 初始化
- (instancetype)initWithPosition:(CGPoint)position;

#pragma mark - 属性
@property (nonatomic, strong) NSArray *texts;   // 数据
@property (nonatomic, strong) NSArray *states;  // 状态（红、蓝）
@property (nonatomic) CGFloat scale;            // 缩放

#pragma mark - 开放方法
- (void)setSpecies:(NSUInteger)state;   // 种类（双色球、大乐透）

@end
