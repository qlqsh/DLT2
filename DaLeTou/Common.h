//
//  Common.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/4.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Common : NSObject

// 绘制多边形。
+ (UIBezierPath *)addPolygonInRect:(CGRect)rect
                             sides:(NSUInteger)sides
                         lineWidth:(CGFloat)lineWidth
                      cornerRadius:(CGFloat)cornerRadius;

// 根据提供的日期判断星期几。
+ (NSInteger)calendarWeekdayWithYear:(NSInteger)year
                            andMonth:(NSInteger)month
                              andDay:(NSInteger)day;
+ (NSInteger)calendarWeekdayWithString:(NSString *)dateString;

@end
