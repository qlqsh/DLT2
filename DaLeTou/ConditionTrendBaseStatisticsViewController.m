//
//  ConditionTrendBaseStatisticsViewController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/6/13.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "ConditionTrendBaseStatisticsViewController.h"

#import "Winning.h"
#import "DataManager.h"
#import "StatisticsData.h"
#import "NumberCombin.h"
#import "ItemDescription.h"

#import "BaseStatisticsView.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface ConditionTrendBaseStatisticsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *combination;
@property (nonatomic, strong) NSDictionary *combinationResultDictionary;
@end

@implementation ConditionTrendBaseStatisticsViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 更新界面
    self.title = @"基础统计";
    [self.view addSubview:self.tableView];
    
    [self statistics];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 统计
- (void)statistics {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // 后台操作
        // 获取最新的获奖数据
        DataManager *dataManager = [DataManager shared];
        Winning *winning = [dataManager readLatestWinningInFile];
        // 求出“最新的获奖数据”的号码组合
        NSMutableArray *redCombination = [NSMutableArray arrayWithCapacity:6];
        for (int i = 1; i <= 6; i++) {
            NSArray *reds = [winning redCombinationWithNumber:i];
            [redCombination addObjectsFromArray:reds];
        }
        
        // 过滤后的球组合
        NSMutableArray *filterRedCombination = [NSMutableArray arrayWithCapacity:6];
        NSMutableDictionary *redCombinationResultDictionary =
            [NSMutableDictionary dictionaryWithCapacity:6];
        // 统计数据
        StatisticsData *statisticsData = [StatisticsData shared];
        for (NSString *numberCombination in redCombination) {
            NSArray *conditionArray = [numberCombination componentsSeparatedByString:@" "];
            NSArray *resultArray = [statisticsData nextWinningOfConformConditionWithMultipleCondition:@[conditionArray]];
            if (resultArray.count > 2) {
                NumberCombin *numberCombin = [[NumberCombin alloc] initWithString:numberCombination];
                numberCombin.showNumber = resultArray.count;
                [filterRedCombination addObject:numberCombin];
                
                // 统计
                NSMutableArray *reds = [NSMutableArray arrayWithCapacity:resultArray.count];
                for (Winning *winning in resultArray) {
                    [reds addObjectsFromArray:winning.reds];
                }
                NSCountedSet *redsSet = [[NSCountedSet alloc] initWithCapacity:35];
                for (NSString *red in reds) {
                    [redsSet addObject:red];
                }
                NSArray *statisticsArray = [self sortCountedSet:redsSet];
                [redCombinationResultDictionary setObject:statisticsArray
                                                   forKey:numberCombination];
            }
        }
        self.combination = [filterRedCombination copy];
        self.combinationResultDictionary = [redCombinationResultDictionary copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回到主界面
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

/// 排序集
- (NSArray *)sortCountedSet:(NSCountedSet *)countedSet {
    NSMutableArray *sortArray = [NSMutableArray arrayWithCapacity:35];
    [countedSet enumerateObjectsUsingBlock:^(id _Nonnull obj, BOOL *_Nonnull stop) {
        NumberCombin *numberCombin = [[NumberCombin alloc] initWithString:obj];
        numberCombin.showNumber = [countedSet countForObject:obj];
        [sortArray addObject:numberCombin];
    }];
    [sortArray sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        NumberCombin *numberCombin1 = (NumberCombin *) obj1;
        NumberCombin *numberCombin2 = (NumberCombin *) obj2;
        return [numberCombin1 compare:numberCombin2];
    }];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:sortArray.count];
    for (NumberCombin *numberCombin in sortArray) {
        ItemDescription *itemDescription =
        [[ItemDescription alloc] initWithContent:numberCombin.toString
                                       andNumber:numberCombin.showNumber];
        [resultArray addObject:itemDescription];
    }
    return [resultArray copy];
}

#pragma mark - 属性
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.allowsSelection = NO;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 注册Cell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _combination.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    while ([cell.contentView.subviews lastObject] != nil) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    NumberCombin *numberCombin = _combination[indexPath.section];
    NSString *numberCombinString = [numberCombin.numbers componentsJoinedByString:@" "];
    
    NSArray *statisticsArray = [_combinationResultDictionary objectForKey:numberCombinString];
    NSArray *results = (statisticsArray.count <= 6) ? statisticsArray : [statisticsArray subarrayWithRange:NSMakeRange(0, 6)];
    CGFloat space = (kScreenWidth - 40 * 6) / 7;
    NSUInteger i = 0;
    for (ItemDescription *item in results) {
        BaseStatisticsView *baseStatisticsView =
            [[BaseStatisticsView alloc] initWithBall:item.content
                                             andShow:item.number
                                            andTotal:numberCombin.showNumber];
        baseStatisticsView.frame = CGRectMake(space + (40 + space) * i, 5, 40, 70);
        [cell.contentView addSubview:baseStatisticsView];
        i += 1;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NumberCombin *numberCombin = _combination[section];
    // 号码组合标签
    UILabel *combinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    combinLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    combinLabel.textAlignment = NSTextAlignmentCenter;
    combinLabel.font = [UIFont systemFontOfSize:9.0f];
    combinLabel.text = [NSString stringWithFormat:@"%@ [%lu]", [numberCombin.numbers componentsJoinedByString:@" "], (unsigned long)numberCombin.showNumber];
    return combinLabel;
}

@end
