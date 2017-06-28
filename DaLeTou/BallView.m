//
//  BallView.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/5.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "BallView.h"

@implementation BallView

#pragma mark - 初始化
/// 在指定位置绘制视图。
- (instancetype)initWithPosition:(CGPoint)position {
    CGFloat defaultWidth = kDefaultBallWidth + kDefaultSpace*2;
    CGRect frame = CGRectMake(position.x, position.y, defaultWidth, defaultWidth);
    if (self = [super initWithFrame:frame]) {
        CGRect contentFrame = CGRectMake(kDefaultSpace,
                                         kDefaultSpace,
                                         kDefaultBallWidth,
                                         kDefaultBallWidth);
        _backgroundView = [[UIImageView alloc] initWithFrame:contentFrame];
        _backgroundView.layer.cornerRadius = _backgroundView.frame.size.width / 2; // 圆形
        _backgroundView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_backgroundView];
        
        _textLabel = [[UILabel alloc] initWithFrame:contentFrame];
        _textLabel.font = [UIFont systemFontOfSize:kDefaultBallFontSize];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return self;
}

#pragma mark - 属性设置
/// 设置状态（白底红字、白底蓝字、红底白字、蓝底白字）
- (void)setState:(NSUInteger)state {
    switch (state) {
        case kBallIsBlank1: {
            _textLabel.textColor = kRedColor;
            _backgroundView.image = [UIImage imageNamed:@"WhiteBallBackground"];
            break;
        }
        case kBallIsBlank2: {
            _textLabel.textColor = kBlueColor;
            _backgroundView.image = [UIImage imageNamed:@"WhiteBallBackground"];
            break;
        }
        case kBallIsRed: {
            _textLabel.textColor = [UIColor whiteColor];
            _backgroundView.image = [UIImage imageNamed:@"RedBallBackground"];
            break;
        }
        case kBallIsBlue: {
            _textLabel.textColor = [UIColor whiteColor];
            _backgroundView.image = [UIImage imageNamed:@"BlueBallBackground"];
            break;
        }
        default:
            break;
    }
}

@end
