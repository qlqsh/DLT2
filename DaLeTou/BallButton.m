//
//  BallButton.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/5.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "BallButton.h"

@implementation BallButton

#pragma mark - 初始化
- (instancetype)initWithPosition:(CGPoint)position {
    CGFloat defaultWidth = kDefaultBallWidth + kDefaultSpace*2;
    CGRect frame = CGRectMake(position.x, position.y, defaultWidth, defaultWidth);
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self
                 action:@selector(selected)
       forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

/// 选择状态
- (void)selected {
    self.selected = !self.selected;
}

#pragma mark - 属性设置
/**
 *  是否是红色按钮。
 *
 *  @param isRed YES：红色按钮。NO：蓝色按钮。
 */
- (void)setIsRed:(BOOL)isRed {
    if (isRed) { // 红色按钮
        // 普通
        [self setTitleColor:kRedColor forState:UIControlStateNormal];
        [self setBackgroundImage:kWhiteImage forState:UIControlStateNormal];
        // 选择
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setBackgroundImage:kRedImage forState:UIControlStateSelected];
        // 高亮
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:kRedImage forState:UIControlStateHighlighted];
    } else { // 蓝球按钮
        // 普通
        [self setTitleColor:kBlueColor forState:UIControlStateNormal];
        [self setBackgroundImage:kWhiteImage forState:UIControlStateNormal];
        // 选择
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setBackgroundImage:kBlueImage forState:UIControlStateSelected];
        // 高亮
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:kBlueImage forState:UIControlStateHighlighted];
    }
    self.adjustsImageWhenHighlighted = false; // 高亮模式下按钮不会变灰
}

/**
 *  设置按钮文字内容。
 *
 *  @param text 内容。
 */
- (void)setText:(NSString *)text {
    [self setTitle:text forState:UIControlStateNormal];
    [self setTitle:text forState:UIControlStateSelected];
    [self setTitle:text forState:UIControlStateHighlighted];
}

@end
