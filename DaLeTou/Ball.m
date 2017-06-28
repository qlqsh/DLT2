//
//  Ball.m
//  DaLeTou
//
//  Created by 刘明 on 2017/6/8.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "Ball.h"

@implementation Ball
- (instancetype)initWithValue:(NSString *)value andIsBall:(BOOL)isBall {
    if (self = [super init]) {
        _value = value;
        _isBall = isBall;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", _value, _isBall?@"YES":@"NO"];
}

@end
