//
//  BallButton.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/5.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallButton : UIButton
#pragma mark - 初始化
- (instancetype)initWithPosition:(CGPoint)position;

#pragma mark - 属性
@property (nonatomic) BOOL isRed; // 球按钮（YES：红球按钮、NO:蓝球按钮）
@property (nonatomic, copy) NSString *text; // 按钮文字

@end
