//
//  ConditionCell.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/22.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConditionCell : UITableViewCell

- (void)setConditionBalls:(NSArray *)conditionBalls andState:(NSUInteger)state;
+ (CGFloat)heightOfCell;

@end
