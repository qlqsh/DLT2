//
//  DataManager.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/11.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "DataManager.h"
#import "Winning.h"
#import "AllWinning.h"
#import <AFNetworking/AFNetworking.h>

@implementation DataManager
+ (instancetype)shared {
    return [[self alloc] init];
}

#pragma mark - 从本地文档获取数据
/// 从本地文档获取所有获奖信息数据。
- (NSArray *)readAllWinningInFile {
    if (![self documentExists]) {
        return @[];
    }
    NSMutableData *loadData = [NSMutableData dataWithContentsOfFile:kWinningsLocalDocumentPath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:loadData];
    AllWinning *allWinning = [unarchiver decodeObjectForKey:@"allWinning"];
    return allWinning.winnings;
}

/// 逆序读取所有数据。主要用在走势图。
- (NSArray *)readAllWinningInFileUseReverse {
    return [[[self readAllWinningInFile] reverseObjectEnumerator] allObjects];
}

/// 最新一条获奖信息。
- (Winning *)readLatestWinningInFile {
    NSArray *winningList = [self readAllWinningInFile];
    return [winningList firstObject];
}

#pragma mark - 网络获取最新数据
/// 更新网络数据
- (void)updateWinningUseNetworking {
    if (![self documentExists]) {
        [self resetAllWinningsUseNetworking];
        DLog(@"文档不存在，重设所有获奖信息。");
    } else {
        [self getLatestWinningsUseNetworking];
        DLog(@"文档存在，添加最新获奖信息。");
    }
}

/// 获取最新获奖数据。
- (void)getLatestWinningsUseNetworking {
    Winning *winning = [self readLatestWinningInFile];
    [self getWinningsUseNetworkingWithStart:winning.term];
}

/// 重设获取所有获奖信息。
- (void)resetAllWinningsUseNetworking {
    // 获取所有数据。
    [self getWinningsUseNetworkingWithStart:@"07001"];
}

/**
 *  单例模式。每次都调用[AFHTTPSessionManager manager]，会导致内存泄漏。使用单例模式就可以解决。
 */
+ (AFHTTPSessionManager *)sharedHTTPSessionManager {
    static AFHTTPSessionManager *manager = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [AFHTTPSessionManager manager];
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 15.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    });
    
    return manager;
}

/**
 *  通过网络获取数据。
 *
 *  @param start 开始期号（样式：07001）
 */
- (void)getWinningsUseNetworkingWithStart:(NSString *)start {
    // AFNetworking设置
    AFHTTPSessionManager *sessionManager = [DataManager sharedHTTPSessionManager];
    // 申明请求的数据是http类型
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 申明返回的结果是http类型
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 增加支持html
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", nil];
    
    NSString *urlPath = [self completeUrlUseStart:start];
    [sessionManager GET:urlPath
             parameters:nil
               progress:nil
                success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                    NSString *htmlContent = [[NSString alloc] initWithData:responseObject
                                                                  encoding:NSUTF8StringEncoding];
                    // 解析html
                    AllWinning *allWinning = [[AllWinning alloc] initWithHtmlContent:htmlContent];
                    if (allWinning.winnings.count > 1) {
                        NSArray *newWinnings = allWinning.winnings;
                        NSMutableArray *winnings = [[NSMutableArray alloc] initWithCapacity:newWinnings.count - 1];
                        [winnings addObjectsFromArray:[newWinnings subarrayWithRange:NSMakeRange(0, newWinnings.count - 1)]];
                        NSArray *oldWinnings = [self readAllWinningInFile];
                        [winnings addObjectsFromArray:oldWinnings];
                        [self removeFile];
                    
                        AllWinning *allWinning2 = [[AllWinning alloc] initWithWinnings:winnings];
                        NSMutableData *saveData = [NSMutableData data];
                        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:saveData];
                        [archiver encodeObject:allWinning2 forKey:@"allWinning"];
                        [archiver finishEncoding];
                        if ([saveData writeToFile:kWinningsLocalDocumentPath atomically:YES]) {
                            DLog(@"存档成功。%@", kWinningsLocalDocumentPath);
                        }
                    }
                }
                failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                    DLog(@"内容获取失败：%@", error);
                }];
}

#pragma mark - 简单方法
/// 计算完整URL（添加范围参数）。
- (NSString *)completeUrlUseStart:(NSString *)start {
    // 等于这里成了检测数据完整性的地方了。repairBadDocument用不上了。
    if (start == nil || [start isEqualToString:@""]) {
        start = @"07001";
    }
    NSString *startString = [NSString stringWithFormat:@"start=%@", start];
    NSUInteger year = [self calculateYear];
    NSString *endString = [NSString stringWithFormat:@"&end=%lu001", (unsigned long)year];
    NSString *completeURL = [NSString stringWithFormat:@"%@%@%@", kBaseURL, startString, endString];
    DLog(@"完整URL: %@", completeURL);
    return [completeURL copy];
}

/// 计算明年，用于网络提取获奖数据确定范围。
- (NSUInteger)calculateYear {
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:currentDate];
    NSUInteger nextYear = (NSUInteger) ([components year] + 1);
    
    return nextYear%2000;
}

#pragma mark - 本地文档处理
/// 删除本地文件。
- (void)removeFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:kWinningsLocalDocumentPath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:kWinningsLocalDocumentPath error:&error]) {
            DLog(@"文件删除成功");
        } else {
            DLog(@"%@", error);
        }
    }
}

/// 判断文档（dlt_winnings.plist）是否存在。
- (BOOL)documentExists {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:kWinningsLocalDocumentPath];
}

/// 修复损坏文档。
//- (void)repairBadDocument {
//    BOOL isBadDocument = NO; // 文档出现损坏
//    Winning *winning = [self readLatestWinningInFile];
//    if (winning == nil) {
//        isBadDocument = YES;
//    }
//    if (winning.term == nil || [winning.term isEqualToString:@""]) {
//        isBadDocument = YES;
//    }
//    if (winning.date == nil || [winning.date isEqualToString:@""]) {
//        isBadDocument = YES;
//    }
//    if (winning.reds == nil || winning.blues == nil) {
//        isBadDocument = YES;
//    }
//    
//    if (isBadDocument) {
//        DLog(@"文档损坏，修复");
//        [self removeFile];
//        [self updateWinningUseNetworking];
//    }
//}

@end
