//
//  WinningRuleViewController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/13.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "WinningRuleViewController.h"
#import "WinningRuleCell.h"
#import "WinningBaseView.h"

@interface WinningRuleViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WinningRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 更新界面
    self.title = @"中奖规则";
    [self.view addSubview:self.tableView];
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
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 注册Cell
        [_tableView registerClass:[WinningRuleCell class] forCellReuseIdentifier:@"winningRuleCell"];
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WinningRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"winningRuleCell"];
    UILabel *awardsLabel = [cell.contentView viewWithTag:141];
    UILabel *moneyLabel = [cell.contentView viewWithTag:142];
    UIView *rulesView = [cell.contentView viewWithTag:143];
    switch (indexPath.row) {
        case 0: {
            awardsLabel.text = @"一等奖";
            moneyLabel.text = @"浮动";
            [rulesView addSubview:[self rulesViewWithRuleArray:@[@[@2, @2, @2, @2, @2, @3, @3]]]];
            break;
        }
        case 1: {
            awardsLabel.text = @"二等奖";
            moneyLabel.text = @"浮动";
            [rulesView addSubview:[self rulesViewWithRuleArray:@[@[@2, @2, @2, @2, @2, @3, @0]]]];
            break;
        }
        case 2: {
            awardsLabel.text = @"三等奖";
            moneyLabel.text = @"浮动";
            [rulesView addSubview:[self rulesViewWithRuleArray:@[@[@2, @2, @2, @2, @2, @0, @0],
                                                                 @[@2, @2, @2, @2, @0, @3, @3]]]];
            break;
        }
        case 3: {
            awardsLabel.text = @"四等奖";
            moneyLabel.text = @"200元";
            [rulesView addSubview:[self rulesViewWithRuleArray:@[@[@2, @2, @2, @2, @0, @3, @0],
                                                                 @[@2, @2, @2, @0, @0, @3, @3]]]];
            break;
        }
        case 4: {
            awardsLabel.text = @"五等奖";
            moneyLabel.text = @"10元";
            [rulesView addSubview:[self rulesViewWithRuleArray:@[@[@2, @2, @2, @2, @0, @0, @0],
                                                                 @[@2, @2, @2, @0, @0, @3, @0],
                                                                 @[@2, @2, @0, @0, @0, @3, @3]]]];
            break;
        }
        case 5: {
            awardsLabel.text = @"六等奖";
            moneyLabel.text = @"5元";
            [rulesView addSubview:[self rulesViewWithRuleArray:@[@[@2, @2, @2, @0, @0, @0, @0],
                                                                 @[@2, @0, @0, @0, @0, @3, @3],
                                                                 @[@2, @2, @0, @0, @0, @3, @0],
                                                                 @[@0, @0, @0, @0, @0, @3, @3]]]];
            break;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 2:
            return [WinningRuleCell heightOfCell]*2;
        case 3:
            return [WinningRuleCell heightOfCell]*2;
        case 4:
            return [WinningRuleCell heightOfCell]*3;
        case 5:
            return [WinningRuleCell heightOfCell]*4;
        case 0:
        case 1:
        default:
            return [WinningRuleCell heightOfCell];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 40.0f);
    headerView.backgroundColor = kRedColor;
    
    UILabel *awardsLevel = [[UILabel alloc] init];
    awardsLevel.frame = CGRectMake(0, 0, kScreenWidth*0.2, 40.0f);
    awardsLevel.text = @"奖等";
    awardsLevel.textColor = [UIColor whiteColor];
    awardsLevel.textAlignment = NSTextAlignmentCenter;
    awardsLevel.font = [UIFont boldSystemFontOfSize:20.0f];
    [headerView addSubview:awardsLevel];
    
    UILabel *awardsMoney = [[UILabel alloc] init];
    awardsMoney.frame = CGRectMake(kScreenWidth*0.2, 0, kScreenWidth*0.2, 40.0f);
    awardsMoney.text = @"奖金";
    awardsMoney.textColor = [UIColor whiteColor];
    awardsMoney.textAlignment = NSTextAlignmentCenter;
    awardsMoney.font = [UIFont boldSystemFontOfSize:20.0f];
    [headerView addSubview:awardsMoney];
    
    UILabel *winningConditions = [[UILabel alloc] init];
    winningConditions.frame = CGRectMake(kScreenWidth*0.4, 0, kScreenWidth*0.6, 40.0f);
    winningConditions.text = @"中奖条件";
    winningConditions.textColor = [UIColor whiteColor];
    winningConditions.textAlignment = NSTextAlignmentCenter;
    winningConditions.font = [UIFont boldSystemFontOfSize:20.0f];
    [headerView addSubview:winningConditions];
    
    return headerView;
}

#pragma mark - 其它方法
/// 规则视图
- (UIView *)rulesViewWithRuleArray:(NSArray *)rules {
    UIView *rulesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*0.6, [WinningRuleCell heightOfCell]*rules.count)];
    NSUInteger i = 0;
    for (NSArray *rule in rules) {
        WinningBaseView *winningBaseView = [[WinningBaseView alloc] initWithPosition:CGPointMake(0, i*[WinningRuleCell heightOfCell])];
        winningBaseView.states = rule;
        winningBaseView.scale = kScreenWidth/kWinningBaseViewDefaultWidth*0.6;
        [rulesView addSubview:winningBaseView];
        i++;
    }
    return rulesView;
}

@end
