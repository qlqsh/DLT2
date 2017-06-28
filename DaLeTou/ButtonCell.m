//
//  ButtonCell.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/17.
//  Copyright © 2017年 刘明. All rights reserved.
//

#define kSpace kScreenWidth*0.02
#define kButtonWidth (kScreenWidth/3 - kSpace*2)  // 按钮宽度
#define kButtonHeight 40.0f                       // 按钮高度

#import "ButtonCell.h"

@implementation ButtonCell
#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.addButton];
        [self.contentView addSubview:self.clearButton];
        [self.contentView addSubview:self.calculateButton];
    }
    return self;
}

#pragma mark - 类方法
+ (CGFloat)heightOfCell {
    return kButtonHeight + kScreenWidth*0.04;
}

#pragma mark - 属性获取
- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(kSpace, kSpace, kButtonWidth, kButtonHeight);
        _addButton.layer.borderWidth = 0.5f;
        _addButton.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
        _addButton.layer.cornerRadius = kButtonHeight / 2;
        
        [_addButton setTitle:@"我的号码" forState:UIControlStateNormal];
        [_addButton setTitleColor:kRedColor forState:UIControlStateNormal];
    }
    
    return _addButton;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(kSpace*3+kButtonWidth, kSpace, kButtonWidth, kButtonHeight);
        _clearButton.layer.borderWidth = 0.5f;
        _clearButton.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
        _clearButton.layer.cornerRadius = kButtonHeight / 2;
        
        [_clearButton setTitle:@"清除" forState:UIControlStateNormal];
        [_clearButton setTitleColor:kRedColor forState:UIControlStateNormal];
    }
    
    return _clearButton;
}

- (UIButton *)calculateButton {
    if (!_calculateButton) {
        _calculateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _calculateButton.frame = CGRectMake(kSpace*5+kButtonWidth*2, kSpace, kButtonWidth, kButtonHeight);
        _calculateButton.layer.borderWidth = 0.5f;
        _calculateButton.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
        _calculateButton.layer.cornerRadius = kButtonHeight / 2;
        
        [_calculateButton setTitle:@"计算奖金" forState:UIControlStateNormal];
        [_calculateButton setTitleColor:kRedColor forState:UIControlStateNormal];
    }
    
    return _calculateButton;
}

@end
