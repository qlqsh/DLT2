//
//  AllWinning.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/11.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "AllWinning.h"
#import "TFHppleElements.h"
#import "Winning.h"

@implementation AllWinning
#pragma mark - 初始化
/// 分解大块html为小块html片段。
- (instancetype)initWithHtmlContent:(NSString *)htmlContent {
    if (nil == htmlContent) {
        DLog(@"html内容是空")
        return nil;
    }
    
    NSArray *elements;
    NSMutableArray *winnings = [[NSMutableArray alloc] init];
    
    // 获奖信息html片段
    elements = [TFHppleElements search:@"//tbody[@id='tdata']//tr" specificContent:htmlContent];
    for (TFHppleElement *element in elements) {
        Winning *winning = [[Winning alloc] initWithHtmlContent:[element raw]];
        if (nil != winning) {
            [winnings addObject:winning];
        }
    }
    
    // 所有获奖信息
    if (self = [super init]) {
        _winnings = [winnings copy];
    }
    return self;
}

/**
 *  直接把获奖信息列表传递过来。不需要html解析。
 *
 *  @param winnings 获奖信息列表
 *
 *  @return 包含获奖信息列表的对象。
 */
- (instancetype)initWithWinnings:(NSArray *)winnings {
    if (self = [super init]) {
        _winnings = [winnings copy];
    }
    return self;
}

#pragma mark - 覆写方法
- (NSString *)description {
    NSMutableString *description = [[NSMutableString alloc] init];
    for (Winning *winning in _winnings) {
        [description appendFormat:@"%@", [winning description]];
    }
    return [description copy];
}

#pragma mark - 编、解码
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_winnings forKey:@"winnings"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _winnings = [aDecoder decodeObjectForKey:@"winnings"];
    }
    return self;
}

@end
