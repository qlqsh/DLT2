//
//  Ball.h
//  DaLeTou
//
//  Created by 刘明 on 2017/6/8.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ball : NSObject
@property (nonatomic, copy) NSString *value;
@property (nonatomic) BOOL isBall;
- (instancetype)initWithValue:(NSString *)value andIsBall:(BOOL)isBall;
@end
