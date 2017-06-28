//
//  TrendData.h
//  DaLeTou
//
//  Created by 刘明 on 2017/6/8.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrendData : NSObject

#pragma mark - 基础数据
@property (nonatomic, strong) NSArray *trendArray;  // 获取走势数组（获奖号码+遗漏值）
@property (nonatomic, strong) NSArray *terms;       // 期号数组

#pragma mark - 统计数据
@property (nonatomic, strong) NSArray *numberOfOccurrences;
@property (nonatomic, strong) NSArray *maxContinuousOccurrences;
@property (nonatomic, strong) NSArray *maxMissing;
@property (nonatomic, strong) NSArray *averageMissing;

#pragma mark - 公开对象
+ (instancetype)shared;

@end
