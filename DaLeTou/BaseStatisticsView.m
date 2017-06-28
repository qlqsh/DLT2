//
//  BaseStatisticsView.m
//  DaLeTou
//
//  Created by 刘明 on 2017/6/14.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "BaseStatisticsView.h"

#import "ItemDescription.h"

#import "BallView.h"

/// 基础统计单元视图（球视图、出现次数、比率）
@implementation BaseStatisticsView

- (instancetype)initWithBall:(NSString *)ball
                     andShow:(NSUInteger)show
                    andTotal:(NSUInteger)total {
    if (self = [super init]) {
        // 球组合
        BallView *ballView = [[BallView alloc] initWithPosition:CGPointMake(0, 0)];
        ballView.state = 2;
        ballView.textLabel.text = ball;
        [self addSubview:ballView];
        
        // 数字标签
        UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 40.0f, 15)];
        showLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)show];
        showLabel.textColor = [UIColor darkGrayColor];
        showLabel.textAlignment = NSTextAlignmentCenter;
        showLabel.font = [UIFont systemFontOfSize:9.0f];
        [self addSubview:showLabel];
        
        // 百分比
        UILabel *percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 40, 15)];
        CGFloat percentage = (CGFloat)show/(CGFloat)total;
        percentageLabel.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:percentage] numberStyle:NSNumberFormatterPercentStyle];
        percentageLabel.textColor = [UIColor darkGrayColor];
        percentageLabel.textAlignment = NSTextAlignmentCenter;
        percentageLabel.font = [UIFont systemFontOfSize:9.0f];
        [self addSubview:percentageLabel];
        
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = kRGBColor(230, 230, 230).CGColor;
        self.layer.cornerRadius = 5.0;
    }
    return self;
}

@end
