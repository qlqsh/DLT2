//
//  WinningDetailAdditionalCell2.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/14.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "WinningDetailAdditionalCell2.h"

@implementation WinningDetailAdditionalCell2

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 奖项
        UILabel *awardsLabel = [[UILabel alloc] init];
        awardsLabel.frame = CGRectMake(0, 0, kScreenWidth*0.3, 25.0f);
        awardsLabel.textAlignment = NSTextAlignmentCenter;
        awardsLabel.font = [UIFont systemFontOfSize:16.0f];
        awardsLabel.tag = 131;
        [self.contentView addSubview:awardsLabel];
        
        // 获奖人数
        UILabel *winningAmountLabel = [[UILabel alloc] init];
        winningAmountLabel.frame = CGRectMake(kScreenWidth*0.3, 0, kScreenWidth*0.3, 25.0f);
        winningAmountLabel.textAlignment = NSTextAlignmentCenter;
        winningAmountLabel.font = [UIFont systemFontOfSize:16.0f];
        winningAmountLabel.tag = 132;
        [self.contentView addSubview:winningAmountLabel];
        
        // 获奖金额
        UILabel *winningMoneyLabel = [[UILabel alloc] init];
        winningMoneyLabel.frame = CGRectMake(kScreenWidth*0.6, 0, kScreenWidth*0.4, 25.0f);
        winningMoneyLabel.textAlignment = NSTextAlignmentCenter;
        winningMoneyLabel.font = [UIFont systemFontOfSize:16.0f];
        winningMoneyLabel.tag = 133;
        [self.contentView addSubview:winningMoneyLabel];
    }
    return self;
}

+ (CGFloat)heightOfCell {
    return 25.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
