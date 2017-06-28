//
//  ButtonCell.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/17.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonCell : UITableViewCell

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *calculateButton;

+ (CGFloat)heightOfCell;

@end
