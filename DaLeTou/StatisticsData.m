//
//  StatisticsData.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/14.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "StatisticsData.h"
#import "Winning.h"

#import "ItemDescription.h"
#import "BallList.h"
#import "NumberCombin.h"
#import "Common.h"
#import "DataManager.h"

@interface StatisticsData ()
@property (nonatomic, strong) NSArray *winnings;
@property (nonatomic, strong) Winning *winning;
@end

@implementation StatisticsData
#pragma mark - 初始化
+ (instancetype)shared {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        DataManager *dataManager = [DataManager shared];
        _winnings = [dataManager readAllWinningInFileUseReverse];
        _winning = [dataManager readLatestWinningInFile];
    }
    return self;
}

#pragma mark - 统计
/// 红球出现情况
- (NSArray *)redCount {
    NSMutableArray *reds = [NSMutableArray arrayWithCapacity:_winnings.count];
    for (Winning *winning in _winnings) {
        [reds addObjectsFromArray:winning.reds];
    }
    NSCountedSet *redsSet = [[NSCountedSet alloc] initWithCapacity:35];
    for (NSString *red in reds) {
        [redsSet addObject:red];
    }
    return [self sortCountedSet:redsSet];
}

/// 蓝球出现情况
- (NSArray *)blueCount {
    NSMutableArray *blues = [NSMutableArray arrayWithCapacity:_winnings.count];
    for (Winning *winning in _winnings) {
        [blues addObjectsFromArray:winning.blues];
    }
    NSCountedSet *bluesSet = [[NSCountedSet alloc] initWithCapacity:16];
    for (NSString *blue in blues) {
        [bluesSet addObject:blue];
    }
    return [self sortCountedSet:bluesSet];
}

/// 头号出现情况
- (NSArray *)headCount {
    NSCountedSet *headCountedSet = [NSCountedSet setWithCapacity:35];
    for (Winning *winning in _winnings) {
        NSString *head = [winning.reds firstObject];
        [headCountedSet addObject:head];
    }
    NSArray *results = [self sortCountedSet:headCountedSet];
    NSMutableArray *headResults = [NSMutableArray arrayWithArray:[results subarrayWithRange:NSMakeRange(0, 7)]];
    NSArray *tailResults = [results subarrayWithRange:NSMakeRange(7, results.count-7)];
    NSUInteger other = 0;
    for (ItemDescription *item in tailResults) {
        other += item.number;
    }
    ItemDescription *item = [[ItemDescription alloc] initWithContent:@"其它" andNumber:other];
    [headResults addObject:item];
    return headResults;
}

/// 尾号出现情况
- (NSArray *)tailCount {
    NSCountedSet *tailCountedSet = [NSCountedSet setWithCapacity:33];
    for (Winning *winning in _winnings) {
        NSString *tail = [winning.reds lastObject];
        [tailCountedSet addObject:tail];
    }
    NSArray *results = [self sortCountedSet:tailCountedSet];
    NSMutableArray *headResults = [NSMutableArray arrayWithArray:[results subarrayWithRange:NSMakeRange(0, 7)]];
    NSArray *tailResults = [results subarrayWithRange:NSMakeRange(7, results.count-7)];
    NSUInteger other = 0;
    for (ItemDescription *item in tailResults) {
        other += item.number;
    }
    ItemDescription *item = [[ItemDescription alloc] initWithContent:@"其它" andNumber:other];
    [headResults addObject:item];
    return headResults;
}

