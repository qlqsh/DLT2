//
//  BallList.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/19.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BallList : NSObject

@property (nonatomic, strong) NSArray *balls;

- (instancetype)initWithBalls:(NSArray *)balls;

- (NSArray *)combining:(NSUInteger)number;

@end
