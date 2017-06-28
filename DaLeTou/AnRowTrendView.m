//
//  AnRowTrendView.m
//  DaLeTou
//
//  Created by 刘明 on 2017/6/8.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "AnRowTrendView.h"
#import "TrendData.h"
#import "Ball.h"
#import "BallView.h"

@implementation AnRowTrendView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTrendDataWithBalls:(NSArray *)balls andHasMissing:(BOOL)hasMissing {
    NSUInteger i = 0;
    NSUInteger redCount = 0;
    for (Ball *ball in balls) {
        if (ball.isBall) {
            BallView *ballView = [[BallView alloc] initWithPosition:CGPointMake(0, 0)];
            ballView.textLabel.text = ball.value;
            ballView.state = redCount >= 5 ? 3 : 2;
            redCount += 1;
            ballView.layer.borderWidth = 0.5f;
            ballView.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
            CGFloat scale = 25.0f/40.0f;
            ballView.transform = CGAffineTransformMakeScale(scale, scale);
            ballView.frame = CGRectMake(i * 25.0f, 0, 25.0f, 25.0f);
            [self addSubview:ballView];
        } else {
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * 25.0f, 0, 25.0f, 25.0f)];
            numberLabel.font = [UIFont systemFontOfSize:11.0f];
            numberLabel.layer.borderWidth = 0.5f;
            numberLabel.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
            if (hasMissing) {
                numberLabel.text = ball.value;
                numberLabel.textAlignment = NSTextAlignmentCenter;
                numberLabel.textColor = kRGBColor(230.0f, 230.0f, 230.0f);
            }
            [self addSubview:numberLabel];
        }
        i += 1;
    }
}

- (void)changeBackground {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

@end
