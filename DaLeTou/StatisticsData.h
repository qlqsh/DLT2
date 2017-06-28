//
//  StatisticsData.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/14.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Winning;

@interface StatisticsData : NSObject
#pragma mark - 公开对象
+ (instancetype)shared;

#pragma mark - 统计（红、蓝、头、尾、和值范围、连号概率）
- (NSArray *)redCount;    // 红球出现情况
- (NSArray *)blueCount;   // 蓝球出现情况
- (NSArray *)headCount;   // 头号出现情况
- (NSArray *)tailCount;   // 尾号出现情况
- (NSArray *)valueOfSum;  // 和值（每差值10为1档）范围
- (NSArray *)continuousCount;  // 连号情况

#pragma mark - 开放方法
- (NSArray *)historySame;

#pragma mark - 历史相似走势
- (NSArray *)nextWinningOfConformConditionWithMultipleCondition:(NSArray *)multipleCondition;

#pragma mark - 奖金计算
- (NSString *)calculateMoneyWithCurrentWinning:(Winning *)currentWinning
                                   andMyNumber:(NSArray *)myNumbers;

#pragma mark - 数字组合
- (NSDictionary *)combinations;

@end
