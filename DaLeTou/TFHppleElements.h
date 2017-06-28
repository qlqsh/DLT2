//
//  TFHppleElements.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/22.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TFHpple.h"
#import "TFHppleElement.h"

/// hpple 扩展方法。
@interface TFHppleElements : NSObject

/// 从指定内容搜索。
+ (NSArray *)search:(NSString *)search specificContent:(NSString *)content;

@end