/// 和值（每差值10为1档）范围
- (NSArray *)valueOfSum {
    NSUInteger range_15_55 = 0;
    NSUInteger range_55_75 = 0;
    NSUInteger range_75_95 = 0;
    NSUInteger range_95_115 = 0;
    NSUInteger range_115_135 = 0;
    NSUInteger range_135_165 = 0;
    for (Winning *winning in _winnings) {
        NSArray *reds = winning.reds;
        NSUInteger total = 0;
        for (NSString *red in reds) {
            total += [red integerValue];
        }
        if (total >= 135) {
            range_135_165 += 1;
        } else if (total >= 115) {
            range_115_135 += 1;
        } else if (total >= 95) {
            range_95_115 += 1;
        } else if (total >= 75) {
            range_75_95 += 1;
        } else if (total >= 55) {
            range_55_75 += 1;
        } else {
            range_15_55 += 1;
        }
    }
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:5];
    [results addObject:[[ItemDescription alloc] initWithContent:@"和值（115~135）"
                                                      andNumber:range_115_135]];
    [results addObject:[[ItemDescription alloc] initWithContent:@"和值（95~115）"
                                                      andNumber:range_95_115]];
    [results addObject:[[ItemDescription alloc] initWithContent:@"和值（75~95）"
                                                      andNumber:range_75_95]];
    [results addObject:[[ItemDescription alloc] initWithContent:@"和值（55~75）"
                                                      andNumber:range_55_75]];
    [results addObject:[[ItemDescription alloc] initWithContent:@"其它"
                                                      andNumber:range_15_55+range_135_165]];
    return results;
}

/// 连号情况
- (NSArray *)continuousCount {
    NSUInteger continuous_0 = 0; // 没有连号
    NSUInteger continuous_1 = 0; // 1个连号
    NSUInteger continuous_2 = 0;
    NSUInteger continuous_3 = 0;
    NSUInteger continuous_4 = 0; // 最多4连号，5个球
    for (Winning *winning in _winnings) {
        NSArray *reds = winning.reds;
        NSInteger previous = -1;
        NSUInteger continuous = 0;
        for (NSString *red in reds) {
            if ([red integerValue] - previous == 1) { // 连号
                continuous += 1;
            }
            previous = [red integerValue];
        }
        switch (continuous) {
            case 0:
                continuous_0++;
                break;
            case 1:
                continuous_1++;
                break;
            case 2:
                continuous_2++;
                break;
            case 3:
                continuous_3++;
                break;
            case 4:
                continuous_4++;
                break;
            default:
                break;
        }
    }
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:4];
    [results addObject:[[ItemDescription alloc] initWithContent:@"没有连号"
                                                      andNumber:continuous_0]];
    [results addObject:[[ItemDescription alloc] initWithContent:@"有1个连号"
                                                      andNumber:continuous_1]];
    [results addObject:[[ItemDescription alloc] initWithContent:@"有2个连号"
                                                      andNumber:continuous_2]];
    [results addObject:[[ItemDescription alloc] initWithContent:@"其它"
                                                      andNumber:continuous_3 + continuous_4]];
    return results;
}

/// 排序集
- (NSArray *)sortCountedSet:(NSCountedSet *)countedSet {
    NSMutableArray *sortArray = [NSMutableArray arrayWithCapacity:35];
    [countedSet enumerateObjectsUsingBlock:^(id _Nonnull obj, BOOL *_Nonnull stop) {
        NumberCombin *numberCombin = [[NumberCombin alloc] initWithString:obj];
        numberCombin.showNumber = [countedSet countForObject:obj];
        [sortArray addObject:numberCombin];
    }];
    [sortArray sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        NumberCombin *numberCombin1 = (NumberCombin *) obj1;
        NumberCombin *numberCombin2 = (NumberCombin *) obj2;
        return [numberCombin1 compare:numberCombin2];
    }];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:sortArray.count];
    for (NumberCombin *numberCombin in sortArray) {
        ItemDescription *itemDescription =
            [[ItemDescription alloc] initWithContent:numberCombin.toString
                                           andNumber:numberCombin.showNumber];
        [resultArray addObject:itemDescription];
    }
    return [resultArray copy];
}


#pragma mark - 历史同期
/**
 *  历史同期。逆序(新->旧)。默认10期。目前只提供年的。
 *
 *  @return 根据年的不同找出历史出号。
 *
 *  高级：可以通过设置，选择同期(年、月、周、指定期数(10、20等))。月、周有难度，估计会比较难做。
 */
