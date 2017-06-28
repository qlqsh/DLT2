//
//  ConditionCell.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/22.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "ConditionCell.h"
#import "BallView.h"

@implementation ConditionCell
#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

/// 圆球（符号）视图，仿“提醒”头符号。
- (UIView *)symbolViewWithState:(NSUInteger)state {
    UIColor *color = [UIColor grayColor];
    switch (state) {
        case 0:
            color = kRedColor;
            break;
        case 1:
            color = kBlueColor;
            break;
        case 2:
            color = kGreenColor;
            break;
        case 3:
            color = kOrangeColor;
            break;
        case 4:
            color = kYellowColor;
            break;
        default:
            break;
    }
    
    UIView *symbolView = [[UIView alloc] initWithFrame:CGRectMake(5, 15, 20, 20)];
    
    // 一个圆圈视图（外）
    UIView *outerCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    outerCircle.layer.borderWidth = 0.5f;
    outerCircle.layer.borderColor = [UIColor grayColor].CGColor;
    outerCircle.layer.cornerRadius = outerCircle.frame.size.height/2;
    [symbolView addSubview:outerCircle];
    
    // 一个实心圆视图（内）
    UIView *insideCircle = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 16, 16)];
    insideCircle.backgroundColor = color;
    insideCircle.layer.cornerRadius = insideCircle.frame.size.height/2;
    [symbolView addSubview:insideCircle];
    
    return symbolView;
}

/// 设置条件号码球
- (void)setConditionBalls:(NSArray *)conditionBalls andState:(NSUInteger)state {
    [self.contentView addSubview:[self symbolViewWithState:state]];
    UIView *ballsView = [[UIView alloc] init];
    if (conditionBalls.count == 0) { // 空行
        ballsView.frame = CGRectMake(30, 5, 40*2, 40);
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        textLabel.text = @"空行";
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor grayColor];
        textLabel.font = [UIFont systemFontOfSize:20.0f];
        [ballsView addSubview:textLabel];
    } else { // 非空行
        ballsView.frame = CGRectMake(30, 5, 40*conditionBalls.count, 40);
        NSUInteger i = 0;
        for (NSString *ball in conditionBalls) {
            BallView *ballView = [[BallView alloc] initWithPosition:CGPointMake(40*i, 0)];
            ballView.state = 2;
            ballView.textLabel.text = ball;
            [ballsView addSubview:ballView];
            i++;
        }
    }
    ballsView.layer.borderWidth = 0.5f;
    ballsView.layer.borderColor = [UIColor grayColor].CGColor;
    ballsView.layer.cornerRadius = 5;
    [self.contentView addSubview:ballsView];
}

/// 单元高度
+ (CGFloat)heightOfCell {
    return kDefaultBallWidth + kDefaultSpace*2 + 10.0f;
}

@end
