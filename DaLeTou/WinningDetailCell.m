//
//  WinningDetailCell.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/6.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "WinningDetailCell.h"
#import "WinningBaseView.h"

@interface WinningDetailCell ()

@end

@implementation WinningDetailCell

/// 默认初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 期号标签
        UILabel *termLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*0.05, 0,
                                                                       kScreenWidth*0.45, 20)];
        termLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        termLabel.textAlignment = NSTextAlignmentLeft;
        termLabel.tag = 111;
        [self.contentView addSubview:termLabel];
        
        // 时间标签
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*0.5, 0,
                                                                       kScreenWidth*0.45, 20)];
        dateLabel.font = [UIFont systemFontOfSize:14.0f];
        dateLabel.textAlignment = NSTextAlignmentRight;
        dateLabel.tag = 112;
        [self.contentView addSubview:dateLabel];
        
        // 基本获奖视图
        WinningBaseView *winningBaseView =
            [[WinningBaseView alloc] initWithPosition:CGPointMake(kScreenWidth*0.05, 20)];
        winningBaseView.scale = WinningDetailCell.scale;
        winningBaseView.tag = 113;
        [self.contentView addSubview:winningBaseView];
    }
    
    return self;
}

#pragma mark - 公共类方法
/// 单元格高度。
+ (CGFloat)heightOfCell {
    return ceil(kWinningBaseViewDefaultHeight*WinningDetailCell.scale) + 20;
}

/// 缩放比例。当前屏幕宽度 ÷ 默认获奖基本视图宽度
+ (CGFloat)scale {
    return kScreenWidth*0.9/kWinningBaseViewDefaultWidth;
}

@end
