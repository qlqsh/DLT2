//
//  WinningSimpleCell.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/6.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "WinningSimpleCell.h"
#import "WinningBaseView.h"

@implementation WinningSimpleCell

/// 默认初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 期号标签
        UILabel *termLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 60, 20)];
        termLabel.font = [UIFont systemFontOfSize:12.0f];
        termLabel.textColor = [UIColor grayColor];
        termLabel.textAlignment = NSTextAlignmentCenter;
        termLabel.tag = 101;
        [self.contentView addSubview:termLabel];
        
        // 基本获奖视图
        WinningBaseView *winningBaseView =
            [[WinningBaseView alloc] initWithPosition:CGPointMake(60, 0)];
        winningBaseView.tag = 102;
        [self.contentView addSubview:winningBaseView];
        
        // 缩放
        CGFloat scale = WinningSimpleCell.scale;
        self.transform = CGAffineTransformMakeScale(scale, scale);
        self.frame = CGRectMake(0, 0,
                                kWinningBaseViewDefaultWidth*scale,
                                kWinningBaseViewDefaultHeight*scale);
    }
    
    return self;
}

#pragma mark - 公共类方法
/// 单元格高度。
+ (CGFloat)heightOfCell {
    return ceil(kWinningBaseViewDefaultHeight*WinningSimpleCell.scale);
}

/// 缩放比例。当前屏幕宽度 ÷（期号宽度+默认获奖基本视图宽度）
+ (CGFloat)scale {
    return kScreenWidth/(60.0f + kWinningBaseViewDefaultWidth);
}

@end
