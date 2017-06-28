//
//  MyNumberCell.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/18.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNumberCell : UITableViewCell

- (void)setReds:(NSArray *)reds andBlues:(NSArray *)blues;

+ (CGFloat)heightOfCellWithCount:(NSUInteger)count;

@end
