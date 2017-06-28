//
//  FunctionCell.m
//  DaLeTou
//
//  Created by 刘明 on 2017/6/12.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "FunctionView.h"
#import "Common.h"

@implementation FunctionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = kRGBColor(230, 230, 230).CGColor;
        self.layer.masksToBounds = true;
        
        [self addSubview:self.iconView];
        [self addSubview:self.descriptionLabel];
    }
    return self;
}

#pragma mark - 属性
- (UIView *)iconView {
    if (!_iconView) {
        CGFloat height = self.bounds.size.height * 0.8;
        CGFloat space = height * 0.1;
        CGFloat width = height - space * 2;
        _iconView = [[UIView alloc] initWithFrame:CGRectMake(space, space, width, width)];
        _iconView.backgroundColor = [UIColor grayColor];
        _iconView.layer.cornerRadius = width / 2;
    }
    return _iconView;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height * 0.2;
        CGFloat offsetY = self.bounds.size.height * 0.8;
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, offsetY, width, height)];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = kRGBColor(69, 69, 69);
    }
    return _descriptionLabel;
}

- (void)setState:(NSUInteger)state {
    switch (state) {
        case 0:
            _descriptionLabel.text = @"开奖公告";
            _iconView.backgroundColor = kRedColor;
            [self drawWinningIconView];
            break;
        case 1:
            _descriptionLabel.text = @"走势图";
            _iconView.backgroundColor = kBlueColor;
            [self drawTrendIconView];
            break;
        case 2:
            _descriptionLabel.text = @"历史同期";
            _iconView.backgroundColor = kGreenColor;
            [self drawHistorySameIconView];
            break;
        case 3:
            _descriptionLabel.text = @"统计";
            _iconView.backgroundColor = kOrangeColor;
            [self drawStatisticsIconView];
            break;
        case 4:
            _descriptionLabel.text = @"相似走势";
            _iconView.backgroundColor = kYellowColor;
            [self drawConditionTrendIconView];
            break;
        case 5:
            _descriptionLabel.text = @"奖金计算";
            _iconView.backgroundColor = kCyanColor;
            [self drawCalculateMoneyIconView];
            break;
        case 6:
            _descriptionLabel.text = @"号码组合";
            _iconView.backgroundColor = [UIColor magentaColor];
            [self drawCombinationIconView];
            break;
        case 7:
            _descriptionLabel.text = @"号码契合度";
            _iconView.backgroundColor = [UIColor brownColor];
            [self drawCompatibilityIconView];
            break;
        default:
            break;
    }
}

#pragma mark - 图标绘制
/// 绘制图形添加到图标层
- (void)addToLayer:(UIBezierPath *)path andFill:(BOOL)fill {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = _iconView.bounds;
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = fill ? [UIColor whiteColor].CGColor : [UIColor clearColor].CGColor;
    layer.lineWidth = 2.0f;
    layer.lineCap = kCALineCapRound;
    [_iconView.layer addSublayer:layer];
}

/// 开奖公告图标（奖杯）
- (void)drawWinningIconView {
    CGFloat centerX = _iconView.frame.size.width / 2;
    CGFloat centerY = _iconView.frame.size.height / 2;
    
    UIGraphicsBeginImageContext(_iconView.bounds.size);
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(centerX, centerY)];
    [linePath addQuadCurveToPoint:CGPointMake((CGFloat) (centerX * 0.5), (CGFloat) (centerY * 0.5))
                     controlPoint:CGPointMake(centerX * 1 / 3, centerY * 2 / 3)];
    [linePath addLineToPoint:CGPointMake((CGFloat) (centerX * 1.5), (CGFloat) (centerY * 0.5))];
    [linePath addQuadCurveToPoint:CGPointMake(centerX, centerY)
                     controlPoint:CGPointMake(centerX * 2 - centerX * 1 / 3, centerY * 2 / 3)];
    [linePath addLineToPoint:CGPointMake(centerX, (CGFloat) (centerY * 1.5))];
    [linePath addLineToPoint:CGPointMake((CGFloat) (centerX * 1.5), (CGFloat) (centerY * 1.5))];
    [linePath addLineToPoint:CGPointMake((CGFloat) (centerX * 0.5), (CGFloat) (centerY * 1.5))];
    [linePath addLineToPoint:CGPointMake(centerX, (CGFloat) (centerY * 1.5))];
    [linePath addLineToPoint:CGPointMake(centerX, centerY)];
    [linePath stroke];
    UIGraphicsEndImageContext();
    
    [self addToLayer:linePath andFill:false];
}

