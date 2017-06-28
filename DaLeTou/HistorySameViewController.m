//
//  HistorySameViewController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/14.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "HistorySameViewController.h"
#import "WinningSimpleCell.h"
#import "WinningBaseView.h"
#import "Winning.h"
#import "StatisticsData.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface HistorySameViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *history;
@end

@implementation HistorySameViewController
#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 更新界面
    self.title = @"历史同期";
    [self.view addSubview:self.tableView];
    
    [self updateData];
}

/// 更新数据
- (void)updateData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // 显示进度指示器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // 后台操作
        StatisticsData *statisticsData = [StatisticsData shared];
        _history = [statisticsData historySame];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回到主界面
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES]; // 隐藏进度指示器
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView 初始化
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.allowsSelection = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 注册Cell
        [_tableView registerClass:[WinningSimpleCell class] forCellReuseIdentifier:@"simpleCell"];
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WinningSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleCell"];
    
    Winning *winning = _history[indexPath.row];
    UILabel *termLabel = [cell.contentView viewWithTag:101];
    WinningBaseView *winningBaseView = [cell.contentView viewWithTag:102];
    
    termLabel.text = winning.term;
    winningBaseView.texts = winning.balls;
    [winningBaseView setSpecies:kIsDLT];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WinningSimpleCell heightOfCell];
}

@end
