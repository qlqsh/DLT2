//
//  MyNumberCell.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/18.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "MyNumberCell.h"
#import "BallView.h"

@implementation MyNumberCell
#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setReds:(NSArray *)reds andBlues:(NSArray *)blues {
    NSUInteger ballCount = kScreenWidth/40;
    CGFloat space = (kScreenWidth - ballCount*40.0f)/2;
    
    NSUInteger i = 0;
    NSUInteger j = 0;
    for (NSString *red in reds) {
        if (i % ballCount == 0) {
            j += 1;
        }
        CGFloat positionX = space + i%ballCount*40.0f;
        CGFloat positionY = 5 + (j-1)*40.0f;
        CGPoint point = CGPointMake(positionX, positionY);
        BallView *ballView = [[BallView alloc] initWithPosition:point];
        ballView.state = 2;
        ballView.textLabel.text = red;
        [self.contentView addSubview:ballView];
        i += 1;
    }
    for (NSString *blue in blues) {
        if (i % ballCount == 0) {
            j += 1;
        }
        CGFloat positionX = space + i%ballCount*40.0f;
        CGFloat positionY = 5 + (j-1)*40.0f;
        CGPoint point = CGPointMake(positionX, positionY);
        BallView *ballView = [[BallView alloc] initWithPosition:point];
        ballView.state = 3;
        ballView.textLabel.text = blue;
        [self.contentView addSubview:ballView];
        i += 1;
    }
}

+ (CGFloat)heightOfCellWithCount:(NSUInteger)count {
    NSUInteger ballCount = kScreenWidth/40;
    if (count%ballCount == 0) {
        return 40.0f + (count/ballCount-1)*40.0f + 10.0f;
    } else {
        return 40.0f + (count/ballCount)*40.0f + 10.0f;
    }
}

@end