/// 走势图标
- (void)drawTrendIconView {
    CGFloat radius = _iconView.frame.size.height / 10; // 半径
    
    // 折线
    UIGraphicsBeginImageContext(_iconView.bounds.size);
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(radius * 2 + radius / 2, (CGFloat) (radius * 6.5 + radius / 2))];
    [linePath addLineToPoint:CGPointMake((CGFloat) (radius * 3.5 + radius / 2), (CGFloat) (radius * 3.5 + radius / 2))];
    [linePath addLineToPoint:CGPointMake((CGFloat) (radius * 5.5 + radius / 2), (CGFloat) (radius * 5.5 + radius / 2))];
    [linePath addLineToPoint:CGPointMake(radius * 7 + radius / 2, (CGFloat) (radius * 2.5 + radius / 2))];
    [linePath stroke];
    UIGraphicsEndImageContext();
    
    [self addToLayer:linePath andFill:false];

    // 圆
    UIGraphicsBeginImageContext(_iconView.bounds.size);
    UIBezierPath *circlePath1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(radius * 2, radius * 6.5, radius, radius)];
    [self addToLayer:circlePath1 andFill:true];
    UIBezierPath *circlePath2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(radius * 3.5, radius * 3.5, radius, radius)];
    [self addToLayer:circlePath2 andFill:true];
    UIBezierPath *circlePath3 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(radius * 5.5, radius * 5.5, radius, radius)];
    [self addToLayer:circlePath3 andFill:true];
    UIBezierPath *circlePath4 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(radius * 7, radius * 2.5, radius, radius)];
    UIGraphicsEndImageContext();
    
    [self addToLayer:circlePath4 andFill:true];
}

#define PI 3.14159265358979323846
/// 历史同期图标
- (void)drawHistorySameIconView {
    CGFloat radius = _iconView.frame.size.height / 2 - _iconView.frame.size.height / 5;
    CGFloat centerX = _iconView.frame.size.height / 2;
    CGFloat centerY = centerX;
    
    UIGraphicsBeginImageContext(_iconView.bounds.size);
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY)
                                                           radius:radius
                                                       startAngle:(55.0 * PI) / 180.0
                                                         endAngle:(395.0 * PI) / 180.0
                                                        clockwise:true];
    [self addToLayer:arcPath andFill:false];
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(centerX, centerY * 5 / 8)];
    [linePath addLineToPoint:CGPointMake(centerX, centerY)];
    [linePath addLineToPoint:CGPointMake(centerX + centerX * 1 / 4, centerY + centerY * 1 / 4)];
    UIGraphicsEndImageContext();
    
    [self addToLayer:linePath andFill:false];
}

/// 统计图标
- (void)drawStatisticsIconView {
    CGFloat radius = _iconView.frame.size.height / 2 - _iconView.frame.size.height / 5;
    CGFloat centerX = _iconView.frame.size.height / 2;
    CGFloat centerY = centerX;
    
    // 实心（3/4）圆
    UIGraphicsBeginImageContext(_iconView.bounds.size);
    UIBezierPath *solidCirclePath = [UIBezierPath bezierPath];
    [solidCirclePath moveToPoint:CGPointMake(centerX, centerY)];
    [solidCirclePath addArcWithCenter:CGPointMake(centerX, centerY)
                               radius:radius
                           startAngle:360 * PI / 180
                             endAngle:270 * PI / 180
                            clockwise:true];
    [solidCirclePath closePath];
    UIGraphicsEndImageContext();
    
    [self addToLayer:solidCirclePath andFill:true];
    
    // 空心（1/4）圆，稍微偏移（0.1）。
    UIGraphicsBeginImageContext(_iconView.bounds.size);
    UIBezierPath *hollowCirclePath = [UIBezierPath bezierPath];
    [hollowCirclePath moveToPoint:CGPointMake(centerX * 1.1, centerY * 0.9)];
    [hollowCirclePath addArcWithCenter:CGPointMake(centerX * 1.1, centerY * 0.9)
                                radius:radius
                            startAngle:270 * PI / 180
                              endAngle:360 * PI / 180
                             clockwise:true];
    [hollowCirclePath closePath];
    UIGraphicsEndImageContext();
    
    [self addToLayer:hollowCirclePath andFill:false];
}

