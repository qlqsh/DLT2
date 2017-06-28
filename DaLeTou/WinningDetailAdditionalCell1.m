//
//  WinningDetailCell1.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/13.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "WinningDetailAdditionalCell1.h"

@implementation WinningDetailAdditionalCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 静态标签
        UILabel *poolLabel = [[UILabel alloc] init];
        poolLabel.frame = CGRectMake(0, 5, kScreenWidth*0.5, 25.0f);
        poolLabel.text = @"奖池滚存";
        poolLabel.textAlignment = NSTextAlignmentCenter;
        poolLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:poolLabel];
        
        UILabel *salesLabel = [[UILabel alloc] init];
        salesLabel.frame = CGRectMake(kScreenWidth*0.5, 5, kScreenWidth*0.5, 25.0f);
        salesLabel.text = @"全国销量";
        salesLabel.textAlignment = NSTextAlignmentCenter;
        salesLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:salesLabel];
        
        // 动态标签
        UILabel *poolMoneyLabel = [[UILabel alloc] init];
        poolMoneyLabel.frame = CGRectMake(0, 30, kScreenWidth*0.5, 25.0f);
        poolMoneyLabel.textAlignment = NSTextAlignmentCenter;
        poolMoneyLabel.font = [UIFont systemFontOfSize:16.0f];
        poolMoneyLabel.tag = 121;
        [self.contentView addSubview:poolMoneyLabel];
        
        UILabel *salesMoneyLabel = [[UILabel alloc] init];
        salesMoneyLabel.frame = CGRectMake(kScreenWidth*0.5, 30, kScreenWidth*0.5, 25.0f);
        salesMoneyLabel.textAlignment = NSTextAlignmentCenter;
        salesMoneyLabel.font = [UIFont systemFontOfSize:16.0f];
        salesMoneyLabel.tag = 122;
        [self.contentView addSubview:salesMoneyLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightOfCell {
    return 60.0f;
}

@end
