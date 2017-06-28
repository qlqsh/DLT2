//
//  BaseStatisticsView.h
//  DaLeTou
//
//  Created by 刘明 on 2017/6/14.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseStatisticsView : UIView
- (instancetype)initWithBall:(NSString *)ball
                     andShow:(NSUInteger)show
                    andTotal:(NSUInteger)total;
@end
