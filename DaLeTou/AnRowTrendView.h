//
//  AnRowTrendView.h
//  DaLeTou
//
//  Created by 刘明 on 2017/6/8.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnRowTrendView : UIView

- (void)setTrendDataWithBalls:(NSArray *)balls andHasMissing:(BOOL)hasMissing;
- (void)changeBackground;

@end
