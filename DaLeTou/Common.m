//
//  Common.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/4.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "Common.h"

@implementation Common

#pragma mark - 计算周几
/**
 *  根据提供的日期判断星期几。
 *
 *  @param year  年
 *  @param month 月
 *  @param day   日
 *
 *  @return 星期几（1-7）
 */
+ (NSInteger)calendarWeekdayWithYear:(NSInteger)year
                            andMonth:(NSInteger)month
                              andDay:(NSInteger)day {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:day];
    [dateComponents setMonth:month];
    [dateComponents setYear:year];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [weekdayComponents weekday];
    
    return weekday;
}

/** 
 *  通过日期字符串判断是星期几。
 */
+ (NSInteger)calendarWeekdayWithString:(NSString *)dateString {
    if (dateString == nil || [dateString isEqualToString:@""]) {
        return 0;
    }
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    if (dateArray.count != 3) {
        return 0;
    }
    
    return [Common calendarWeekdayWithYear:[dateArray[0] integerValue]
                                  andMonth:[dateArray[1] integerValue]
                                    andDay:[dateArray[2] integerValue]];
}


#pragma mark - 绘制图形
/**
 *  绘制多边形。
 *
 *  @param rect 绘制矩形范围
 *  @param sides 边数
 *  @return 多边形贝尔曲线。
 */
+ (UIBezierPath *)addPolygonInRect:(CGRect)rect
                             sides:(NSUInteger)sides
                         lineWidth:(CGFloat)lineWidth
                      cornerRadius:(CGFloat)cornerRadius {
    CGFloat PI = 3.14159265358979323846;
    // 计算每个转弯大小
    CGFloat theta = 2 * PI / sides;
    // 从开始圆角偏移量
    CGFloat offset = cornerRadius * tan(theta / 2);
    // 正方形最小长度。
    CGFloat squareWidth = MIN(rect.size.width, rect.size.height);
    
    // 计算多边形边宽
    CGFloat length = squareWidth - lineWidth;
    if (sides % 4 != 0) {
        length = length * cos(theta / 2) + offset / 2;
    }
    CGFloat sideLength = length * tan(theta / 2);
    
    CGPoint point = CGPointMake(rect.origin.x + rect.size.width / 2 + sideLength / 2 - offset,
                                rect.origin.y + rect.size.height / 2 + length / 2);
    CGFloat angle = PI;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point];
    
    // 绘制多边形的边和圆角
    for (int i = 0; i < sides; i++) {
        point = CGPointMake(point.x + (sideLength - offset * 2) * cos(angle),
                            point.y + (sideLength - offset * 2) * sin(angle));
        [path addLineToPoint:point];
        
        CGPoint center = CGPointMake(point.x + cornerRadius * cos(angle + PI / 2),
                                     point.y + cornerRadius * sin(angle + PI / 2));
        [path addArcWithCenter:center
                        radius:cornerRadius
                    startAngle:angle - PI / 2
                      endAngle:angle + PI / 2
                     clockwise:true];
        angle += theta;
    }
    
    path.lineWidth = lineWidth;
    path.lineJoinStyle = kCGLineJoinRound;
    
    return path;
}

@end
