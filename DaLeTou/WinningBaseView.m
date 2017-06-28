//
//  WinningBaseView.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/5.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "WinningBaseView.h"
#import "BallView.h"

@interface WinningBaseView ()
@property (nonatomic, strong) NSMutableArray *balls;
@end

@implementation WinningBaseView
#pragma mark - 初始化
/// 指定位置绘制基础获奖号码视图。
- (instancetype)initWithPosition:(CGPoint)position {
    _balls = [[NSMutableArray alloc] initWithCapacity:7];
    CGFloat defaultWidth = kDefaultBallWidth + kDefaultSpace*2;
    CGRect frame = CGRectMake(position.x, position.y, defaultWidth*7, defaultWidth);
    if (self = [super initWithFrame:frame]) {
        for (int i = 1; i <= 7; i++) {
            BallView *ballView =
                [[BallView alloc] initWithPosition:CGPointMake((i-1)*defaultWidth, 0)];
            [_balls addObject:ballView];
            [self addSubview:ballView];
        }
    }
    return self;
}

#pragma mark - 属性
/// 设置球数字内容。双色球（01-33 + 01-16）、大乐透（01-35 + 01-12）。
- (void)setTexts:(NSArray *)texts {
    if (texts.count == 7) {
        for (int i = 0; i < 7; i++) {
            BallView *ballView = _balls[i];
            ballView.textLabel.text = texts[i];
        }
    }
}

/// 设置球状态。双色球（6红+1蓝）、大乐透（5红+2蓝）
- (void)setStates:(NSArray *)states {
    if (states.count == 7) {
        for (int i = 0; i < 7; i++) {
            BallView *ballView = _balls[i];
            ballView.state = [states[i] integerValue];
        }
    }
}

/// 缩放当前视图（基础获奖号码视图）。
- (void)setScale:(CGFloat)scale {
    CGPoint position = self.frame.origin;
    CGFloat width = self.frame.size.width;
    self.transform = CGAffineTransformMakeScale(scale, scale);
    self.frame = CGRectMake(position.x, position.y, width, width);
}

#pragma mark - 公开方法
/// 简便方法。设置为大乐透或双色球样式。
- (void)setSpecies:(NSUInteger)state {
    switch (state) {
        case kIsSSQ: // 双色球
            self.states = @[@2, @2, @2, @2, @2, @2, @3];
            break;
        case kIsDLT: // 大乐透
            self.states = @[@2, @2, @2, @2, @2, @3, @3];
            break;
        default:
            break;
    }
}

@end
