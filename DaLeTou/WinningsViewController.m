//
//  WinningsViewController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/11.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "WinningsViewController.h"
#import "WinningDetailViewController.h"
#import "Winning.h"
#import "WinningBaseView.h"
#import "WinningDetailCell.h"
#import "DataManager.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface WinningsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSArray *winnings;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WinningsViewController
#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 更新界面
    self.title = NSLocalizedString(@"WVC_title", nil);
    [self.view addSubview:self.tableView];
    
    [self updateData];
}

/// 更新数据
- (void)updateData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // 显示进度指示器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // 后台获取数据
        DataManager *dataManager = [DataManager shared];
        NSArray *allWinning = [dataManager readAllWinningInFile];
        _winnings = [allWinning subarrayWithRange:NSMakeRange(0, 20)];
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
        
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 注册Cell
        [_tableView registerClass:[WinningDetailCell class]
           forCellReuseIdentifier:@"winningCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _winnings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"winningCell"
                                                            forIndexPath:indexPath];
    // 设置Cell内容
    UILabel *termLabel = [cell.contentView viewWithTag:111];
    UILabel *dateLabel = [cell.contentView viewWithTag:112];
    WinningBaseView *winningBaseView = [cell.contentView viewWithTag:113];
    Winning *winning = (Winning *)_winnings[indexPath.row];
    termLabel.text = [NSString stringWithFormat:@"第%@期", winning.term];
    dateLabel.text = [NSString stringWithFormat:@"%@（%@）", winning.date, winning.week];
    winningBaseView.texts = winning.balls;
    [winningBaseView setSpecies:kIsDLT];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WinningDetailCell.heightOfCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"WinningDetail" sender:nil];
}

#pragma mark - 导航
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"WinningDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // 传递数据
        WinningDetailViewController *winningDetailViewController = [segue destinationViewController];
        winningDetailViewController.winning = _winnings[(NSUInteger) indexPath.row];
    }
}

@end
