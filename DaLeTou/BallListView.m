//
//  BallListView.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/6.
//  Copyright © 2017年 刘明. All rights reserved.
//

#define kDefaultDLTReds 35  // 大乐透默认红球数量
#define kDefaultDLTBlues 12 // 大乐透默认蓝球数量

#import "BallListView.h"
#import "BallButton.h"

@implementation BallListView

#pragma mark - 初始化
/**
 * 球列表视图初始化。
 *
 * @param isDLT 是大乐透？
 * @param isRed 是红球？
 * @param hasNull 有空？
 * @param columns 显示的列数。
 *
 * @return 绘制好的球列表视图。
 */
- (instancetype)initIsDLT:(BOOL)isDLT
                 andIsRed:(BOOL)isRed
               andHasNull:(BOOL)hasNull
               andColumns:(NSUInteger)columns {
    NSUInteger ballNumber = 0; // 需要绘制的球数量
    if (isDLT) {
        ballNumber = isRed ? (hasNull ? 36 : 35) : (hasNull ? 13 : 12);
    } else {
        ballNumber = isRed ? (hasNull ? 34 : 33) : (hasNull ? 17 : 16);
    }
    
    // 计算视图框架。
    CGFloat ballWidth = kDefaultBallWidth + kDefaultSpace*2;
    NSUInteger rows = ballNumber/columns; // 计算行数
    if (ballNumber%columns != 0) {
        rows += 1;
    }
    CGFloat width = columns*ballWidth + 4.0f;
    CGFloat height = rows*ballWidth + 4.0f;
    CGRect frame = CGRectMake(0.0f, 0.0f, width, height);
    if (self = [super initWithFrame:frame]) {
        NSMutableArray *allBallArray = [[NSMutableArray alloc] initWithCapacity:ballNumber];
        // 绘制球按钮
        CGFloat positionX = 0.0f;
        CGFloat positionY = 0.0f;
        for (int i = 0, j = -1; i < ballNumber; i++) {
            if (i%columns == 0) {
                j++;
            }
            positionX = 2.0f + i%columns * ballWidth;
            positionY = 2.0f + j * ballWidth;
            BallButton *ballButton = [[BallButton alloc] initWithPosition:CGPointMake(positionX, positionY)];
            
            NSString *text = (i < 9) ? [NSString stringWithFormat:@"0%d", (i+1)] : [NSString stringWithFormat:@"%d", (i+1)];
            ballButton.text = text;
            ballButton.isRed = isRed;
            if (i == (ballNumber - 1)) {
                if (hasNull) {
                    ballButton.text = @"空";
                }
            }
            [allBallArray addObject:ballButton];
            [self addSubview:ballButton];
        }
        _balls = [allBallArray copy];
    }
    return self;
}

@end