/// 相似走势图标（九宫格样式）
- (void)drawConditionTrendIconView {
    CGFloat width = _iconView.bounds.size.width / 2 / 3;
    CGFloat positionX = (_iconView.bounds.size.width - width * 3) / 2;
    CGFloat positionY = positionX;
    
    UIGraphicsBeginImageContext(_iconView.bounds.size);
    UIBezierPath *circle1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(positionX, positionY, width, width)];
    UIBezierPath *circle2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(positionX + width, positionY + width, width, width)];
    UIBezierPath *circle3 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(positionX, positionY + width * 2, width, width)];
    UIBezierPath *circle4 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(positionX + width * 2, positionY + width * 2, width, width)];
    UIGraphicsEndImageContext();
    
    [self addToLayer:circle1 andFill:true];
    [self addToLayer:circle2 andFill:true];
    [self addToLayer:circle3 andFill:true];
    [self addToLayer:circle4 andFill:true];
}

/// 计算奖金图标（一个放大镜，里面是¥符号）
- (void)drawCalculateMoneyIconView {
    CGFloat radius = _iconView.frame.size.width * 3 / 5 * 4 / 5 / 2;
    CGFloat centerX = _iconView.frame.size.width * 1 / 5 + radius;
    CGFloat centerY = centerX;
    
    // 放大镜
    UIGraphicsBeginImageContext(_iconView.bounds.size);
    UIBezierPath *magnifierPath = [UIBezierPath bezierPath];
    [magnifierPath moveToPoint:CGPointMake(centerX, centerY)];
    [magnifierPath addArcWithCenter:CGPointMake(centerX, centerY)
                             radius:radius
                         startAngle:45 * PI / 180
                           endAngle:405 * PI / 180
                          clockwise:true];
    [magnifierPath addLineToPoint:CGPointMake(_iconView.frame.size.width * 4 / 5,
                                              _iconView.frame.size.width * 4 / 5)];
    [magnifierPath closePath];
    UIGraphicsEndImageContext();
    
    [self addToLayer:magnifierPath andFill:true];
    
    CAShapeLayer *magnifierLayer = [CAShapeLayer layer];
    magnifierLayer.path = magnifierPath.CGPath;
    magnifierLayer.strokeColor = [UIColor whiteColor].CGColor;
    magnifierLayer.fillColor = [UIColor whiteColor].CGColor;
    magnifierLayer.lineWidth = 4.0f;
    magnifierLayer.lineCap = kCALineCapRound;
    [_iconView.layer addSublayer:magnifierLayer];
    
    // “¥”符号
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - radius, centerY - radius, radius * 2, radius * 2)];
    moneyLabel.text = @"¥";
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.textColor = [UIColor cyanColor];
    moneyLabel.font = [UIFont systemFontOfSize:45 * kScreenWidth / 320];
    [_iconView addSubview:moneyLabel];
}

/// 获奖球组合统计图标
- (void)drawCombinationIconView {
    CGFloat space = 5.0f;
    CGFloat width = _iconView.bounds.size.width / 2;
    CGFloat positionX = _iconView.bounds.size.width / 2 - width / 2;
    CGFloat positionY = positionX;
    
    UIGraphicsBeginImageContext(_iconView.bounds.size);
    UIBezierPath *circle1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(positionX, positionY, width, width)];
    UIBezierPath *circle2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(positionX - space, positionY - space, width + space * 2, width + space * 2)];
    UIGraphicsEndImageContext();
    
    [self addToLayer:circle1 andFill:true];
    [self addToLayer:circle2 andFill:false];
}

/// 号码契合度图标
- (void)drawCompatibilityIconView {
    CGFloat width = _iconView.frame.size.width;
    
    // 六边形
    CGRect rect = CGRectMake(width * 0.2, width * 0.2, width * 0.6, width * 0.6);
    UIBezierPath *polygonPath = [Common addPolygonInRect:rect
                                                   sides:6
                                               lineWidth:1.0
                                            cornerRadius:0];
    [self addToLayer:polygonPath andFill:false];
}

@end
