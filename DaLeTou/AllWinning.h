//
//  AllWinning.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/11.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 一组（多条）获奖（Winning）信息。
@interface AllWinning : NSObject <NSCoding>

#pragma mark - 属性
@property (nonatomic, strong) NSArray *winnings;

#pragma mark - 初始化对象
- (instancetype)initWithHtmlContent:(NSString *)htmlContent;
- (instancetype)initWithWinnings:(NSArray *)winnings;

@end
