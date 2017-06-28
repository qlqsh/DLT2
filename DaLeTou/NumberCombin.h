//
//  NumberCombin.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/4.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberCombin : NSObject

#pragma mark - 属性
@property (nonatomic, readonly, copy) NSArray *numbers;     // 号码
@property (nonatomic, readonly, strong) NSNumber *sumValue; // 和值
@property (nonatomic, readonly, assign) BOOL hasContinuous; // 连号
@property (nonatomic, assign) NSUInteger showNumber;        // 出现次数

#pragma mark - 初始化
- (instancetype)initWithArray:(NSArray *)numberArray;
- (instancetype)initWithString:(NSString *)numberString;

#pragma mark - 公开方法
- (BOOL)contains:(NSString *)numberString;                  // 包含
- (NSComparisonResult)compare:(NumberCombin *)numberCombin; // 比较
- (NSString *)toString; // 字符串显示numbers

@end
