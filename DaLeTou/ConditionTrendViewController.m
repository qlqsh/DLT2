//
//  ConditionTrendViewController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/17.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "ConditionTrendViewController.h"

#import "ConditionTrendBaseStatisticsViewController.h"

#import "BallButton.h"
#import "BallListView.h"
#import "WinningBaseView.h"
#import "ButtonCell.h"
#import "WinningSimpleCell.h"
#import "ConditionCell.h"

#import "Winning.h"
#import "DataManager.h"
#import "StatisticsData.h"

#import "MBProgressHUD.h"

@interface ConditionTrendViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *conditionArray;   // 条件数组
@property (nonatomic, strong) NSArray *resultArray;             // 结果数组
@property (nonatomic, strong) NSArray *recentTwoTermWinnings;   // 最近2期获奖数据

@end

@implementation ConditionTrendViewController
#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 更新界面
    self.title = @"相似走势";
    [self.view addSubview:self.tableView];
    
    // 获奖规则
    UIBarButtonItem *ruleButton =
        [[UIBarButtonItem alloc] initWithTitle:@"基础统计"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(pushBaseStatisticsViewController)];
    self.navigationItem.rightBarButtonItem = ruleButton;
    
    [self updateData];
}

- (void)pushBaseStatisticsViewController {
    ConditionTrendBaseStatisticsViewController *viewController = [[ConditionTrendBaseStatisticsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 更新数据
- (void)updateData {
    _conditionArray = [NSMutableArray arrayWithCapacity:1];
    _resultArray = [NSMutableArray arrayWithCapacity:1];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // 显示进度指示器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // 后台操作
        DataManager *dataManager = [DataManager shared];
        NSArray *winnings = [dataManager readAllWinningInFileUseReverse];
        _recentTwoTermWinnings = [winnings subarrayWithRange:NSMakeRange(winnings.count-2, 2)];
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
        
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.allowsSelection = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 注册Cell
        [_tableView registerClass:[WinningSimpleCell class] forCellReuseIdentifier:@"simpleCell"];
        [_tableView registerClass:[ConditionCell class] forCellReuseIdentifier:@"conditionCell"];
        [_tableView registerClass:[ButtonCell class] forCellReuseIdentifier:@"buttonCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _recentTwoTermWinnings.count;
        case 1:
            return _conditionArray.count;
        case 2:
            return 1;
        case 3:
            return _resultArray.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            WinningSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleCell"];
            Winning *winning = _recentTwoTermWinnings[indexPath.row];
            UILabel *termLabel = [cell.contentView viewWithTag:101];
            WinningBaseView *winningBaseView = [cell.contentView viewWithTag:102];
            termLabel.text = winning.term;
            winningBaseView.texts = winning.balls;
            [winningBaseView setSpecies:kIsDLT];
            return cell;
        }
        case 1: {
            ConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conditionCell"];
            while ([cell.contentView.subviews lastObject] != nil) {
                [[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            NSArray *selected = _conditionArray[indexPath.row];
            [cell setConditionBalls:selected andState:indexPath.row];
            return cell;
        }
        case 2: {
            ButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell"];
            [buttonCell.addButton setTitle:@"条件号码" forState:UIControlStateNormal];
            [buttonCell.addButton addTarget:self
                                     action:@selector(addAction)
                           forControlEvents:UIControlEventTouchUpInside];
            [buttonCell.clearButton addTarget:self
                                       action:@selector(clearAction)
                             forControlEvents:UIControlEventTouchUpInside];
            [buttonCell.calculateButton setTitle:@"计算" forState:UIControlStateNormal];
            [buttonCell.calculateButton addTarget:self
                                           action:@selector(calculateAction)
                                 forControlEvents:UIControlEventTouchUpInside];
            return buttonCell;
        }
        case 3: {
            WinningSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleCell"];
            Winning *winning = _resultArray[indexPath.row];
            UILabel *termLabel = [cell.contentView viewWithTag:101];
            WinningBaseView *winningBaseView = [cell.contentView viewWithTag:102];
            termLabel.text = winning.term;
            winningBaseView.texts = winning.balls;
            [winningBaseView setSpecies:kIsDLT];
            return cell;
        }
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        case 3:
            return [WinningSimpleCell heightOfCell];
        case 1:
            return [ConditionCell heightOfCell];
        case 2:
            return [ButtonCell heightOfCell];
        default:
            return 0.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 20.0f;
        case 1:
            return _conditionArray.count == 0 ? 0.0f : 20.0f;
        case 3:
            return _resultArray.count == 0 ? 0.0f : 20.0f;
        default:
            return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20.0f)];
    headerLabel.backgroundColor = kRedColor;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor whiteColor];
    switch (section) {
        case 0:
            headerLabel.text = @"最近2期获奖号码";
            break;
        case 1:
            headerLabel.text = @"条件号码";
            break;
        case 3:
            headerLabel.text = @"符合条件的获奖号码";
            break;
        default:
            break;
    }
    return headerLabel;
}



#pragma mark - 按钮动作
- (void)addAction {
    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"条件"
                                            message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                     preferredStyle:UIAlertControllerStyleAlert];
    BallListView *redsView = [[BallListView alloc] initIsDLT:YES
                                                    andIsRed:YES
                                                  andHasNull:YES
                                                  andColumns:6];
    CGRect frame = CGRectMake(16.0f,
                              50.0f,
                              redsView.frame.size.width,
                              redsView.frame.size.height);
    redsView.frame = frame;
    [alert.view addSubview:redsView];
    
    UIAlertAction *defaultAction =
        [UIAlertAction actionWithTitle:@"确认"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   // 错误处理
                                   if (_conditionArray.count > 4) {
                                       [MBProgressHUD warnInView:self.view
                                                         andText:@"您的条件太多了！"
                                                        andDelay:2.0f];
                                   } else {
                                       NSMutableArray *selectedBalls = [NSMutableArray arrayWithCapacity:5];
                                       for (BallButton *ballButton in redsView.balls) {
                                           if (ballButton.isSelected) {
                                               [selectedBalls addObject:ballButton.titleLabel.text];
                                           }
                                       }
                                       if (selectedBalls.count != 0) {
                                           // 1、最多只能选择5个红球
                                           if (selectedBalls.count > 5) {
                                               [MBProgressHUD warnInView:self.view
                                                                 andText:@"最多只能选择5个红球！"
                                                                andDelay:2.0f];
                                           } else {
                                               // 2、选择了“空”
                                               if ([[selectedBalls lastObject] isEqualToString:@"空"]) {
                                                   [_conditionArray addObject:@[]];
                                               } else {
                                                   [_conditionArray addObject:selectedBalls];
                                               }
                                               // 延时机制。消除警告
                                               dispatch_after((dispatch_time_t) 0.2,
                                                              dispatch_get_main_queue(), ^{
                                                                  // 刷新表格
                                                                  [self.tableView reloadData];
                                                              });
                                           }
                                       }
                                   }
                               }];
    [defaultAction setValue:kRedColor forKey:@"titleTextColor"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
    [cancelAction setValue:kRedColor forKey:@"titleTextColor"];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clearAction {
    [self.conditionArray removeAllObjects];
    self.resultArray = @[];
    [self.tableView reloadData];
}

- (void)calculateAction {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        StatisticsData *statisticsData = [StatisticsData shared];
        _resultArray = [statisticsData nextWinningOfConformConditionWithMultipleCondition:_conditionArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_resultArray.count == 0) {
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"没有符合条件的数据";
                [hud hideAnimated:YES afterDelay:2.0f];
            } else {
                [self.tableView reloadData];
                [hud hideAnimated:YES];
            }
        });
    });
}

@end