- (NSArray *)historySame {
    // 这里需要判断是+1，还是新的1年，重新回到001。
    NSUInteger termNumber = (NSUInteger) [[_winning.term substringFromIndex:2] integerValue];
    if (termNumber >= 152) { // 最后的几期
        NSArray *dateArray = [_winning.date componentsSeparatedByString:@"-"];
        NSUInteger day = (NSUInteger) [[dateArray lastObject] integerValue];
        if (day + 2 > 31) { // 新的一年
            termNumber = 1;
        } else {
            if ((day + 3 > 31) && [Common calendarWeekdayWithString:_winning.date] == 5) {
                termNumber = 1;
            } else {
                termNumber = termNumber + 1;
            }
        }
    } else {
        termNumber = termNumber + 1;
    }
    
    NSString *termString;
    if (termNumber >= 100) {
        termString = [NSString stringWithFormat:@"%lu", (unsigned long) termNumber];
    } else if (termNumber >= 10) {
        termString = [NSString stringWithFormat:@"0%lu", (unsigned long) termNumber];
    } else {
        termString = [NSString stringWithFormat:@"00%lu", (unsigned long) termNumber];
    }
    
    // 历史同期
    NSMutableArray *historySame = [NSMutableArray array];
    for (Winning *winning in _winnings) {
        if ([[winning.term substringFromIndex:2] isEqualToString:termString]) {
            [historySame addObject:winning];
        }
    }
    
    return historySame;
}

#pragma mark - 历史相似走势
/// 包含（多重）指定数字的下一期获奖数据。可以说是从以往的走势图形中寻找与当前走势类似的图形，这个是立体的。
/** 
 *  比如：条件是["06", "06 08"]，就是需要第一个获奖数据里面包含"06"、下一期（第二个）获奖数据里面同时包含"06 08"，符合这2个条件的下下一期（第三个）获奖数据。
 */
- (NSArray *)nextWinningOfConformConditionWithMultipleCondition:(NSArray *)multipleCondition {
    // 1、根据坐标建立一个获奖字典、一个坐标数组
    NSMutableDictionary *winningsDictionary = [NSMutableDictionary dictionaryWithCapacity:1000];
    NSMutableArray *locationArray = [NSMutableArray arrayWithCapacity:1000];
    NSNumber *location = @0;
    for (Winning *winning in _winnings) {
        winningsDictionary[location] = winning;
        [locationArray addObject:location];
        location = @(location.integerValue + 1);
    }
    
    // 2、遍历条件，寻找符合条件的获奖号码。
    for (NSArray *condition in multipleCondition) {
        NSString *conditionString = [condition componentsJoinedByString:@" "];
        locationArray = [[self winningLocationWithContains:conditionString
                                          andLocationArray:locationArray
                                      andWinningDictionary:winningsDictionary] copy];
    }
    
    // 3、遍历符合条件的获奖数据的下标，找到获奖数据，存入数组。
    NSMutableArray *winningsOfConformCondition = [NSMutableArray arrayWithCapacity:10];
    for (NSNumber *location in locationArray) {
        Winning *winning = winningsDictionary[location];
        [winningsOfConformCondition addObject:winning];
    }
    
    return [winningsOfConformCondition copy];
}

/**
 *  过滤。找到包含指定字符串的获奖数据。然后把坐标集合到一个数组里。
 *  @param containString 包含字符串
 *  @param locations 符合条件的坐标
 *  @param winningsDictionary 所有获奖数据字典{坐标：获奖数据}
 *  @return 符合条件的获奖数据坐标数组。
 */
