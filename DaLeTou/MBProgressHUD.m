//
//  MBProgressHUD(Common).m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/10.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "MBProgressHUD.h"

@implementation MBProgressHUD (Extra)

+ (void)warnInView:(UIView *)superView andText:(NSString *)text andDelay:(CGFloat)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:delay];
}

@end
