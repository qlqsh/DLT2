//
//  WinningDetailViewController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/13.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "WinningDetailViewController.h"
#import "WinningRuleViewController.h"
#import "Winning.h"
#import "WinningBaseView.h"
#import "WinningDetailCell.h"
#import "WinningDetailAdditionalCell1.h"
#import "WinningDetailAdditionalCell2.h"

#import "DataManager.h"

@interface WinningDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WinningDetailViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 更新界面
    self.title = @"本期开奖";
    [self.view addSubview:self.tableView];
    
    // 获奖规则
    UIBarButtonItem *ruleButton =
        [[UIBarButtonItem alloc] initWithTitle:@"获奖规则"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(pushRuleViewController)];
    self.navigationItem.rightBarButtonItem = ruleButton;
}

- (void)pushRuleViewController {
    WinningRuleViewController *winningRuleViewController =
        [[WinningRuleViewController alloc] init];
    [self.navigationController pushViewController:winningRuleViewController animated:YES];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 注册Cell
        [_tableView registerClass:[WinningDetailCell class] forCellReuseIdentifier:@"detailCell"];
        [_tableView registerClass:[WinningDetailAdditionalCell1 class]
           forCellReuseIdentifier:@"detailAdditionalCell1"];
        [_tableView registerClass:[WinningDetailAdditionalCell2 class] forCellReuseIdentifier:@"detailAdditionalCell2"];
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 3;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
            // 设置Cell内容
            UILabel *termLabel = [cell.contentView viewWithTag:111];
            UILabel *dateLabel = [cell.contentView viewWithTag:112];
            WinningBaseView *winningBaseView = [cell.contentView viewWithTag:113];
            termLabel.text = [NSString stringWithFormat:@"第%@期", _winning.term];
            dateLabel.text = [NSString stringWithFormat:@"%@（%@）",
                              _winning.date, _winning.week];
            winningBaseView.texts = _winning.balls;
            [winningBaseView setSpecies:kIsDLT];
            break;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"detailAdditionalCell1"];
            // 设置Cell内容
            UILabel *poolMoneyLabel = [cell.contentView viewWithTag:121];
            UILabel *salesMoneyLabel = [cell.contentView viewWithTag:122];
            poolMoneyLabel.text = [NSString stringWithFormat:@"%@元", _winning.pool];
            salesMoneyLabel.text = [NSString stringWithFormat:@"%@元", _winning.sales];
            break;
        }
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"detailAdditionalCell2"];
            UILabel *awardsLabel = [cell.contentView viewWithTag:131];
            UILabel *winningAmountLabel = [cell.contentView viewWithTag:132];
            UILabel *winningMoneyLabel = [cell.contentView viewWithTag:133];
            switch (indexPath.row) {
                case 0: {
                    awardsLabel.text = @"奖项";
                    winningAmountLabel.text = @"中奖人数";
                    winningMoneyLabel.text = @"中奖金额";
                    break;
                }
                case 1: {
                    awardsLabel.text = @"一等奖";
                    winningAmountLabel.text = _winning.prizeState[@"firstNumber"];
                    winningMoneyLabel.text = [NSString stringWithFormat:@"%@元", _winning.prizeState[@"firstMoney"]];
                    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
                    break;
                }
                case 2:
                    awardsLabel.text = @"二等奖";
                    winningAmountLabel.text = _winning.prizeState[@"secondNumber"];
                    winningMoneyLabel.text = [NSString stringWithFormat:@"%@元", _winning.prizeState[@"secondMoney"]];
                    break;
                default:
                    break;
            }
            break;
        }
        default: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
            break;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [WinningDetailCell heightOfCell];
        case 1:
            return [WinningDetailAdditionalCell1 heightOfCell];
        case 2:
            return [WinningDetailAdditionalCell2 heightOfCell];
        default:
            return 10.0f;
    }
}

@end
