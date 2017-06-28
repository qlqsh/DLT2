//
//  Winning.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/11.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 一条获奖信息对象。
@interface Winning : NSObject <NSCoding>

#pragma mark - 属性
@property (nonatomic, copy) NSString *date;     // 时间
@property (nonatomic, copy) NSString *week;     // 星期几（由时间计算）
@property (nonatomic, copy) NSString *term;     // 期号
@property (nonatomic, strong) NSArray *reds;    // 红球
@property (nonatomic, strong) NSArray *blues;   // 蓝球
@property (nonatomic, copy) NSString *pool;     // 奖池滚存
@property (nonatomic, copy) NSString *sales;    // 全国销量
/// 奖项字典：一等奖人数（firstNumber）、一等奖奖金（firstMoney）；二等奖人数、二等奖奖金；。。。以此类推。
@property (nonatomic, strong) NSDictionary *prizeState;

#pragma mark - 初始化对象
- (instancetype)initWithHtmlContent:(NSString *)htmlContent;

#pragma mark - 自定义方法
/// 所有球数据（红球+蓝球）。
- (NSArray *)balls;

/// 包含字符串。
- (BOOL)containsReds:(NSString *)reds;
- (BOOL)containsBlues:(NSString *)blues;

#pragma mark - 数字（红球、蓝球）组合
- (NSArray *)redCombinationWithNumber:(NSUInteger)number;
- (NSArray *)blueCombinationWithNumber:(NSUInteger)number;

@end
