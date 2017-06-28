//
//  ItemContent.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/17.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "ItemDescription.h"

/// 仅用于饼图。swift里使用的是构造体。
@implementation ItemDescription

/**
 *  一个需要的饼图数据包装类。Swift可以使用构造体。OC就麻烦了点。
 *  @param content 内容（用于饼图描述）
 *  @param number 数量（用于饼图数据）
 */
- (instancetype)initWithContent:(NSString *)content andNumber:(NSUInteger)number {
    if (self = [super init]) {
        _content = content;
        _number = number;
    }
    return self;
}

/// 是否包含指定数字内容。
- (BOOL)contains:(NSArray *)numbers {
    for (NSString *number in numbers) {
        if (![_content containsString:number]) {
            return false;
        }
    }
    return true;
}

/// 判断数字组合，和选择的数字，然后剩下的一个数字。比如：数字组合是[06 08 10]，选择的是06 10，剩下的就是08
- (NSString *)comparedWithSelected:(NSArray *)selected {
    NSMutableArray *contents = [NSMutableArray arrayWithArray:[_content componentsSeparatedByString:@" "]];
    for (NSString *anSelected in selected) {
        [contents removeObject:anSelected];
    }
    
    return [contents firstObject];
}

/// 描述
- (NSString *)description {
    return [NSString stringWithFormat:@"%@[%lu]", _content, (unsigned long)_number];
}

@end
