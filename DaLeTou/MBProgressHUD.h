//
//  MBProgressHUD(Common).h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/10.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Extra)

/// 警告消息。
+ (void)warnInView:(UIView *)superView andText:(NSString *)text andDelay:(CGFloat)delay;

@end
