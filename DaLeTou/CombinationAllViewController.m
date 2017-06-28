//
//  CombinationViewController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/24.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "CombinationAllViewController.h"
#import "CombinationViewController.h"
#import "StatisticsData.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface CombinationAllViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *combinationDict;
@end

@implementation CombinationAllViewController
#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 更新界面
    self.title = @"获奖号码组合情况";
    [self.view addSubview:self.tableView];
    
    [self updateData];
}

/// 更新数据
- (void)updateData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // 显示进度指示器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // 后台获取数据
        StatisticsData *statisticsData = [StatisticsData shared];
        _combinationDict = [statisticsData combinations];
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
        
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorInset = UIEdgeInsetsZero;
        
        // 注册Cell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 40)];
    
    UIColor *symbolColor = kRedColor;
    NSString *text = [NSString stringWithFormat:@"%td个红球组合", indexPath.row + 1];
    if (indexPath.row > 4) {
        symbolColor = kBlueColor;
        text = [NSString stringWithFormat:@"%td个蓝球组合", indexPath.row - 5 + 1];
    }
    titleLabel.text = text;
    titleLabel.textColor = symbolColor;
    
    [cell.contentView addSubview:[self headSymbolWithColor:symbolColor]];
    [cell.contentView addSubview:titleLabel];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UIView *)headSymbolWithColor:(UIColor *)color {
    UIView *symbolView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    
    // 一个圆圈视图（外）
    UIView *outerCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    outerCircle.layer.borderWidth = 0.5f;
    outerCircle.layer.borderColor = color.CGColor;
    outerCircle.layer.cornerRadius = outerCircle.frame.size.height/2;
    [symbolView addSubview:outerCircle];
    
    // 一个实心圆视图（内）
    UIView *insideCircle = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 16, 16)];
    insideCircle.backgroundColor = color;
    insideCircle.layer.cornerRadius = insideCircle.frame.size.height/2;
    [symbolView addSubview:insideCircle];
    
    return symbolView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"Combination" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

#pragma mark - 导航
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Combination"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // 传递数据
        CombinationViewController *combination = [segue destinationViewController];
        combination.number = indexPath.row+1;
        combination.isRed = (indexPath.row > 4) ? FALSE : TRUE;
        combination.combinations = [_combinationDict objectForKey:@(indexPath.row+1)];
    }
}
@end