- (NSArray *)winningLocationWithContains:(NSString *)containString
                        andLocationArray:(NSArray *)locations
                    andWinningDictionary:(NSDictionary *)winningsDictionary {
    NSUInteger allCount = winningsDictionary.count;
    
    // 条件为空，说明是无条件隔1期。
    BOOL unconditional = FALSE;
    if ([containString isEqualToString:@""]) {
        unconditional = TRUE;
    }
    
    NSMutableArray *locationArray = [NSMutableArray arrayWithCapacity:1];
    // 遍历坐标。根据坐标找到获奖数据。
    for (NSNumber *location in locations) {
        Winning *winning = winningsDictionary[location];
        if (winning != nil) {
            if (unconditional || [winning containsReds:containString]) {
                if (allCount > (location.integerValue + 1)) {
                    [locationArray addObject:@(location.integerValue + 1)];
                }
            }
        }
    }
    
    return locationArray;
}

#pragma mark - 奖金计算
/// 计算所有获奖情况
- (NSString *)calculateMoneyWithCurrentWinning:(Winning *)currentWinning
                                   andMyNumber:(NSArray *)myNumbers {
    NSMutableDictionary *awardDict = [NSMutableDictionary dictionaryWithCapacity:6];
    [awardDict setValue:@0 forKey:@"first"];
    [awardDict setValue:@0 forKey:@"second"];
    [awardDict setValue:@0 forKey:@"third"];
    [awardDict setValue:@0 forKey:@"fourth"];
    [awardDict setValue:@0 forKey:@"fifth"];
    [awardDict setValue:@0 forKey:@"sixth"];
    NSArray *winnings = [self numbersWithMyNumbers:myNumbers];
    for (NSDictionary *winning in winnings) {
        NSUInteger awardValue = [self awardWithWinningNumber:currentWinning andMyNumber:winning];
        switch (awardValue) {
            case 1: {
                NSUInteger newValue = [awardDict[@"first"] integerValue] + 1;
                awardDict[@"first"] = @(newValue);
                break;
            }
            case 2: {
                NSUInteger newValue = [awardDict[@"second"] integerValue] + 1;
                awardDict[@"second"] = @(newValue);
                break;
            }
            case 3: {
                NSUInteger newValue = [awardDict[@"third"] integerValue] + 1;
                awardDict[@"third"] = @(newValue);
                break;
            }
            case 4: {
                NSUInteger newValue = [awardDict[@"fourth"] integerValue] + 1;
                awardDict[@"fourth"] = @(newValue);
                break;
            }
            case 5: {
                NSUInteger newValue = [awardDict[@"fifth"] integerValue] + 1;
                awardDict[@"fifth"] = @(newValue);
                break;
            }
            case 6: {
                NSUInteger newValue = [awardDict[@"sixth"] integerValue] + 1;
                awardDict[@"sixth"] = @(newValue);
                break;
            }
            case 0:
            default:
                break;
        }
    }
    NSMutableString *descriptionString = [NSMutableString string];
    if ([awardDict[@"first"] integerValue] > 0) {
        [descriptionString appendFormat:@"一等奖%@注!\n", awardDict[@"first"]];
    }
    if ([awardDict[@"second"] integerValue] > 0) {
        [descriptionString appendFormat:@"二等奖%@注!\n", awardDict[@"second"]];
    }
    if ([awardDict[@"third"] integerValue] > 0) {
        [descriptionString appendFormat:@"三等奖%@注!\n", awardDict[@"third"]];
    }
    if ([awardDict[@"fourth"] integerValue] > 0) {
        [descriptionString appendFormat:@"四等奖%@注!\n", awardDict[@"fourth"]];
    }
    if ([awardDict[@"fifth"] integerValue] > 0) {
        [descriptionString appendFormat:@"五等奖%@注!\n", awardDict[@"fifth"]];
    }
    if ([awardDict[@"sixth"] integerValue] > 0) {
        [descriptionString appendFormat:@"六等奖%@注!", awardDict[@"sixth"]];
    }
    if ([descriptionString isEqualToString:@""]) {
        return @"很遗憾您没有中奖，再接再厉吧！";
    } else {
        return [NSString stringWithFormat:@"恭喜中奖！！！\n%@", descriptionString];
    }
    return descriptionString;
}

