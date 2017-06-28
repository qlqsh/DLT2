//
//  BallList.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/19.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "BallList.h"

@implementation BallList

/**
 * 球列表。主要用来从一个大的球组合（比如：10个红球），分解成小的球组合（比如：210组6个红球）。
 * @param balls 所有的球
 * @return 初始化对象
 */
- (instancetype)initWithBalls:(NSArray *)balls {
    if (self = [super init]) {
        _balls = balls;
    }
    
    return self;
}


#pragma mark - 获取指定个数的数字组合
- (NSArray *)combining:(NSUInteger)number {
    if (number == 1) {
        return _balls;
    }
    
    return [self combiningWithArray:[self combining:number - 1]];
}

- (NSArray *)combiningWithArray:(NSArray *)numberArray {
    NSMutableArray *combiningArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < numberArray.count; i++) {
        for (NSUInteger j = 0; j < _balls.count; j++) {
            NSArray *childArray = [numberArray[i] componentsSeparatedByString:@" "];
            NSInteger lastObjectValue = [childArray.lastObject integerValue];
            if ([_balls[j] integerValue] > lastObjectValue) {
                [combiningArray addObject:[NSString stringWithFormat:@"%@ %@", numberArray[i], _balls[j]]];
            }
        }
    }
    
    return [combiningArray copy];
}

@end
