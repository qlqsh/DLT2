//
//  NumberCombin.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/4.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "NumberCombin.h"

/**
 *  数字组合。
 */
@implementation NumberCombin

#pragma mark - 属性
- (NSNumber *)sumValue {
    return [_numbers valueForKeyPath:@"@sum.floatValue"];
}

- (BOOL)hasContinuous {
    NSUInteger prevValue = (NSUInteger) [_numbers[0] integerValue];
    for (NSUInteger i = 1; i < _numbers.count; i++) {
        NSUInteger currentValue = (NSUInteger) [_numbers[i] integerValue];
        if (currentValue - prevValue == 1) {
            return YES;
        }
        prevValue = currentValue;
    }
    return NO;
}

- (NSDictionary *)numbersCombiningDictionary {
    NSMutableDictionary *combiningDict = [NSMutableDictionary dictionary];
    for (NSUInteger i = 1; i <= _numbers.count; i++) {
        NSArray *combining = [self combining:i];
        combiningDict[@(i)] = combining;
    }
    
    return [combiningDict copy];
}

#pragma mark - 子数字组合
/// 数字组合里所有数字出现的指定个数的组合
- (NSArray *)combining:(NSUInteger)number {
    if (number == 1) {
        return _numbers;
    }
    if (number >= _numbers.count) {
        return @[[self toString]];
    }
    
    switch (number) {
        case 2:
            return [self combiningWithArray:[self combining:1]];
        case 3:
            return [self combiningWithArray:[self combining:2]];
        case 4:
            return [self combiningWithArray:[self combining:3]];
        case 5:
            return [self combiningWithArray:[self combining:4]];
        default:
            return _numbers;
    }
}

/**
 *  指定数组与当前数字组合中的数字进行组合，组合成新的子数组。
 *
 *  比如：numberArray是@[@"01 02", @"01 03", @"01 04", @"02 03", @"02 04", @"03 04"]，当前数字组合是“01 02 03 04”。
 *  组合后的数组是@[@"01 02 03", @"01 02 04", @"01 03 04", @"02 03 04"]。
 *
 *  @param numberArray 指定数组。
 *
 *  @return 组合后的数组。
 */
- (NSArray *)combiningWithArray:(NSArray *)numberArray {
    NSMutableArray *combiningArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < numberArray.count; i++) {
        for (NSUInteger j = 0; j < _numbers.count; j++) {
            NSArray *childArray = [numberArray[i] componentsSeparatedByString:@" "];
            NSInteger lastObjectValue = [childArray.lastObject integerValue];
            if ([_numbers[j] integerValue] > lastObjectValue) {
                [combiningArray addObject:[NSString stringWithFormat:@"%@ %@",
                                           numberArray[i], _numbers[j]]];
            }
        }
    }
    return [combiningArray copy];
}

#pragma mark - 初始化
- (instancetype)initWithString:(NSString *)numberString {
    NSArray *numberArray = [[numberString componentsSeparatedByString:@" "] copy];
    return [self initWithArray:numberArray];
}

- (instancetype)initWithArray:(NSArray *)numberArray {
    if (self = [super init]) {
        _numbers = [numberArray copy];
        _showNumber = 1;
    }
    return self;
}

#pragma mark - 公开方法
/**
 *  是否包含指定数字或数字组合。
 *
 *  @param numbersString 指定的数字或数字组合。格式："03"、"03 06"。
 *
 *  @return YES：包含，NO：不包含。
 */
- (BOOL)contains:(NSString *)numbersString {
    NSArray *numberArray = [numbersString componentsSeparatedByString:@" "];
    for (NSString *numberString in numberArray) {
        if (![_numbers containsObject:numberString]) {
            return NO;
        }
    }
    return YES;
}

/// 剩余数字组合（不包含的那个数字）。比如："06 08 10"，numbersString是"06 10"，剩余就是"08"
//func differentNumbers(numbersString: String) -> String {
//    var numbersArray = numbers.components(separatedBy: " ")
//    numbersArray.append(contentsOf: numbersString.components(separatedBy: " "))
//    let numbersSet = NSCountedSet(array: numbersArray)
//    
//    for item in numbersSet.enumerated() {
//        if numbersSet.count(for: item.1) == 1 { // 出现次数是1的那个就是
//            return String(describing: item.1)
//        }
//    }
//    return "0"
//}

/// 数字组合中的数字显示为字符串形式
- (NSString *)toString {
    NSMutableString *numbersString = [NSMutableString string];
    for (NSString *numberString in _numbers) {
        [numbersString appendFormat:@"%@ ", numberString];
    }
    return [[numbersString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] copy];
}

/// 比较。主要用来排序（根据_showNumber）。
- (NSComparisonResult)compare:(NumberCombin *)numberCombin {
    if (_showNumber < numberCombin.showNumber) {
        return (NSComparisonResult) NSOrderedDescending;
    } else if (_showNumber < numberCombin.showNumber) {
        return (NSComparisonResult) NSOrderedAscending;
    } else {
        return (NSComparisonResult) NSOrderedSame;
    }
}

#pragma mark - 覆写方法
/// 判断2个数字组合是否相等。
- (BOOL)isEqual:(NumberCombin *)numberCombin {
    if (_numbers.count != numberCombin.numbers.count) {
        return NO;
    }
    return [self contains:numberCombin.toString];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@：['%lu']次", [self toString], (unsigned long) _showNumber];
}

@end