/// 把我的号码（可能是复式）分解成（多个）单注号码
- (NSArray *)numbersWithMyNumbers:(NSArray *)myNumbers {
    NSMutableArray *winnings = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *number in myNumbers) {
        BallList *redList = [[BallList alloc] initWithBalls:number[@"reds"]];
        NSArray *redArray = [redList combining:5];
        BallList *blueList = [[BallList alloc] initWithBalls:number[@"blues"]];
        NSArray *blueArray = [blueList combining:2];
        for (NSArray *reds in redArray) {
            for (NSArray *blues in blueArray) {
                NSMutableDictionary *numberDict = [NSMutableDictionary dictionaryWithCapacity:2];
                numberDict[@"reds"] = reds;
                numberDict[@"blues"] = blues;
                [winnings addObject:numberDict];
            }
        }
    }
    return winnings;
}

/// 判断一注号码（5+2）是获得几等奖
- (NSUInteger)awardWithWinningNumber:(Winning *)winning andMyNumber:(NSDictionary *)myNumber {
    NSUInteger hasRed = 0;  // 中的红球数量
    NSArray *reds = [myNumber[@"reds"] componentsSeparatedByString:@" "];
    for (NSString *red in reds) {
        if ([winning.reds containsObject:red]) {
            hasRed += 1;
        }
    }
    NSArray *blues = [myNumber[@"blues"] componentsSeparatedByString:@" "];
    NSUInteger hasBlue = 0; // 中的蓝球数量
    for (NSString *blue in blues) {
        if ([winning.blues containsObject:blue]) {
            hasBlue += 1;
        }
    }
    // 1等奖
    if (hasRed == 5 && hasBlue == 2) {
        return 1;
    }
    
    // 2等奖
    if (hasRed == 5 && hasBlue == 1) {
        return 2;
    }
    
    // 3等奖
    if (hasRed == 5 && hasBlue == 0) {
        return 3;
    }
    if (hasRed == 4 && hasBlue == 2) {
        return 3;
    }
    
    // 4等奖
    if (hasRed == 4 && hasBlue == 1) {
        return 4;
    }
    if (hasRed == 3 && hasBlue == 2) {
        return 4;
    }
    
    // 5等奖
    if (hasRed == 4 && hasBlue == 0) {
        return 5;
    }
    if (hasRed == 3 && hasBlue == 1) {
        return 5;
    }
    if (hasRed == 2 && hasBlue == 2) {
        return 5;
    }
    
    // 6等奖
    if (hasRed == 3 && hasBlue == 0) {
        return 6;
    }
    if (hasRed == 1 && hasBlue == 2) {
        return 6;
    }
    if (hasRed == 2 && hasBlue == 1) {
        return 6;
    }
    if (hasRed == 0 && hasBlue == 2) {
        return 6;
    }
    
    return 0; // 没有中奖
}

#pragma mark - 数字组合
- (NSDictionary *)combinations {
    NSMutableDictionary *combinationDict = [NSMutableDictionary dictionaryWithCapacity:7];
    // 5个红球
    for (int i = 1; i <= 5; i++) {
        NSMutableArray *redCombinations = [NSMutableArray arrayWithCapacity:1];
        for (Winning *winning in _winnings) {
            [redCombinations addObjectsFromArray:[winning redCombinationWithNumber:i]];
        }
        NSCountedSet *countedSet = [NSCountedSet setWithArray:[redCombinations copy]];
        NSArray *result = [self sortCountedSet:countedSet];
        [combinationDict setObject:result forKey:@(i)];
    }
    // 2个蓝球
    for (int i = 1; i <= 2; i++) {
        NSMutableArray *blueCombinations = [NSMutableArray arrayWithCapacity:1];
        for (Winning *winning in _winnings) {
            [blueCombinations addObjectsFromArray:[winning blueCombinationWithNumber:i]];
        }
        NSCountedSet *countedSet = [NSCountedSet setWithArray:[blueCombinations copy]];
        NSArray *result = [self sortCountedSet:countedSet];
        [combinationDict setObject:result forKey:@(i+5)];
    }
    return [combinationDict copy];
}

@end
