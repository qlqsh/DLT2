//
//  BallListView.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/6.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 球列表视图。
@interface BallListView : UIView
#pragma mark - 初始化
/// 初始化球列表视图。
- (instancetype)initIsDLT:(BOOL)isDLT
                 andIsRed:(BOOL)isRed
               andHasNull:(BOOL)hasNull
               andColumns:(NSUInteger)columns;

#pragma mark - 属性
@property (nonatomic, copy) NSArray *balls;

@end
