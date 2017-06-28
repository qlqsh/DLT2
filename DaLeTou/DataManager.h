//
//  DataManager.h
//  DaLeTou
//
//  Created by 刘明 on 2017/5/11.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Winning;

// 大乐透获奖信息数据管理。数据从网络获取，存储在本地文档。位置：/Library/Caches/dlt_winnings.plist
@interface DataManager : NSObject

#pragma mark - 初始化
+ (instancetype)shared;

#pragma mark - 从文档获取数据
- (Winning *)readLatestWinningInFile;        // 本地文档最新获奖数据
- (NSArray *)readAllWinningInFile;           // 本地文档所有获奖数据，主要方法，其它方法都要调用它。
- (NSArray *)readAllWinningInFileUseReverse; // 本地文档所有获奖数据（逆序列表，走势图用）

#pragma mark - 网络更新数据
- (void)updateWinningUseNetworking;
- (void)resetAllWinningsUseNetworking;

@end
