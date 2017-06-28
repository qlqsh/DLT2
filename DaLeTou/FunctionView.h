//
//  FunctionCell.h
//  DaLeTou
//
//  Created by 刘明 on 2017/6/12.
//  Copyright © 2017年 刘明. All rights reserved.
//

#define kIsWinning  0
#define kIsTrend    1
#define kIsHistorySame  2
#define kIsStatistics   3
#define kIsConditionTrend   4
#define kIsCalculateMoney   5
#define kIsCombination      6
#define kIsCompatibility    7

#import <UIKit/UIKit.h>

@interface FunctionView : UIView

@property (nonatomic, strong) UIView *iconView;             // 图标
@property (nonatomic, strong) UILabel *descriptionLabel;    // 功能描述
@property (nonatomic) NSUInteger state;                     // 状态

@end
