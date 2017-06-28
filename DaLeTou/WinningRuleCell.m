//
//  WinningRuleCell.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/14.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "WinningRuleCell.h"
#import "WinningBaseView.h"

@implementation WinningRuleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *awardsLabel = [[UILabel alloc] init];
        awardsLabel.frame = CGRectMake(0, 0, kScreenWidth*0.2, [WinningRuleCell heightOfCell]);
        awardsLabel.textAlignment = NSTextAlignmentCenter;
        awardsLabel.font = [UIFont systemFontOfSize:10.0f];
        awardsLabel.tag = 141;
        [self.contentView addSubview:awardsLabel];
        
        UILabel *moneyLabel = [[UILabel alloc] init];
        moneyLabel.frame = CGRectMake(kScreenWidth*0.2, 0, kScreenWidth*0.2, [WinningRuleCell heightOfCell]);
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.font = [UIFont systemFontOfSize:10.0f];
        moneyLabel.tag = 142;
        [self.contentView addSubview:moneyLabel];
        
        UIView *rulesView = [[UIView alloc] init];
        rulesView.frame = CGRectMake(kScreenWidth*0.4, 0, kScreenWidth*0.6, [WinningRuleCell heightOfCell]);
        rulesView.tag = 143;
        [self.contentView addSubview:rulesView];
    }
    return self;
}

+ (CGFloat)heightOfCell {
    return kWinningBaseViewDefaultHeight * kScreenWidth/kWinningBaseViewDefaultWidth * 0.6;
}

@end
