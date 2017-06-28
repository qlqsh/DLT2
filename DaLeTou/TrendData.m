//
//  TrendData.m
//  DaLeTou
//
//  Created by 刘明 on 2017/6/8.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "TrendData.h"
#import "DataManager.h"
#import "Winning.h"
#import "Ball.h"

@interface TrendData()
@property (nonatomic, strong) NSArray *ballsAndMissings;
@end

@implementation TrendData

#pragma mark - 公开对象
+ (instancetype)shared {
    return [[TrendData alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        NSArray *winnings = [[DataManager shared] readAllWinningInFileUseReverse];
        
        NSMutableArray *ballsAndMissings = [NSMutableArray arrayWithCapacity:47];
        // 转换红球
        for (int i = 1; i <= 35; i++) {
            // 红球获奖号码和遗漏值
            NSMutableArray *redsAndMissings = [NSMutableArray arrayWithCapacity:winnings.count];
            NSUInteger missingValue = 0;
            for (Winning *winning in winnings) {
                NSString *red = i < 10 ? [NSString stringWithFormat:@"0%d", i] : [NSString stringWithFormat:@"%d", i];
                if ([winning containsReds:red]) {
                    Ball *ball = [[Ball alloc] initWithValue:red andIsBall:YES];
                    [redsAndMissings addObject:ball];
                    missingValue = 0;
                } else {
                    missingValue += 1;
                    Ball *ball = [[Ball alloc] initWithValue:[NSString stringWithFormat:@"%lu", (unsigned long)missingValue] andIsBall:NO];
                    [redsAndMissings addObject:ball];
                }
            }
            [ballsAndMissings addObject:redsAndMissings];
        }
        
        // 转换蓝球
        for (int i = 1; i <= 12; i++) {
            // 蓝球获奖号码和遗漏值
            NSMutableArray *bluesAndMissings = [NSMutableArray arrayWithCapacity:winnings.count];
            NSUInteger missingValue = 0;
            for (Winning *winning in winnings) {
                NSString *blue = i < 10 ? [NSString stringWithFormat:@"0%d", i] : [NSString stringWithFormat:@"%d", i];
                if ([winning containsBlues:blue]) {
                    Ball *ball = [[Ball alloc] initWithValue:blue andIsBall:YES];
                    [bluesAndMissings addObject:ball];
                    missingValue = 0;
                } else {
                    missingValue += 1;
                    Ball *ball = [[Ball alloc] initWithValue:[NSString stringWithFormat:@"%lu", (unsigned long)missingValue] andIsBall:NO];
                    [bluesAndMissings addObject:ball];
                }
            }
            [ballsAndMissings addObject:bluesAndMissings];
        }
        
        // 90度旋转整个数组（行变列、列变行）
        NSUInteger column = winnings.count; // 列
        NSUInteger row = 47;                // 横行
        NSMutableArray *trendBallArray = [NSMutableArray arrayWithCapacity:column];
        for (int i = 0; i < column; i++) {
            [trendBallArray addObject:[NSMutableArray arrayWithCapacity:row]];
        }
        for (NSUInteger i = 0; i < row; ++i) {
            for (NSUInteger j = 0; j < column; ++j) {
                trendBallArray[j][i] = ballsAndMissings[i][j];
            }
        }
        _trendArray = [trendBallArray copy];
        
        NSMutableArray *mutableTerms = [NSMutableArray arrayWithCapacity:winnings.count];
        // 期号放入另一个数组，走势需要。
        for (Winning *winning in winnings) {
            [mutableTerms addObject:winning.term];
        }
        _terms = [mutableTerms copy];
        
        _ballsAndMissings = [ballsAndMissings copy];
    }
    return self;
}

#pragma mark - 4个统计（出现次数、最大连出、最大遗漏、平均遗漏）
/// 出现次数
- (NSArray *)numberOfOccurrences {
    if (!_numberOfOccurrences) {
        NSMutableArray *showArray = [NSMutableArray arrayWithCapacity:47];
        for (NSArray *ballAndMissing in _ballsAndMissings) {
            NSUInteger show = 0;
            for (Ball *ball in ballAndMissing) {
                if (ball.isBall) {
                    show += 1;
                }
            }
            [showArray addObject:[NSString stringWithFormat:@"%lu", (unsigned long)show]];
        }
        _numberOfOccurrences = [showArray copy];
    }
    return _numberOfOccurrences;
}

/// 最大连出
- (NSArray *)maxContinuousOccurrences {
    if (!_maxContinuousOccurrences) {
        NSMutableArray *maxArray = [NSMutableArray arrayWithCapacity:47];
        for (NSArray *ballAndMissing in _ballsAndMissings) {
            NSUInteger max = 0;
            NSUInteger show = 0;
            for (Ball *ball in ballAndMissing) {
                if (ball.isBall) {
                    show += 1;
                } else {
                    if (show > max) {
                        max = show;
                    }
                    show = 0;
                }
            }
            [maxArray addObject:[NSString stringWithFormat:@"%lu", (unsigned long)max]];
        }
        _maxContinuousOccurrences = [maxArray copy];
    }
    return _maxContinuousOccurrences;
}

/// 最大遗漏
- (NSArray *)maxMissing {
    if (!_maxMissing) {
        NSMutableArray *maxMissingArray = [NSMutableArray arrayWithCapacity:47];
        for (NSArray *ballAndMissing in _ballsAndMissings) {
            NSUInteger max = 0;
            NSUInteger show = 0;
            for (Ball *ball in ballAndMissing) {
                if (!ball.isBall) {
                    show += 1;
                } else {
                    if (show > max) {
                        max = show;
                    }
                    show = 0;
                }
            }
            [maxMissingArray addObject:[NSString stringWithFormat:@"%lu", (unsigned long)max]];
        }
        _maxMissing = maxMissingArray;
    }
    return _maxMissing;
}

/// 平均遗漏
- (NSArray *)averageMissing {
    if (!_averageMissing) {
        NSMutableArray *averageMissingArray = [NSMutableArray arrayWithCapacity:47];
        for (NSArray *ballAndMissing in _ballsAndMissings) {
            NSUInteger total = 0;
            NSUInteger show = 0;
            NSUInteger count = 0;
            for (Ball *ball in ballAndMissing) {
                if (!ball.isBall) {
                    show += 1;
                } else {
                    count += 1;
                    total += show;
                    show = 0;
                }
            }
            [averageMissingArray addObject:[NSString stringWithFormat:@"%tu", total/count]];
        }
        _averageMissing = [averageMissingArray copy];
    }
    return _averageMissing;
}

@end
