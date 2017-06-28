//
//  Winning.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/11.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "Winning.h"
#import "Common.h"
#import "TFHppleElements.h"

@implementation Winning

#pragma mark - 初始化
/// 解析特定的html内容，提取获奖信息。
- (instancetype)initWithHtmlContent:(NSString *)htmlContent {
    if (nil == htmlContent) {
        DLog(@"html内容是空");
        return nil;
    }
    
    NSString *date, *week, *term, *sales, *pool;
    NSMutableDictionary *prizeState = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableArray *reds = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *blues = [NSMutableArray arrayWithCapacity:2];
    // 时间、期号、红球、销售额、奖池、一等奖（注数、奖金）、二等奖（注数、奖金）、三等奖（注数、奖金）
    NSArray *elements = [TFHppleElements search:@"//tr//td" specificContent:htmlContent];
    if (elements.count == 15) {
        term = [elements[0] text];
        [reds addObject:[elements[1] text]];
        [reds addObject:[elements[2] text]];
        [reds addObject:[elements[3] text]];
        [reds addObject:[elements[4] text]];
        [reds addObject:[elements[5] text]];
        [blues addObject:[elements[6] text]];
        [blues addObject:[elements[7] text]];
        pool = [elements[8] text];
        prizeState[@"firstNumber"] = [elements[9] text];
        prizeState[@"firstMoney"] = [elements[10] text];
        prizeState[@"secondNumber"] = [elements[11] text];
        prizeState[@"secondMoney"] = [elements[12] text];
        sales = [elements[13] text];
        date = [elements[14] text];
    } else {
        DLog(@"获取的<td>字段数量不对。");
        return nil;
    }
    // 计算星期几
    NSInteger weekday = [Common calendarWeekdayWithString:date];
    switch (weekday) {
        case 2:
            week = @"周一";
            break;
        case 4:
            week = @"周三";
            break;
        case 7:
        default:
            week = @"周六";
            break;
    }
    
    if (date == nil) {
        DLog(@"解析不到时间");
        return nil;
    }
    if (term == nil) {
        DLog(@"解析不到期号");
        return nil;
    }
    if (reds == nil) {
        DLog(@"解析不到红球");
        return nil;
    }
    if (blues == nil) {
        DLog(@"解析不到蓝球");
        return nil;
    }
    
    // 赋值属性值
    if (self = [super init]) {
        _date = [date copy];
        _week = [week copy];
        _term = [term copy];
        _reds = reds;
        _blues = blues;
        _sales = sales;
        _pool = pool;
        _prizeState = [prizeState copy];
    }
    return self;
}

#pragma mark - 覆写方法
- (BOOL)isEqual:(id)object {
    Winning *winning = (Winning *)object;
    return [_term isEqualToString:winning.term];
}

- (NSString *)description {
    NSString *formatString = @"\n{\n \
        \t开奖日期：%@ \n \
        \t期号：%@ \n \
        \t红球：%@ \n \
        \t蓝球：%@ \n \
        \t销售额：%@ \n \
        \t奖池余额：%@ \n \
        \t一等奖（注数）：%@ \n \
        \t一等奖（奖金）：%@ \n \
        \t二等奖（注数）：%@ \n \
        \t二等奖（奖金）：%@ \n \
    }\n";
    NSString *description = [NSString stringWithFormat:formatString, _date, _term, _reds, _blues,
                             _sales, _pool, _prizeState[@"firstNumber"],
                             _prizeState[@"firstMoney"], _prizeState[@"secondNumber"],
                             _prizeState[@"secondMoney"]];
    return [description copy];
}

#pragma mark - 自定义方法
- (NSArray *)balls {
    NSMutableArray *allBall = [NSMutableArray arrayWithArray:_reds];
    [allBall addObjectsFromArray:_blues];
    return [allBall copy];
}

/// 红球是否包含指定字符串。
- (BOOL)containsReds:(NSString *)reds {
    NSArray *redArray = [reds componentsSeparatedByString:@" "];
    for (NSString *red in redArray) {
        if (![_reds containsObject:red]) {
            return FALSE;
        }
    }
    return TRUE;
}

/// 蓝球是否包含指定字符串。
- (BOOL)containsBlues:(NSString *)blues {
    NSArray *blueArray = [blues componentsSeparatedByString:@" "];
    for (NSString *blue in blueArray) {
        if (![_blues containsObject:blue]) {
            return FALSE;
        }
    }
    return TRUE;
}

#pragma mark - 数字（红球、蓝球）组合
- (NSArray *)redCombinationWithNumber:(NSUInteger)number {
    switch (number) {
        case 1: {
            NSMutableArray *combinations = [NSMutableArray arrayWithCapacity:12];
            for (NSString *red in _reds) {
                [combinations addObject:red];
            }
            return combinations;
        }
        case 2:
            return [self combinationWithNumbers:[self redCombinationWithNumber:1]];
        case 3:
            return [self combinationWithNumbers:[self redCombinationWithNumber:2]];
        case 4:
            return [self combinationWithNumbers:[self redCombinationWithNumber:3]];
        default:
            return @[[_reds componentsJoinedByString:@" "]];
    }
}

- (NSArray *)blueCombinationWithNumber:(NSUInteger)number {
    NSMutableArray *combinations = [NSMutableArray arrayWithCapacity:12];
    if (number == 1) {
        for (NSString *blue in _blues) {
            [combinations addObject:blue];
        }
        return [combinations copy];
    } else {
        return @[[_blues componentsJoinedByString:@" "]];
    }
}

- (NSArray *)combinationWithNumbers:(NSArray *)numbers {
    NSMutableArray *combinations = [NSMutableArray arrayWithCapacity:35];
    for (NSString *number in numbers) {
        NSString *lastRed = [[number componentsSeparatedByString:@" "] lastObject];
        for (NSString *red in _reds) {
            if ([red integerValue] > [lastRed integerValue]) {
                [combinations addObject:[NSString stringWithFormat:@"%@ %@", number, red]];
            }
        }
    }
    return [combinations copy];
}

#pragma mark - 编、解码
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeObject:_week forKey:@"week"];
    [aCoder encodeObject:_term forKey:@"term"];
    [aCoder encodeObject:_reds forKey:@"reds"];
    [aCoder encodeObject:_blues forKey:@"blues"];
    [aCoder encodeObject:_sales forKey:@"sales"];
    [aCoder encodeObject:_pool forKey:@"pool"];
    [aCoder encodeObject:_prizeState forKey:@"prize"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _date = [aDecoder decodeObjectForKey:@"date"];
        _week = [aDecoder decodeObjectForKey:@"week"];
        _term = [aDecoder decodeObjectForKey:@"term"];
        _reds = [aDecoder decodeObjectForKey:@"reds"];
        _blues = [aDecoder decodeObjectForKey:@"blues"];
        _sales = [aDecoder decodeObjectForKey:@"sales"];
        _pool = [aDecoder decodeObjectForKey:@"pool"];
        _prizeState = [aDecoder decodeObjectForKey:@"prize"];
    }
    return self;
}

@end
