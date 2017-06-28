//
//  AnRowStatisticsView.m
//  DaLeTou
//
//  Created by 刘明 on 2017/6/12.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "AnRowStatisticsView.h"

@interface AnRowStatisticsView()
@property (nonatomic, strong) NSArray *numberLabels;
@end

@implementation AnRowStatisticsView

/// 初始化。
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        
        // 数字标签
        NSMutableArray *numberLabels = [NSMutableArray arrayWithCapacity:47];
        for (int i = 1; i <= 47; i++) {
            CGRect frame = CGRectMake(_titleLabel.frame.size.width + (i - 1) * 25, 0, 25, 25);
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:frame];
            numberLabel.layer.borderWidth = 0.5f;
            numberLabel.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.font = [UIFont systemFontOfSize:11.0f];
            [self addSubview:numberLabel];
            [numberLabels addObject:numberLabel];
        }
        _numberLabels = [numberLabels copy];
    }
    return self;
}

/// 建立标题标签。
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, 25)];
        _titleLabel.font = [UIFont systemFontOfSize:11.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.borderWidth = 0.5f;
        _titleLabel.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
    }
    return _titleLabel;
}

/// 设置内容。统计数据。
- (void)setStatistics:(NSArray *)statistics {
    if (_numberLabels.count < statistics.count) {
        return;
    }
    for (int i = 0; i < _numberLabels.count; i++) {
        UILabel *numberLabel = _numberLabels[i];
        numberLabel.text = statistics[i];
    }
}

/// 设置状态。改变文字颜色。
- (void)setState:(NSUInteger)state {
    UIColor *textColor = [UIColor grayColor];
    switch (state) {
        case 0:
            textColor = [UIColor purpleColor];
            break;
        case 1:
            textColor = [UIColor cyanColor];
            break;
        case 2:
            textColor = [UIColor brownColor];
            break;
        case 3:
            textColor = [UIColor greenColor];
            break;
        default:
            break;
    }
    _titleLabel.textColor = textColor;
    _titleLabel.backgroundColor = (state%2 == 1) ? kRGBColor(246.0f, 240.0f, 240.0f) : kRGBColor(235.0f, 231.0f, 219.0f);
    
    for (UILabel *numberLabel in _numberLabels) {
        numberLabel.textColor = textColor;
        numberLabel.backgroundColor = (state%2 == 1) ? [UIColor groupTableViewBackgroundColor] : [UIColor whiteColor];
    }
}

@end
