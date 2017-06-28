//
//  WinningMoneyCell.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/19.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyCell : UITableViewCell

@property (nonatomic, strong) UITextView *winningMoneyView;

+ (CGFloat)heightOfCell;

@end
