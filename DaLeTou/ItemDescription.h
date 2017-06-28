//
//  ItemContent.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/17.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemDescription : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic) NSUInteger number;

- (instancetype)initWithContent:(NSString *)content andNumber:(NSUInteger)number;

- (BOOL)contains:(NSArray *)numbers;
- (NSString *)comparedWithSelected:(NSArray *)selected;

@end
